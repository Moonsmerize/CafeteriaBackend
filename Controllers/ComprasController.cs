using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using CafeteriaBackend.DTOs;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class ComprasController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public ComprasController(CafeteriaContext context)
        {
            _context = context;
        }

        // POST: api/Compras/orden
        [HttpPost("orden")]
        public async Task<IActionResult> CrearOrdenCompra(OrdenCompraDto ordenDto)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (!long.TryParse(userIdStr, out long userId)) return Unauthorized();

                var proveedor = await _context.Proveedores.FindAsync(ordenDto.IdProveedor);
                if (proveedor == null) return BadRequest("Proveedor no encontrado");

                var nuevaOrden = new OrdenCompra
                {
                    IdProveedor = ordenDto.IdProveedor,
                    IdUsuarioSolicitante = userId,
                    FechaOrden = DateTime.UtcNow,
                    Estado = "PENDIENTE",
                    Total = 0
                };

                _context.OrdenCompras.Add(nuevaOrden);
                await _context.SaveChangesAsync();

                decimal totalCalculado = 0;

                foreach (var item in ordenDto.Detalles)
                {
                    var insumo = await _context.Inventarios.FindAsync(item.IdInventario);
                    if (insumo == null) throw new Exception($"Insumo {item.IdInventario} no encontrado");

                    var detalle = new DetalleOrdenCompra
                    {
                        IdOrdenCompra = nuevaOrden.Id,
                        IdInventario = item.IdInventario,
                        CantidadSolicitada = item.CantidadSolicitada,
                        CostoPactado = item.CostoPactado
                    };

                    _context.DetalleOrdenCompras.Add(detalle);
                    totalCalculado += (item.CantidadSolicitada * item.CostoPactado);
                }

                nuevaOrden.Total = totalCalculado;
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return Ok(new { mensaje = "Orden generada", idOrden = nuevaOrden.Id });
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return BadRequest($"Error: {ex.Message}");
            }
        }

        // GET: api/Compras/ordenes
        [HttpGet("ordenes")]
        public async Task<ActionResult<IEnumerable<object>>> GetHistorialOrdenes()
        {
            var ordenes = await _context.OrdenCompras
                .Include(o => o.Proveedor)
                .Include(o => o.UsuarioSolicitante)
                .OrderByDescending(o => o.FechaOrden)
                .Select(o => new
                {
                    o.Id,
                    Proveedor = o.Proveedor.NombreEmpresa,
                    Solicitante = o.UsuarioSolicitante.NombreCompleto,
                    Fecha = o.FechaOrden,
                    o.Total,
                    o.Estado,
                    ItemsCount = o.Detalles.Count
                })
                .ToListAsync();

            return Ok(ordenes);
        }

        // PUT: api/Compras/orden/5/recepcion
        [HttpPut("orden/{id}/recepcion")]
        public async Task<IActionResult> ConfirmarRecepcion(long id)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var orden = await _context.OrdenCompras
                    .Include(o => o.Detalles)
                    .FirstOrDefaultAsync(o => o.Id == id);

                if (orden == null) return NotFound("Orden no encontrada");

                if (orden.Estado == "RECIBIDA") return BadRequest("Esta orden ya fue recibida anteriormente.");
                if (orden.Estado == "CANCELADA") return BadRequest("No se puede recibir una orden cancelada.");

                foreach (var detalle in orden.Detalles)
                {
                    var insumo = await _context.Inventarios.FindAsync(detalle.IdInventario);
                    if (insumo != null)
                    {
                        insumo.StockActual += detalle.CantidadSolicitada;

                    }
                }

                orden.Estado = "RECIBIDA";
                orden.FechaEntregaEstimada = DateTime.UtcNow;

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return Ok(new { mensaje = "Recepción confirmada y stock actualizado." });
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return BadRequest($"Error al recibir: {ex.Message}");
            }
        }
    }
}
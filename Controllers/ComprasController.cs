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

        [HttpPost("orden")]
        public async Task<IActionResult> CrearOrdenCompra(OrdenCompraDto ordenDto)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (!long.TryParse(userIdStr, out long userId))
                {
                    return Unauthorized("No se pudo identificar al usuario.");
                }

                var proveedor = await _context.Proveedores.FindAsync(ordenDto.IdProveedor);
                if (proveedor == null)
                {
                    return BadRequest($"El proveedor con ID {ordenDto.IdProveedor} no existe.");
                }
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
                    if (insumo == null)
                    {
                        throw new Exception($"El insumo con ID {item.IdInventario} no existe en el inventario.");
                    }

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
                _context.Entry(nuevaOrden).State = EntityState.Modified;

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return Ok(new
                {
                    mensaje = "Orden de compra generada exitosamente",
                    idOrden = nuevaOrden.Id,
                    total = totalCalculado
                });
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return BadRequest($"Error al procesar la orden: {ex.Message}");
            }
        }
    }
}
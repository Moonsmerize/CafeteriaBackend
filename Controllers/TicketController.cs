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
    [Authorize]
    public class TicketController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public TicketController(CafeteriaContext context)
        {
            _context = context;
        }

        // POST: api/Ticket/venta
        [HttpPost("venta")]
        public async Task<IActionResult> ProcesarVenta(VentaDto venta)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                long userId = long.Parse(userIdStr ?? "0");

                var cajaAbierta = await _context.Cajas
                    .Where(c => c.Estado == "ABIERTA")
                    .OrderByDescending(c => c.FechaApertura)
                    .FirstOrDefaultAsync();

                if (cajaAbierta == null)
                    return BadRequest("No hay ninguna caja abierta. Abre una caja primero.");

                // Crear el Ticket 
                var nuevoTicket = new Ticket
                {
                    IdCaja = cajaAbierta.Id,
                    IdUsuario = userId,
                    FechaEmision = DateTime.UtcNow,
                    TotalVenta = venta.Productos.Sum(p => p.Cantidad * p.PrecioUnitario),
                    MetodoPago = "EFECTIVO",
                    Estado = "PAGADO"
                };

                _context.Tickets.Add(nuevoTicket);
                await _context.SaveChangesAsync(); 

                foreach (var item in venta.Productos)
                {
                    var detalle = new DetalleTicket
                    {
                        IdTicket = nuevoTicket.Id,
                        IdProducto = item.IdProducto,
                        Cantidad = item.Cantidad,
                        PrecioUnitario = item.PrecioUnitario,
                        Subtotal = item.Cantidad * item.PrecioUnitario
                    };
                    _context.DetalleTickets.Add(detalle);

                    var receta = await _context.Recetas
                        .Where(r => r.IdProducto == item.IdProducto)
                        .ToListAsync();

                    if (receta.Any())
                    {
                        foreach (var ingrediente in receta)
                        {
                            decimal cantidadDescontar = ingrediente.CantidadRequerida * item.Cantidad;

                            var insumo = await _context.Inventarios.FindAsync(ingrediente.IdInventario);
                            if (insumo != null)
                            {
                                if (insumo.StockActual < cantidadDescontar) throw new Exception($"Sin stock de {insumo.Nombre}");

                                insumo.StockActual -= cantidadDescontar;
                                _context.Entry(insumo).State = EntityState.Modified;
                            }
                        }
                    }
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync(); 

                return Ok(new { mensaje = "Venta registrada con éxito", ticketId = nuevoTicket.Id });
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return BadRequest($"Error procesando la venta: {ex.Message}");
            }
        }
    }
}
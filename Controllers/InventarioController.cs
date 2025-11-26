using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using Microsoft.AspNetCore.Authorization;

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InventarioController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public InventarioController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Inventario
        [HttpGet]
        [Authorize(Roles = "Admin,Proveedor")]
        public async Task<ActionResult<IEnumerable<Inventario>>> GetInventarios()
        {
            return await _context.Inventarios.OrderBy(i => i.Nombre).ToListAsync();
        }

        // GET: api/Inventario/5
        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,Proveedor")]
        public async Task<ActionResult<Inventario>> GetInventario(long id)
        {
            var inventario = await _context.Inventarios.FindAsync(id);

            if (inventario == null)
            {
                return NotFound();
            }

            return inventario;
        }

        // POST: api/Inventario
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<Inventario>> PostInventario(Inventario inventario)
        {
            _context.Inventarios.Add(inventario);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetInventario", new { id = inventario.Id }, inventario);
        }

        // PUT: api/Inventario/5
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutInventario(long id, Inventario inventario)
        {
            if (id != inventario.Id)
            {
                return BadRequest("ID no coincide");
            }

            _context.Entry(inventario).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_context.Inventarios.Any(e => e.Id == id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/Inventario/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteInventario(long id)
        {
            var inventario = await _context.Inventarios.FindAsync(id);
            if (inventario == null)
            {
                return NotFound();
            }

            _context.Inventarios.Remove(inventario);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // GET: api/Inventario/{id}/proveedores
        [HttpGet("{id}/proveedores")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<IEnumerable<object>>> GetProveedoresPorInsumo(long id)
        {
            if (!await _context.Inventarios.AnyAsync(i => i.Id == id))
            {
                return NotFound("El insumo no existe.");
            }

            var proveedores = await _context.RelProveedorInventarios
                .Include(r => r.Proveedor)
                .Where(r => r.IdInventario == id && r.Proveedor.Activo == true)
                .Select(r => new
                {
                    IdProveedor = r.IdProveedor,
                    NombreEmpresa = r.Proveedor.NombreEmpresa,
                    UltimoCosto = r.PrecioUltimoCosto,
                    CodigoCatalogo = r.CodigoCatalogoProveedor
                })
                .OrderBy(x => x.UltimoCosto) // Sugerimos el más barato primero
                .ToListAsync();

            return Ok(proveedores);
        }
    }
}
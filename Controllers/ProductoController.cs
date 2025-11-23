using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using Microsoft.AspNetCore.Authorization;

/* 
    [Authorize] obliga a que se envie el Token para usar los metodos.
    el producto se puede desactivar, no eliminar fisicamente 
para mantener ordenes antiguas que contenian ese producto.
*/

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductosController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public ProductosController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Productos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Producto>>> GetProductos()
        {
            return await _context.Productos
                                 .Where(p => p.Activo == true)
                                 .ToListAsync();
        }

        // GET: api/Productos/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Producto>> GetProducto(long id)
        {
            var producto = await _context.Productos.FindAsync(id);

            if (producto == null)
            {
                return NotFound();
            }

            return producto;
        }

        // POST: api/Productos
        [HttpPost]
        [Authorize]
        public async Task<ActionResult<Producto>> PostProducto(Producto producto)
        {
            if (producto.Activo == null) producto.Activo = true;

            _context.Productos.Add(producto);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProducto", new { id = producto.Id }, producto);
        }

        // PUT: api/Productos/5
        [HttpPut("{id}")]
        [Authorize]
        public async Task<IActionResult> PutProducto(long id, Producto producto)
        {
            if (id != producto.Id)
            {
                return BadRequest("El ID de la URL no coincide con el cuerpo de la petición.");
            }

            _context.Entry(producto).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductoExists(id))
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

        // DELETE: api/Productos/5
        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteProducto(long id)
        {
            var producto = await _context.Productos.FindAsync(id);
            if (producto == null)
            {
                return NotFound();
            }

            producto.Activo = false;
            _context.Entry(producto).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProductoExists(long id)
        {
            return _context.Productos.Any(e => e.Id == id);
        }
    }
}
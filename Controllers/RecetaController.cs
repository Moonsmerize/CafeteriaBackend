using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using Microsoft.AspNetCore.Authorization;

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class RecetaController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public RecetaController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Receta/Producto/5
        [HttpGet("Producto/{idProducto}")]
        public async Task<ActionResult<IEnumerable<Receta>>> GetRecetasPorProducto(long idProducto)
        {
            return await _context.Recetas
                .Include(r => r.Inventario)
                .Where(r => r.IdProducto == idProducto)
                .ToListAsync();
        }

        // POST: api/Receta
        [HttpPost]
        public async Task<ActionResult<Receta>> PostReceta(Receta receta)
        {
            if (receta.CantidadRequerida <= 0)
                return BadRequest("La cantidad debe ser mayor a 0");

            if (!await _context.Productos.AnyAsync(p => p.Id == receta.IdProducto))
                return BadRequest("El producto no existe");

            if (!await _context.Inventarios.AnyAsync(i => i.Id == receta.IdInventario))
                return BadRequest("El ingrediente no existe");

            _context.Recetas.Add(receta);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetReceta", new { id = receta.Id }, receta);
        }

        // GET: api/Receta
        [HttpGet("{id}")]
        public async Task<ActionResult<Receta>> GetReceta(long id)
        {
            var receta = await _context.Recetas.FindAsync(id);
            if (receta == null) return NotFound();
            return receta;
        }

        // DELETE: api/Receta
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReceta(long id)
        {
            var receta = await _context.Recetas.FindAsync(id);
            if (receta == null) return NotFound();

            _context.Recetas.Remove(receta);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
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
    public class InventarioController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public InventarioController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Inventario
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Inventario>>> GetInventarios()
        {
            return await _context.Inventarios.OrderBy(i => i.Nombre).ToListAsync();
        }

        // GET: api/Inventario
        [HttpGet("{id}")]
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
        public async Task<ActionResult<Inventario>> PostInventario(Inventario inventario)
        {
            _context.Inventarios.Add(inventario);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetInventario", new { id = inventario.Id }, inventario);
        }

        // PUT: api/Inventario
        [HttpPut("{id}")]
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

        // DELETE: api/Inventario
        [HttpDelete("{id}")]
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
    }
}
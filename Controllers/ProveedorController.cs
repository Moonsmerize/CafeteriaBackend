using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using Microsoft.AspNetCore.Authorization;

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")] // Solo admins pueden gestionar proveedores
    public class ProveedorController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public ProveedorController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Proveedor
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Proveedor>>> GetProveedores()
        {
            return await _context.Proveedores
                .Where(p => p.Activo == true)
                .OrderBy(p => p.NombreEmpresa)
                .ToListAsync();
        }

        // GET: api/Proveedor/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Proveedor>> GetProveedor(long id)
        {
            var proveedor = await _context.Proveedores.FindAsync(id);
            if (proveedor == null) return NotFound();
            return proveedor;
        }

        // POST: api/Proveedor
        [HttpPost]
        public async Task<ActionResult<Proveedor>> PostProveedor(Proveedor proveedor)
        {
            if (proveedor.Activo == null) proveedor.Activo = true;

            _context.Proveedores.Add(proveedor);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProveedor", new { id = proveedor.Id }, proveedor);
        }

        // PUT: api/Proveedor/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProveedor(long id, Proveedor proveedor)
        {
            if (id != proveedor.Id) return BadRequest("ID no coincide");

            _context.Entry(proveedor).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_context.Proveedores.Any(e => e.Id == id)) return NotFound();
                else throw;
            }

            return NoContent();
        }

        // DELETE: api/Proveedor/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProveedor(long id)
        {
            var proveedor = await _context.Proveedores.FindAsync(id);
            if (proveedor == null) return NotFound();

            // Borrado lógico
            proveedor.Activo = false;
            _context.Entry(proveedor).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
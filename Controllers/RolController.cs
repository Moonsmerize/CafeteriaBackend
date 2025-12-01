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
    public class RolController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public RolController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Rol
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Rol>>> GetRoles()
        {
            return await _context.Roles
                .Include(r => r.Permisos)
                .OrderBy(r => r.Id)
                .ToListAsync();
        }

        // PUT: api/Rol/5/permisos
        [HttpPut("{id}/permisos")]
        public async Task<IActionResult> UpdateRolPermisos(long id, [FromBody] List<long> permisosIds)
        {
            var rol = await _context.Roles
                .Include(r => r.Permisos)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (rol == null) return NotFound("Rol no encontrado");

            if (rol.Nombre == "Admin" && permisosIds.Count == 0)
            {
                return BadRequest("No puedes dejar al rol Admin sin permisos.");
            }

            rol.Permisos.Clear();

            var nuevosPermisos = await _context.Permisos
                .Where(p => permisosIds.Contains(p.Id))
                .ToListAsync();

            foreach (var permiso in nuevosPermisos)
            {
                rol.Permisos.Add(permiso);
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
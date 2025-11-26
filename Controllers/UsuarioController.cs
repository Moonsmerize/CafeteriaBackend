using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using CafeteriaBackend.DTOs;
using Microsoft.AspNetCore.Authorization;

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class UsuarioController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public UsuarioController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Usuario
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Usuario>>> GetUsuarios()
        {
            return await _context.Usuarios
                .Include(u => u.Roles)
                .OrderBy(u => u.NombreCompleto)
                .ToListAsync();
        }

        // PUT: api/Usuario/5/roles
        [HttpPut("{id}/roles")]
        public async Task<IActionResult> UpdateUserRoles(long id, [FromBody] List<long> roleIds)
        {

            var usuario = await _context.Usuarios
                .Include(u => u.Roles)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (usuario == null) return NotFound();

            usuario.Roles.Clear();

            var rolesToAdd = await _context.Roles
                .Where(r => roleIds.Contains(r.Id))
                .ToListAsync();

            foreach (var rol in rolesToAdd)
            {
                usuario.Roles.Add(rol);
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
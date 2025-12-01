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

        // POST: api/Usuario
        [HttpPost]
        public async Task<ActionResult<Usuario>> PostUsuario(RegistroDto usuarioDto)
        {
            if (await _context.Usuarios.AnyAsync(u => u.Email == usuarioDto.Email))
            {
                return BadRequest("El correo ya está registrado.");
            }

            var rol = await _context.Roles.FindAsync(usuarioDto.IdRol);
            if (rol == null)
            {
                return BadRequest("El rol seleccionado no es válido.");
            }

            string passwordHash = BCrypt.Net.BCrypt.HashPassword(usuarioDto.Password);
            var nuevoUsuario = new Usuario
            {
                NombreCompleto = usuarioDto.NombreCompleto,
                Email = usuarioDto.Email,
                PasswordHash = passwordHash,
                Activo = true, 
                FechaCreacion = DateTime.UtcNow
            };

            nuevoUsuario.Roles.Add(rol);

            _context.Usuarios.Add(nuevoUsuario);
            await _context.SaveChangesAsync();

            return Ok(new { mensaje = "Usuario creado exitosamente", id = nuevoUsuario.Id });
        }

        // PUT: api/Usuario/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUsuario(long id, ActualizarUsuarioDto usuarioDto)
        {
            if (id != usuarioDto.Id)
            {
                return BadRequest("El ID de la URL no coincide con el cuerpo de la petición.");
            }

            var usuario = await _context.Usuarios
                .Include(u => u.Roles)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (usuario == null)
            {
                return NotFound("Usuario no encontrado.");
            }

            usuario.NombreCompleto = usuarioDto.NombreCompleto;
            usuario.Email = usuarioDto.Email;
            usuario.Activo = usuarioDto.Activo;
            if (!string.IsNullOrEmpty(usuarioDto.Password))
            {
                usuario.PasswordHash = BCrypt.Net.BCrypt.HashPassword(usuarioDto.Password);
            }
            var rolActual = usuario.Roles.FirstOrDefault();
            if (rolActual == null || rolActual.Id != usuarioDto.IdRol)
            {
                var nuevoRol = await _context.Roles.FindAsync(usuarioDto.IdRol);
                if (nuevoRol != null)
                {
                    usuario.Roles.Clear(); 
                    usuario.Roles.Add(nuevoRol);
                }
            }

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_context.Usuarios.Any(e => e.Id == id))
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

        // DELETE: api/Usuario/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUsuario(long id)
        {
            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario == null)
            {
                return NotFound();
            }

            usuario.Activo = false;
            _context.Entry(usuario).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return NoContent();
        }

    }

}
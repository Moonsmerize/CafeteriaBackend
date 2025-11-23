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
    [Authorize(Roles = "Admin")] // ¡Seguridad! Solo el Admin toca esto
    public class UsuarioController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public UsuarioController(CafeteriaContext context)
        {
            _context = context;
        }

        // GET: api/Usuario
        // Lista todos los usuarios con su Rol
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Usuario>>> GetUsuarios()
        {
            return await _context.Usuarios
                .Include(u => u.Rol) // Importante para ver si es Admin o Empleado
                .OrderBy(u => u.NombreCompleto)
                .ToListAsync();
        }

        // GET: api/Usuario/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Usuario>> GetUsuario(long id)
        {
            var usuario = await _context.Usuarios
                .Include(u => u.Rol)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (usuario == null)
            {
                return NotFound();
            }

            return usuario;
        }

        // POST: api/Usuario
        [HttpPost]
        public async Task<ActionResult<Usuario>> PostUsuario(RegistroDto request)
        {
            if (await _context.Usuarios.AnyAsync(u => u.Email == request.Email))
            {
                return BadRequest("El correo ya existe.");
            }

            string passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

            var usuario = new Usuario
            {
                NombreCompleto = request.NombreCompleto,
                Email = request.Email,
                PasswordHash = passwordHash,
                IdRol = request.IdRol,
                Activo = true,
                FechaCreacion = DateTime.UtcNow
            };

            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUsuario", new { id = usuario.Id }, usuario);
        }

        // PUT: api/Usuario/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUsuario(long id, Usuario usuario)
        {
            if (id != usuario.Id)
            {
                return BadRequest("El ID no coincide.");
            }

            var usuarioExistente = await _context.Usuarios.FindAsync(id);
            if (usuarioExistente == null) return NotFound();

            usuarioExistente.NombreCompleto = usuario.NombreCompleto;
            usuarioExistente.Email = usuario.Email;
            usuarioExistente.IdRol = usuario.IdRol;
            usuarioExistente.Activo = usuario.Activo;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UsuarioExists(id))
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
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UsuarioExists(long id)
        {
            return _context.Usuarios.Any(e => e.Id == id);
        }
    }
}
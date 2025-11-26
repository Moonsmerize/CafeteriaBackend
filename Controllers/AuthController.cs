using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using CafeteriaBackend.DTOs;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly CafeteriaContext _context;
        private readonly IConfiguration _configuration;

        public AuthController(CafeteriaContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        // POST: api/auth/registro
        [HttpPost("registro")]
        public async Task<ActionResult<Usuario>> Registrar(RegistroDto request)
        {
            if (await _context.Usuarios.AnyAsync(u => u.Email == request.Email))
            {
                return BadRequest("El correo ya está registrado.");
            }

            // 2. Validar que el rol inicial exista
            var rolInicial = await _context.Roles.FindAsync(request.IdRol);
            if (rolInicial == null)
            {
                return BadRequest($"El Rol con ID {request.IdRol} no existe.");
            }

            // 3. Encriptar contraseña
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

            var nuevoUsuario = new Usuario
            {
                NombreCompleto = request.NombreCompleto,
                Email = request.Email,
                PasswordHash = passwordHash,
                Activo = true,
                FechaCreacion = DateTime.UtcNow
            };

            nuevoUsuario.Roles.Add(rolInicial);

            _context.Usuarios.Add(nuevoUsuario);
            await _context.SaveChangesAsync();

            return Ok(new { mensaje = "Usuario registrado exitosamente" });
        }

        // POST: api/auth/login
        [HttpPost("login")]
        public async Task<ActionResult<object>> Login(LoginDto request)
        {
            var usuario = await _context.Usuarios
                .Include(u => u.Roles) 
                .FirstOrDefaultAsync(u => u.Email == request.Email);

            if (usuario == null || !BCrypt.Net.BCrypt.Verify(request.Password, usuario.PasswordHash))
            {
                return BadRequest("Usuario o contraseña incorrectos.");
            }

            if (usuario.Activo == false)
            {
                return Unauthorized("Tu cuenta está desactivada. Contacta al administrador.");
            }

            string token = CrearToken(usuario);

            var primerRol = usuario.Roles.FirstOrDefault();

            return Ok(new
            {
                token = token,
                usuario = usuario.NombreCompleto,
                rol = primerRol?.Nombre ?? "Sin Rol",
                rolId = primerRol?.Id ?? 0,
                roles = usuario.Roles.Select(r => r.Nombre).ToList()
            });
        }

        private string CrearToken(Usuario usuario)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, usuario.Id.ToString()),
                new Claim(ClaimTypes.Name, usuario.Email)
            };
            foreach (var rol in usuario.Roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, rol.Nombre));
            }

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                _configuration.GetSection("Jwt:Key").Value!));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddMinutes(60),
                SigningCredentials = creds
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }
    }
}
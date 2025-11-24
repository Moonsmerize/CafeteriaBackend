using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Data;
using CafeteriaBackend.Models;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace CafeteriaBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Proveedor")]
    public class PortalProveedorController : ControllerBase
    {
        private readonly CafeteriaContext _context;

        public PortalProveedorController(CafeteriaContext context)
        {
            _context = context;
        }

        private async Task<Proveedor?> GetCurrentProveedor()
        {
            var email = User.FindFirstValue(ClaimTypes.Name); // Email del token JWT
            if (string.IsNullOrEmpty(email)) return null;
            return await _context.Proveedores.FirstOrDefaultAsync(p => p.Email == email);
        }

        [HttpGet("perfil")]
        public async Task<ActionResult<Proveedor>> GetMiPerfil()
        {
            var proveedor = await GetCurrentProveedor();
            if (proveedor == null) return NotFound("Perfil de proveedor no asociado a este usuario.");
            return proveedor;
        }

        [HttpPut("perfil")]
        public async Task<IActionResult> UpdateMiPerfil(Proveedor datos)
        {
            var proveedor = await GetCurrentProveedor();
            if (proveedor == null) return NotFound();

            proveedor.NombreContacto = datos.NombreContacto;
            proveedor.Telefono = datos.Telefono;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpGet("productos")]
        public async Task<ActionResult<IEnumerable<object>>> GetMisProductos()
        {
            var proveedor = await GetCurrentProveedor();
            if (proveedor == null) return NotFound();

            var productos = await _context.RelProveedorInventarios
                .Include(r => r.Inventario)
                .Where(r => r.IdProveedor == proveedor.Id)
                .Select(r => new
                {
                    r.Id, 
                    Insumo = r.Inventario!.Nombre,
                    Descripcion = r.Inventario.Descripcion,
                    r.PrecioUltimoCosto,
                    r.CodigoCatalogoProveedor
                })
                .ToListAsync();

            return Ok(productos);
        }

        [HttpPut("producto/{idRelacion}")]
        public async Task<IActionResult> UpdateProductoCosto(long idRelacion, [FromBody] RelProveedorInventario datos)
        {
            var proveedor = await GetCurrentProveedor();
            if (proveedor == null) return Unauthorized();

            var relacion = await _context.RelProveedorInventarios.FindAsync(idRelacion);

            if (relacion == null || relacion.IdProveedor != proveedor.Id)
                return NotFound();

            relacion.PrecioUltimoCosto = datos.PrecioUltimoCosto;
            relacion.CodigoCatalogoProveedor = datos.CodigoCatalogoProveedor;

            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
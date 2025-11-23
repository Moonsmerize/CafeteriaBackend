using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("rol")]
    public class Rol
    {
        [Column("id")]
        public long Id { get; set; }
        [Column("nombre")]
        public string Nombre { get; set; } = null!;
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        // Relación Muchos a Muchos con Permisos
        public virtual ICollection<Permiso> Permisos { get; set; } = new List<Permiso>();
        public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
    }

    [Table("permiso")]
    public class Permiso
    {
        [Column("id")]
        public long Id { get; set; }
        [Column("nombre")]
        public string Nombre { get; set; } = null!;
        [Column("codigo_interno")]
        public string CodigoInterno { get; set; } = null!;

        public virtual ICollection<Rol> Roles { get; set; } = new List<Rol>();
    }
}
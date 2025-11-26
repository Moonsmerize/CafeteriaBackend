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
        public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
        public virtual ICollection<Permiso> Permisos { get; set; } = new List<Permiso>();
    }
}
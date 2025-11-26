using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("usuario")]
    public class Usuario
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("nombre_completo")]
        public string NombreCompleto { get; set; } = null!;

        [Column("email")]
        public string Email { get; set; } = null!;

        [Column("password_hash")]
        public string PasswordHash { get; set; } = null!;

        [Column("activo")]
        public bool? Activo { get; set; }

        [Column("fecha_creacion")]
        public DateTime? FechaCreacion { get; set; }

        public virtual ICollection<Rol> Roles { get; set; } = new List<Rol>();
        public virtual ICollection<Caja> CajasApertura { get; set; } = new List<Caja>();
        public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();
    }
}
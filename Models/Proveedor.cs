using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("proveedor")]
    public class Proveedor
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("nombre_empresa")]
        public string NombreEmpresa { get; set; } = null!;

        [Column("nombre_contacto")]
        public string? NombreContacto { get; set; }

        [Column("telefono")]
        public string? Telefono { get; set; }

        [Column("email")]
        public string? Email { get; set; }

        [Column("activo")]
        public bool? Activo { get; set; }
    }
}
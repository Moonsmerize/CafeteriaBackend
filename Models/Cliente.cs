using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("cliente")]
    public class Cliente
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("nombre")]
        public string? Nombre { get; set; }

        [Column("telefono")]
        public string? Telefono { get; set; }

        [Column("email")]
        public string? Email { get; set; }

        [Column("nit_rfc")]
        public string? NitRfc { get; set; }

        [Column("puntos_acumulados")]
        public int? PuntosAcumulados { get; set; }
    }
}
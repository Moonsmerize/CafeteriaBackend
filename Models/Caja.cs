using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("caja")]
    public class Caja
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("id_usuario_apertura")]
        public long IdUsuarioApertura { get; set; }

        [Column("id_usuario_cierre")]
        public long? IdUsuarioCierre { get; set; }

        [Column("fecha_apertura")]
        public DateTime? FechaApertura { get; set; }

        [Column("fecha_cierre")]
        public DateTime? FechaCierre { get; set; }

        [Column("monto_inicial")]
        public decimal MontoInicial { get; set; }

        [Column("monto_final_sistema")]
        public decimal? MontoFinalSistema { get; set; }

        [Column("monto_final_real")]
        public decimal? MontoFinalReal { get; set; }

        [Column("estado")]
        public string? Estado { get; set; }

        // Propiedades de navegación (se configuran en el DbContext)
        public virtual Usuario? UsuarioApertura { get; set; }
        public virtual Usuario? UsuarioCierre { get; set; }
    }
}
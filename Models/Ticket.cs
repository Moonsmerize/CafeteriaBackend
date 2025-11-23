using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("ticket")]
    public class Ticket
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("id_caja")]
        public long IdCaja { get; set; }

        [Column("id_cliente")]
        public long? IdCliente { get; set; }

        [Column("id_usuario")]
        public long IdUsuario { get; set; }

        [Column("fecha_emision")]
        public DateTime? FechaEmision { get; set; }

        [Column("total_venta")]
        public decimal TotalVenta { get; set; }

        [Column("metodo_pago")]
        public string? MetodoPago { get; set; }

        [Column("estado")]
        public string? Estado { get; set; }

        public virtual Caja? Caja { get; set; }
        public virtual Cliente? Cliente { get; set; }
        public virtual Usuario? Usuario { get; set; }

        public virtual ICollection<DetalleTicket> Detalles { get; set; } = new List<DetalleTicket>();
    }
}
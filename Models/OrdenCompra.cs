using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("orden_compra")]
    public class OrdenCompra
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("id_proveedor")]
        public long IdProveedor { get; set; }

        [Column("id_usuario_solicitante")]
        public long IdUsuarioSolicitante { get; set; }

        [Column("fecha_orden")]
        public DateTime? FechaOrden { get; set; }

        [Column("fecha_entrega_estimada")]
        public DateTime? FechaEntregaEstimada { get; set; }

        [Column("estado")]
        public string? Estado { get; set; }

        [Column("total")]
        public decimal Total { get; set; }

        // Navegación
        public virtual Proveedor? Proveedor { get; set; }
        public virtual Usuario? UsuarioSolicitante { get; set; }
        public virtual ICollection<DetalleOrdenCompra> Detalles { get; set; } = new List<DetalleOrdenCompra>();
    }
}
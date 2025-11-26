using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("detalle_orden_compra")]
    public class DetalleOrdenCompra
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("id_orden_compra")]
        public long IdOrdenCompra { get; set; }

        [Column("id_inventario")]
        public long IdInventario { get; set; }

        [Column("cantidad_solicitada")]
        public decimal CantidadSolicitada { get; set; }

        [Column("costo_pactado")]
        public decimal CostoPactado { get; set; }

        // Navegación
        public virtual OrdenCompra? OrdenCompra { get; set; }
        public virtual Inventario? Inventario { get; set; }
    }
}
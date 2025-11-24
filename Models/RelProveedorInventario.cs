using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("rel_proveedor_inventario")]
    public class RelProveedorInventario
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("id_proveedor")]
        public long IdProveedor { get; set; }

        [Column("id_inventario")]
        public long IdInventario { get; set; }

        [Column("precio_ultimo_costo")]
        public decimal? PrecioUltimoCosto { get; set; }

        [Column("codigo_catalogo_proveedor")]
        public string? CodigoCatalogoProveedor { get; set; }

        // Relaciones
        public virtual Proveedor? Proveedor { get; set; }
        public virtual Inventario? Inventario { get; set; }
    }
}
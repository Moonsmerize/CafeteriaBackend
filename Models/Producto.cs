using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("producto")]
    public class Producto
    {
        [Column("id")]
        public long Id { get; set; }
        [Column("nombre")]
        public string Nombre { get; set; } = null!;
        [Column("precio_venta")]
        public decimal PrecioVenta { get; set; }
        [Column("imagen_url")]
        public string? ImagenUrl { get; set; }
        [Column("categoria")]
        public string? Categoria { get; set; }
        [Column("es_compuesto")]
        public bool? EsCompuesto { get; set; }
        [Column("activo")]
        public bool? Activo { get; set; }

        public virtual ICollection<Receta> Recetas { get; set; } = new List<Receta>();
    }
}
using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
    [Table("inventario")]
    public class Inventario
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [Column("stock_actual")]
        public decimal? StockActual { get; set; }

        [Column("stock_minimo")]
        public decimal? StockMinimo { get; set; }

        [Column("costo_promedio")]
        public decimal? CostoPromedio { get; set; }
    }
}
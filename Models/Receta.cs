using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
	[Table("receta")]
	public class Receta
	{
		[Column("id")]
		public long Id { get; set; }

		[Column("id_producto")]
		public long IdProducto { get; set; }

		[Column("id_inventario")]
		public long IdInventario { get; set; }

		[Column("cantidad_requerida")]
		public decimal CantidadRequerida { get; set; }

		public virtual Producto? Producto { get; set; }
		public virtual Inventario? Inventario { get; set; }
	}
}
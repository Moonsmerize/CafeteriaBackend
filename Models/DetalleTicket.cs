using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
	[Table("detalle_ticket")]
	public class DetalleTicket
	{
		[Column("id")]
		public long Id { get; set; }

		[Column("id_ticket")]
		public long IdTicket { get; set; }

		[Column("id_producto")]
		public long IdProducto { get; set; }

		[Column("cantidad")]
		public int Cantidad { get; set; }

		[Column("precio_unitario")]
		public decimal PrecioUnitario { get; set; }

		[Column("subtotal")]
		public decimal Subtotal { get; set; }

		[System.Text.Json.Serialization.JsonIgnore]
		public virtual Ticket? Ticket { get; set; }
		public virtual Producto? Producto { get; set; }
	}
}
using System.ComponentModel.DataAnnotations.Schema;

namespace CafeteriaBackend.Models
{
	[Table("permiso")]
	public class Permiso
	{
		[Column("id")]
		public long Id { get; set; }
		[Column("nombre")]
		public string Nombre { get; set; } = null!;
		[Column("codigo_interno")]
		public string CodigoInterno { get; set; } = null!;

		public virtual ICollection<Rol> Roles { get; set; } = new List<Rol>();
	}
}
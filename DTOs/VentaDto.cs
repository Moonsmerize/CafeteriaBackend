namespace CafeteriaBackend.DTOs
{
    public class VentaDto
    {
        public List<DetalleVentaDto> Productos { get; set; } = new();
    }

    public class DetalleVentaDto
    {
        public long IdProducto { get; set; }
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; } 
    }
}
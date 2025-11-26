namespace CafeteriaBackend.DTOs
{
    public class OrdenCompraDto
    {
        public long IdProveedor { get; set; }
        public List<DetalleOrdenDto> Detalles { get; set; } = new();
    }

    public class DetalleOrdenDto
    {
        public long IdInventario { get; set; }
        public decimal CantidadSolicitada { get; set; }
        public decimal CostoPactado { get; set; } // Precio al momento de la compra
    }
}
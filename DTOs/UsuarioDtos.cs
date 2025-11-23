namespace CafeteriaBackend.DTOs
{
    public class RegistroDto
    {
        public string NombreCompleto { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
        public long IdRol { get; set; } = 2; // si no se envia nada el rol por defecto es 2
    }

    public class LoginDto
    {
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
    }
}
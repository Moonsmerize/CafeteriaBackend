using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Models;

namespace CafeteriaBackend.Data
{
    public class CafeteriaContext : DbContext
    {
        public CafeteriaContext(DbContextOptions<CafeteriaContext> options) : base(options) { }

        // 1. DBSETS: Representan las tablas en C#
        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Rol> Roles { get; set; }
        public DbSet<Permiso> Permisos { get; set; }
        public DbSet<Producto> Productos { get; set; }
        public DbSet<Receta> Recetas { get; set; }
        public DbSet<Inventario> Inventarios { get; set; }
        public DbSet<Proveedor> Proveedores { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Caja> Cajas { get; set; }
        public DbSet<Ticket> Tickets { get; set; }
        public DbSet<DetalleTicket> DetalleTickets { get; set; }

        // 2. CONFIGURACIÓN DETALLADA
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // --- Mapeo de nombres de tablas (para asegurar minúsculas) ---
            modelBuilder.Entity<Usuario>().ToTable("usuario");
            modelBuilder.Entity<Rol>().ToTable("rol");
            modelBuilder.Entity<Permiso>().ToTable("permiso");
            modelBuilder.Entity<Producto>().ToTable("producto");
            modelBuilder.Entity<Receta>().ToTable("receta");
            modelBuilder.Entity<Inventario>().ToTable("inventario");
            modelBuilder.Entity<Proveedor>().ToTable("proveedor");
            modelBuilder.Entity<Cliente>().ToTable("cliente");
            modelBuilder.Entity<Caja>().ToTable("caja");
            modelBuilder.Entity<Ticket>().ToTable("ticket");
            modelBuilder.Entity<DetalleTicket>().ToTable("detalle_ticket");

            // --- Configuración de Relaciones ---

            // 1. Muchos a Muchos: Roles <-> Permisos
            modelBuilder.Entity<Rol>()
                .HasMany(r => r.Permisos)
                .WithMany(p => p.Roles)
                .UsingEntity<Dictionary<string, object>>(
                    "roles_permisos",
                    j => j.HasOne<Permiso>().WithMany().HasForeignKey("id_permiso"),
                    j => j.HasOne<Rol>().WithMany().HasForeignKey("id_rol"),
                    j =>
                    {
                        j.HasKey("id_rol", "id_permiso");
                        j.ToTable("roles_permisos");
                    });

            // 2. Usuario -> Rol
            modelBuilder.Entity<Usuario>()
                .HasOne(u => u.Rol)
                .WithMany(r => r.Usuarios)
                .HasForeignKey(u => u.IdRol)
                .HasConstraintName("fk_usuario_rol");

            // 3. Receta (Producto <-> Inventario)
            modelBuilder.Entity<Receta>()
                .HasOne(r => r.Producto)
                .WithMany(p => p.Recetas)
                .HasForeignKey(r => r.IdProducto)
                .HasConstraintName("fk_receta_producto");

            modelBuilder.Entity<Receta>()
                .HasOne(r => r.Inventario)
                .WithMany()
                .HasForeignKey(r => r.IdInventario)
                .HasConstraintName("fk_receta_inventario");

            // 4. Caja (¡OJO! Tiene dos relaciones con Usuario)
            modelBuilder.Entity<Caja>()
                .HasOne(c => c.UsuarioApertura)
                .WithMany(u => u.CajasApertura) // Debes asegurarte de tener esta prop en Usuario
                .HasForeignKey(c => c.IdUsuarioApertura)
                .HasConstraintName("fk_caja_usuario");

            // La relación de cierre es opcional y no la pusimos en la clase Usuario para no saturarla,
            // así que la configuramos aquí sin navegación inversa obligatoria:
            modelBuilder.Entity<Caja>()
                .HasOne(c => c.UsuarioCierre)
                .WithMany()
                .HasForeignKey(c => c.IdUsuarioCierre);

            // 5. Ticket -> Caja, Cliente, Usuario
            modelBuilder.Entity<Ticket>()
                .HasOne(t => t.Caja)
                .WithMany()
                .HasForeignKey(t => t.IdCaja)
                .HasConstraintName("fk_ticket_caja");

            modelBuilder.Entity<Ticket>()
                .HasOne(t => t.Cliente)
                .WithMany()
                .HasForeignKey(t => t.IdCliente)
                .HasConstraintName("fk_ticket_cliente");

            modelBuilder.Entity<Ticket>()
                .HasOne(t => t.Usuario)
                .WithMany(u => u.Tickets)
                .HasForeignKey(t => t.IdUsuario)
                .HasConstraintName("fk_ticket_usuario");

            // 6. DetalleTicket -> Ticket, Producto
            modelBuilder.Entity<DetalleTicket>()
                .HasOne(d => d.Ticket)
                .WithMany(t => t.Detalles)
                .HasForeignKey(d => d.IdTicket)
                .HasConstraintName("fk_detalle_ticket");

            modelBuilder.Entity<DetalleTicket>()
                .HasOne(d => d.Producto)
                .WithMany()
                .HasForeignKey(d => d.IdProducto)
                .HasConstraintName("fk_detalle_producto");
        }
    }
}
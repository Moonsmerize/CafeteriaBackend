using Microsoft.EntityFrameworkCore;
using CafeteriaBackend.Models;

namespace CafeteriaBackend.Data
{
    public class CafeteriaContext : DbContext
    {
        public CafeteriaContext(DbContextOptions<CafeteriaContext> options) : base(options) { }

        // Esta es la representacion de las tablas en C#
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
        public DbSet<RelProveedorInventario> RelProveedorInventarios { get; set; }

        // Configuracion de las relaciones entre tablas
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Nombres de las tablas
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

            // Configuracion de Relaciones

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

            //  Usuario -> Rol
            modelBuilder.Entity<Usuario>()
                .HasOne(u => u.Rol)
                .WithMany(r => r.Usuarios)
                .HasForeignKey(u => u.IdRol)
                .HasConstraintName("fk_usuario_rol");

            //  Receta (Producto <-> Inventario)
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

            // Caja 
            modelBuilder.Entity<Caja>()
                .HasOne(c => c.UsuarioApertura)
                .WithMany(u => u.CajasApertura)
                .HasForeignKey(c => c.IdUsuarioApertura)
                .HasConstraintName("fk_caja_usuario");

            modelBuilder.Entity<Caja>()
                .HasOne(c => c.UsuarioCierre)
                .WithMany()
                .HasForeignKey(c => c.IdUsuarioCierre);

            // Ticket -> Caja, Cliente, Usuario
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

            // DetalleTicket -> Ticket, Producto
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

            modelBuilder.Entity<RelProveedorInventario>()
                .HasOne(r => r.Proveedor)
                .WithMany()
                .HasForeignKey(r => r.IdProveedor)
                .HasConstraintName("fk_rpi_proveedor");

            modelBuilder.Entity<RelProveedorInventario>()
                .HasOne(r => r.Inventario)
                .WithMany()
                .HasForeignKey(r => r.IdInventario)
                .HasConstraintName("fk_rpi_inventario");
        }
    }
}
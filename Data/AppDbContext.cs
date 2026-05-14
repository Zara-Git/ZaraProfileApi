using Microsoft.EntityFrameworkCore;
using ZaraProfileApi.Models;

namespace ZaraProfileApi.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Profile> Profiles => Set<Profile>();
}
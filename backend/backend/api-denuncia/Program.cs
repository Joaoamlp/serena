using DominioDenuncia;
using InfrastructureDenuncia;
using InfrastructureGeneric;
using Microsoft.EntityFrameworkCore;
using ServiceDenuncia;
using ServiceDenuncia.Profiles;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers()
    .AddJsonOptions(opt =>
    {
        opt.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
    });
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();



var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException(
        "Connection string 'DefaultConnection' não encontrada ou vazia. Verifique appsettings.json e o Startup Project.");
}

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString) // Use o provedor de banco de dados apropriado
);
builder.Services.AddMemoryCache();
builder.Services.AddScoped(typeof(IGenericRepository<Denuncia>), typeof(GenericRepositoryEntity<Denuncia,AppDbContext>));
builder.Services.AddScoped<IDenunciaService, DenunciaService>();
builder.Services.AddAutoMapper(typeof(DenunciaProfile));
builder.Services.AddHttpClient<IUserApiClient, UserApiClient>(client =>
{
    client.BaseAddress = new Uri(builder.Configuration["UserApi:BaseUrl"]);
    client.Timeout = TimeSpan.FromSeconds(5); // timeout por request
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Adiciona o arquivo ocelot.json
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// Adiciona Ocelot
builder.Services.AddOcelot(builder.Configuration);

var app = builder.Build();

// Middleware do Ocelot
app.UseHttpsRedirection();
await app.UseOcelot();

app.Run();
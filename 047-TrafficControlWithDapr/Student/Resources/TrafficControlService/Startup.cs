using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using TrafficControlService.DomainServices;
using TrafficControlService.Repositories;

namespace TrafficControlService
{
  public class Startup
  {
    public Startup(IConfiguration configuration)
    {
      Configuration = configuration;
    }

    public IConfiguration Configuration { get; }

    // This method gets called by the runtime. Use this method to add services to the container.
    public void ConfigureServices(IServiceCollection services)
    {
      services.AddSingleton<ISpeedingViolationCalculator>(
          new DefaultSpeedingViolationCalculator("A12", 10, 100, 5));

      services.AddHttpClient();

      //add the InMemoryVehicleStateRepository to the ServiceCollection
      services.AddSingleton<IVehicleStateRepository, InMemoryVehicleStateRepository>();
      services.AddHealthChecks();

      services.AddControllers();
    }

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
      if (env.IsDevelopment())
      {
        app.UseDeveloperExceptionPage();
      }

      app.UseRouting();

      app.UseEndpoints(endpoints =>
      {
        endpoints.MapHealthChecks("/healthz");
        endpoints.MapControllers();
      });
    }
  }
}

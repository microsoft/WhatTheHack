using FineCollectionService.DomainServices;
using FineCollectionService.Proxies;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace FineCollectionService
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
      services.AddSingleton<IFineCalculator, HardCodedFineCalculator>();

      // add service proxies
      services.AddHttpClient();
      services.AddSingleton<VehicleRegistrationService>();
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
      //enables direct deserialization from CloudEvents to POCO
      app.UseCloudEvents();

      app.UseEndpoints(endpoints =>
      {
        endpoints.MapHealthChecks("/healthz");
        endpoints.MapControllers();
      });
    }
  }
}

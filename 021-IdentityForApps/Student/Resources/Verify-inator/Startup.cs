using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Verify_inator.Services;

namespace Verify_inator
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
            var b2cConfigurationSection = Configuration.GetSection("AzureAdB2C");
            var b2cGraphService = new B2cGraphService(
                b2cExtensionsAppClientId: b2cConfigurationSection.GetValue<string>("B2cExtensionsAppClientId"),
                consultantIDUserAttribute: b2cConfigurationSection.GetValue<string>("ConsultantIDUserAttribute"),
                territoryNameUserAttribute: b2cConfigurationSection.GetValue<string>("TerritoryNameUserAttribute"));
            services.AddSingleton<B2cGraphService>(b2cGraphService);

            services.AddControllers();
            services.AddRouting(options => { options.LowercaseUrls = true; });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}

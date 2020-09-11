using Autofac;
using ContosoTravel.Web.Application;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.IO;

namespace ContosoTravel.Web.Host.MVC.Core
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public static IConfiguration Configuration;

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.Configure<CookiePolicyOptions>(options =>
            {
                // This lambda determines whether user consent for non-essential cookies is needed for a given request.
                options.CheckConsentNeeded = context => false;
                options.MinimumSameSitePolicy = SameSiteMode.None;
            });

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
            services.AddHttpContextAccessor();

            services.AddHttpClient("DataService", httpClient =>
            {
                httpClient.BaseAddress = new Uri(Configuration["DataServiceUrl"]);
                httpClient.DefaultRequestHeaders.Add("Accept", "application/json");
            });

            services.AddHttpClient("ItineraryService", httpClient =>
            {
                httpClient.BaseAddress = new Uri(Configuration["ItineraryServiceUrl"]);
                httpClient.DefaultRequestHeaders.Add("Accept", "application/json");
            });

            services.AddLogging();
        }

        public void ConfigureContainer(ContainerBuilder builder)
        {
            var thisAssembly = typeof(Startup).Assembly;
            Setup.InitCotoso(Configuration["KeyVaultUrl"], Path.GetDirectoryName(thisAssembly.Location), typeof(Startup).Assembly, builder);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseCookiePolicy();

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Flights}/{action=Index}/{id?}");
            });

            Application.Models.SiteModel.SiteTitle = "Contoso Travel - .Net Core";
        }
    }
}

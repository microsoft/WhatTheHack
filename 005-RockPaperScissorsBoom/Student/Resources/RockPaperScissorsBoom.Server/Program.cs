using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Web;
using Microsoft.Identity.Web.UI;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using RockPaperScissorsBoom.Core.Model;
using RockPaperScissorsBoom.Server;
using RockPaperScissorsBoom.Server.Data;
using RockPaperScissorsBoom.Server.Helpers;
using RockPaperScissorsBoom.Server.Hubs;
using RockPaperScissorsBoom.Server.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddDatabaseDeveloperPageExceptionFilter();

builder.Services.AddApplicationInsightsTelemetry();

builder.Services.Configure<CookiePolicyOptions>(options =>
{
    options.CheckConsentNeeded = context => true;
    options.MinimumSameSitePolicy = SameSiteMode.Unspecified;
    options.HandleSameSiteCookieCompatibility();
});

builder.Services.AddAuthentication(OpenIdConnectDefaults.AuthenticationScheme)
    .AddMicrosoftIdentityWebApp(builder.Configuration.GetSection(Constants.AzureAdB2C));

builder.Services.Configure<OpenIdConnectOptions>(OpenIdConnectDefaults.AuthenticationScheme, options =>
{
    options.ResponseType = OpenIdConnectResponseType.Code;
    options.Scope.Add(options.ClientId ?? "");
});

builder.Services.AddAuthorization(options =>
{
    options.FallbackPolicy = options.DefaultPolicy;
});

builder.Services.AddRazorPages(options =>
{
    options.Conventions.AllowAnonymousToPage("/Index");
    options.Conventions.AllowAnonymousToPage("/About");
    options.Conventions.AllowAnonymousToPage("/Error");
    options.Conventions.AllowAnonymousToPage("/RunTheGame");
    options.Conventions.AllowAnonymousToPage("/Competitors/Index");
    options.Conventions.AllowAnonymousToPage("/ProgressBarHub");
}).AddMvcOptions(options => { })
    .AddMicrosoftIdentityUI();

builder.Services.AddSingleton<IMetrics>(s => new AIMetrics(s.GetRequiredService<TelemetryClient>(), "BotDecisionTime"));
builder.Services.AddSingleton<IMessagingHelper, EventGridMessagingHelper>();
builder.Services.AddScoped<IRunGameService, RunGameService>();
builder.Services.AddSignalR();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
else
{
    app.UseDeveloperExceptionPage();
    app.UseMigrationsEndPoint();
}

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;

    var context = services.GetRequiredService<ApplicationDbContext>();
    context.Database.EnsureCreated();
}

app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedProto
});

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseCookiePolicy();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

//needed to enable sign-in/sign-out with Microsoft Identity Web
app.MapControllers();
app.MapRazorPages();

app.MapPost("/api/rungame", async (IRunGameService runGameService) =>
{
    await runGameService.RunGameAsync();
    return Results.Accepted();
}).AllowAnonymous();

app.MapHub<ProgressBarHub>("/ProgressBarHub").AllowAnonymous();

app.Run();

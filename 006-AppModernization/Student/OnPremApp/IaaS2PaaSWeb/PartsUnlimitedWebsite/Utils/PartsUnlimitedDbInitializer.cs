using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Globalization;
using System.Linq;
using PartsUnlimited.Models;

namespace PartsUnlimited.Utils
{
    public class PartsUnlimitedDbInitializer : CreateDatabaseIfNotExists<PartsUnlimitedContext>
    {
        protected override void Seed(PartsUnlimitedContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data.
            var categories = new List<Category>{
                new Category { Name = "Brakes", Description = "Brakes description", ImageUrl = "product_brakes_disc.jpg" },
                new Category { Name = "Lighting", Description = "Lighting description", ImageUrl = "product_lighting_headlight.jpg" },
                new Category { Name = "Wheels & Tires", Description = "Wheels & Tires description", ImageUrl = "product_wheel_rim.jpg" },
                new Category { Name = "Batteries", Description = "Batteries description", ImageUrl = "product_batteries_basic-battery.jpg" },
                new Category { Name = "Oil", Description = "Oil description", ImageUrl = "product_oil_premium-oil.jpg" }
            };

            context.Categories.AddOrUpdate(x => x.Name, categories.ToArray());
            context.SaveChanges();
            var categoriesMap = categories.ToDictionary(c => c.Name, c => c.CategoryId);

            var products = new List<Product>();
            products.Add(new Product
            {
                SkuNumber = "LIG-0001",
                Created = DateTime.Now,
                Title = "Halogen Headlights (2 Pack)",
                CategoryId = categoriesMap["Lighting"],
                Price = 38.99M, 
                SalePrice = 38.99M, 
                ProductArtUrl = "product_lighting_headlight.jpg", 
                ProductDetails = "{ \"Light Source\" : \"Halogen\", \"Assembly Required\": \"Yes\", \"Color\" : \"Clear\", \"Interior\" : \"Chrome\", \"Beam\": \"low and high\", \"Wiring harness included\" : \"Yes\", \"Bulbs Included\" : \"No\",  \"Includes Parking Signal\" : \"Yes\"}", 
                Description = "Our Halogen Headlights are made to fit majority of vehicles with our  universal fitting mold. Product requires some assembly and includes light bulbs.",
                Inventory = 10,
                LeadTime = 0,
                RecommendationId = 1
            });
            products.Add(new Product 
            {
                SkuNumber = "LIG-0002",
                Created = DateTime.Now,
                Title = "Bugeye Headlights (2 Pack)",
                CategoryId = categoriesMap["Lighting"],
                Price = 48.99M,
                SalePrice = 48.99M,
                ProductArtUrl = "product_lighting_bugeye-headlight.jpg",
                ProductDetails = "{ \"Light Source\" : \"Halogen\", \"Assembly Required\": \"Yes\", \"Color\" : \"Clear\", \"Interior\" : \"Chrome\", \"Beam\": \"low and high\", \"Wiring harness included\" : \"No\", \"Bulbs Included\" : \"Yes\",  \"Includes Parking Signal\" : \"Yes\"}",
                Description = "Our Bugeye Headlights use Halogen light bulbs are made to fit into a standard Bugeye slot. Product requires some assembly and includes light bulbs.",
                Inventory = 7,
                LeadTime = 0,
                RecommendationId = 2
            });
            products.Add(new Product
            {
                SkuNumber = "LIG-0003",
                Created = DateTime.Now,
                Title = "Turn Signal Light Bulb",
                CategoryId = categoriesMap["Lighting"],
                Price = 6.49M,
                SalePrice = 6.49M,
                ProductArtUrl = "product_lighting_lightbulb.jpg",
                ProductDetails = "{ \"Color\" : \"Clear\", \"Fit\" : \"Universal\", \"Wattage\" : \"30 Watts\", \"Includes Socket\" : \"Yes\"}",
                Description = " Clear bulb that with a universal fitting for all headlights/taillights.  Simple Installation, low wattage and a clear light for optimal visibility and efficiency.",
                Inventory = 18,
                LeadTime = 0,
                RecommendationId = 3
            });
            products.Add(new Product
            {
                SkuNumber = "WHE-0001",
                Created = DateTime.Now,
                Title = "Matte Finish Rim",
                CategoryId = categoriesMap["Wheels & Tires"],
                Price = 75.99M,
                SalePrice = 75.99M,
                ProductArtUrl = "product_wheel_rim.jpg",
                ProductDetails = "{ \"Material\" : \"Aluminum alloy\",  \"Design\" : \"Spoke\", \"Spokes\" : \"9\",  \"Number of Lugs\" : \"4\", \"Wheel Diameter\" : \"17 in.\", \"Color\" : \"Black\", \"Finish\" : \"Matte\" } ",
                Description = "A Parts Unlimited favorite, the Matte Finish Rim is affordable low profile style. Fits all low profile tires.",
                Inventory = 4,
                LeadTime = 0,
                RecommendationId = 4
            });
            products.Add(new Product
            {
                SkuNumber = "WHE-0002",
                Created = DateTime.Now,
                Title = "Blue Performance Alloy Rim",
                CategoryId = categoriesMap["Wheels & Tires"],
                Price = 88.99M,
                SalePrice = 88.99M,
                ProductArtUrl = "product_wheel_rim-blue.jpg",
                ProductDetails = "{ \"Material\" : \"Aluminum alloy\",  \"Design\" : \"Spoke\", \"Spokes\" : \"5\",  \"Number of Lugs\" : \"4\", \"Wheel Diameter\" : \"18 in.\", \"Color\" : \"Blue\", \"Finish\" : \"Glossy\" } ",
                Description = "Stand out from the crowd with a set of aftermarket blue rims to make you vehicle turn heads and at a price that will do the same.",
                Inventory = 8,
                LeadTime = 0,
                RecommendationId = 5
            });
            products.Add(new Product
            {
                SkuNumber = "WHE-0003",
                Created = DateTime.Now,
                Title = "High Performance Rim",
                CategoryId = categoriesMap["Wheels & Tires"],
                Price = 99.99M,
                SalePrice = 99.49M,
                ProductArtUrl = "product_wheel_rim-red.jpg",
                ProductDetails = "{ \"Material\" : \"Aluminum alloy\",  \"Design\" : \"Spoke\", \"Spokes\" : \"12\",  \"Number of Lugs\" : \"5\", \"Wheel Diameter\" : \"18 in.\", \"Color\" : \"Red\", \"Finish\" : \"Matte\" } ",
                Description = "Light Weight Rims with a twin cross spoke design for stability and reliable performance.",
                Inventory = 3,
                LeadTime = 0,
                RecommendationId = 6
            });
            products.Add(new Product
            {
                SkuNumber = "WHE-0004",
                Created = DateTime.Now,
                Title = "Wheel Tire Combo",
                CategoryId = categoriesMap["Wheels & Tires"],
                Price = 72.49M,
                SalePrice = 72.49M,
                ProductArtUrl = "product_wheel_tyre-wheel-combo.jpg",
                ProductDetails = "{ \"Material\" : \"Steel\",  \"Design\" : \"Spoke\", \"Spokes\" : \"8\",  \"Number of Lugs\" : \"4\", \"Wheel Diameter\" : \"19 in.\", \"Color\" : \"Gray\", \"Finish\" : \"Standard\", \"Pre-Assembled\" : \"Yes\" } ",
                Description = "For the endurance driver, take advantage of our best wearing tire yet. Composite rubber and a heavy duty steel rim.",
                Inventory = 0,
                LeadTime = 4,
                RecommendationId = 7
            });
            products.Add(new Product
            {
                SkuNumber = "WHE-0005",
                Created = DateTime.Now,
                Title = "Chrome Rim Tire Combo",
                CategoryId = categoriesMap["Wheels & Tires"],
                Price = 129.99M,
                SalePrice = 129.99M,
                ProductArtUrl = "product_wheel_tyre-rim-chrome-combo.jpg",
                ProductDetails = "{ \"Material\" : \"Aluminum alloy\",  \"Design\" : \"Spoke\", \"Spokes\" : \"10\",  \"Number of Lugs\" : \"5\", \"Wheel Diameter\" : \"17 in.\", \"Color\" : \"Silver\", \"Finish\" : \"Chrome\", \"Pre-Assembled\" : \"Yes\" } ",
                Description = "Save time and money with our ever popular wheel and tire combo. Pre-assembled and ready to go.",
                Inventory = 1,
                LeadTime = 0,
                RecommendationId = 8
            });
            products.Add(new Product
            {
                SkuNumber = "WHE-0006",
                Created = DateTime.Now,
                Title = "Wheel Tire Combo (4 Pack)",
                CategoryId = categoriesMap["Wheels & Tires"],
                Price = 219.99M,
                SalePrice = 219.99M,
                ProductArtUrl = "product_wheel_tyre-wheel-combo-pack.jpg",
                ProductDetails = "{ \"Material\" : \"Steel\",  \"Design\" : \"Spoke\", \"Spokes\" : \"8\",  \"Number of Lugs\" : \"5\", \"Wheel Diameter\" : \"19 in.\", \"Color\" : \"Gray\", \"Finish\" : \"Standard\", \"Pre-Assembled\" : \"Yes\" } ",
                Description = "Having trouble in the wet? Then try our special patent tire on a heavy duty steel rim. These wheels perform excellent in all conditions but were designed specifically for wet weather.",
                Inventory = 3,
                LeadTime = 0,
                RecommendationId = 9
            });
            products.Add(new Product
            {
                SkuNumber = "BRA-0001",
                Created = DateTime.Now,
                Title = "Disk and Pad Combo",
                CategoryId = categoriesMap["Brakes"],
                Price = 25.99M,
                SalePrice = 25.99M,
                ProductArtUrl = "product_brakes_disk-pad-combo.jpg",
                ProductDetails = "{ \"Disk Design\" : \"Cross Drill Slotted\", \" Pad Material\" : \"Ceramic\", \"Construction\" : \"Vented Rotor\", \"Diameter\" : \"10.3 in.\", \"Finish\" : \"Silver Zinc Plated\", \"Hat Finish\" : \"Silver Zinc Plated\", \"Material\" : \"Cast Iron\" }",
                Description = "Our brake disks and pads perform the best together. Better stopping distances without locking up, reduced rust and dusk.",
                Inventory = 0,
                LeadTime = 6,
                RecommendationId = 10
            });
            products.Add(new Product
            {
                SkuNumber = "BRA-0002",
                Created = DateTime.Now,
                Title = "Brake Rotor",
                CategoryId = categoriesMap["Brakes"],
                Price = 18.99M,
                SalePrice = 18.99M,
                ProductArtUrl = "product_brakes_disc.jpg",
                ProductDetails = "{ \"Disk Design\" : \"Cross Drill Slotted\",  \"Construction\" : \"Vented Rotor\", \"Diameter\" : \"10.3 in.\", \"Finish\" : \"Silver Zinc Plated\", \"Hat Finish\" : \"Black E-coating\",  \"Material\" : \"Cast Iron\" }",
                Description = "Our Brake Rotor Performs well in wet conditions with a smooth responsive feel. Machined to a high tolerance to ensure all of our Brake Rotors are safe and reliable.",
                Inventory = 4,
                LeadTime = 0,
                RecommendationId = 11
            });
            products.Add(new Product
            {
                SkuNumber = "BRA-0003",
                Created = DateTime.Now,
                Title = "Brake Disk and Calipers",
                CategoryId = categoriesMap["Brakes"],
                Price = 43.99M,
                SalePrice = 43.99M,
                ProductArtUrl = "product_brakes_disc-calipers-red.jpg",
                ProductDetails = "{\"Disk Design\" : \"Cross Drill Slotted\", \" Pad Material\" : \"Carbon Ceramic\",  \"Construction\" : \"Vented Rotor\", \"Diameter\" : \"11.3 in.\", \"Bolt Pattern\": \"6 x 5.31 in.\", \"Finish\" : \"Silver Zinc Plated\",  \"Material\" : \"Carbon Alloy\", \"Includes Brake Pads\" : \"Yes\" }",
                Description = "Upgrading your brakes can increase stopping power, reduce dust and noise. Our Disk Calipers exceed factory specification for the best performance.",
                Inventory = 2,
                LeadTime = 0,
                RecommendationId = 12
            });
            products.Add(new Product
            {
                SkuNumber = "BAT-0001",
                Created = DateTime.Now,
                Title = "12-Volt Calcium Battery",
                CategoryId = categoriesMap["Batteries"],
                Price = 129.99M,
                SalePrice = 129.99M,
                ProductArtUrl = "product_batteries_basic-battery.jpg",
                ProductDetails = "{ \"Type\": \"Calcium\", \"Volts\" : \"12\", \"Weight\" : \"22.9 lbs\", \"Size\" :  \"7.7x5x8.6\", \"Cold Cranking Amps\" : \"510\" }",
                Description = "Calcium is the most common battery type. It is durable and has a long shelf and service life. They also provide high cold cranking amps.",
                Inventory = 9,
                LeadTime = 0,
                RecommendationId = 13
            });
            products.Add(new Product
            {
                SkuNumber = "BAT-0002",
                Created = DateTime.Now,
                Title = "Spiral Coil Battery",
                CategoryId = categoriesMap["Batteries"],
                Price = 154.99M,
                SalePrice = 154.99M,
                ProductArtUrl = "product_batteries_premium-battery.jpg",
                ProductDetails = "{ \"Type\": \"Spiral Coil\", \"Volts\" : \"12\", \"Weight\" : \"20.3 lbs\", \"Size\" :  \"7.4x5.1x8.5\", \"Cold Cranking Amps\" : \"460\" }",
                Description = "Spiral Coil batteries are the preferred option for high performance Vehicles where extra toque is need for starting. They are more resistant to heat and higher charge rates than conventional batteries.",
                Inventory = 3,
                LeadTime = 0,
                RecommendationId = 14
            });
            products.Add(new Product
            {
                SkuNumber = "BAT-0003",
                Created = DateTime.Now,
                Title = "Jumper Leads",
                CategoryId = categoriesMap["Batteries"],
                Price = 16.99M,
                SalePrice = 16.99M,
                ProductArtUrl = "product_batteries_jumper-leads.jpg",
                ProductDetails = "{ \"length\" : \"6ft.\", \"Connection Type\" : \"Alligator Clips\", \"Fit\" : \"Universal\", \"Max Amp's\" : \"750\" }",
                Description = "Battery Jumper Leads have a built in surge protector and a includes a plastic carry case to keep them safe from corrosion.",
                Inventory = 6,
                LeadTime = 0,
                RecommendationId = 15
            });
            products.Add(new Product
            {
                SkuNumber = "OIL-0001",
                Created = DateTime.Now,
                Title = "Filter Set",
                CategoryId = categoriesMap["Oil"],
                Price = 28.99M,
                SalePrice = 28.99M,
                ProductArtUrl = "product_oil_filters.jpg",
                ProductDetails = "{ \"Filter Type\" : \"Canister and Cartridge\", \"Thread Size\" : \"0.75-16 in.\", \"Anti-Drainback Valve\" : \"Yes\"}",
                Description = "Ensure that your vehicle's engine has a longer life with our new filter set. Trapping more dirt to ensure old freely circulates through your engine.",
                Inventory = 3,
                LeadTime = 0,
                RecommendationId = 16
            });
            products.Add(new Product
            {
                SkuNumber = "OIL-0002",
                Created = DateTime.Now,
                Title = "Oil and Filter Combo",
                CategoryId = categoriesMap["Oil"],
                Price = 34.49M,
                SalePrice = 34.49M,
                ProductArtUrl = "product_oil_oil-filter-combo.jpg",
                ProductDetails = "{ \"Filter Type\" : \"Canister\", \"Thread Size\" : \"0.75-16 in.\", \"Anti-Drainback Valve\" : \"Yes\", \"Size\" : \"1.1 gal.\", \"Synthetic\" : \"No\" }",
                Description = "This Oil and Oil Filter combo is suitable for all types of passenger and light commercial vehicles. Providing affordable performance through excellent lubrication and breakdown resistance.",
                Inventory = 5,
                LeadTime = 0,
                RecommendationId = 17
            });
            products.Add(new Product
            {
                SkuNumber = "OIL-0003",
                Created = DateTime.Now,
                Title = "Synthetic Engine Oil",
                CategoryId = categoriesMap["Oil"],
                Price = 36.49M,
                SalePrice = 36.49M,
                ProductArtUrl = "product_oil_premium-oil.jpg",
                ProductDetails = "{ \"Size\" :  \"1.1 Gal.\" , \"Synthetic \" : \"Yes\"}",
                Description = "This Oil is designed to reduce sludge deposits and metal friction throughout your cars engine. Provides performance no matter the condition or temperature.",
                Inventory = 11,
                LeadTime = 0,
                RecommendationId = 18
            });
            context.Products.AddOrUpdate(x => x.Title, products.ToArray());
            context.SaveChanges();

            var stores = Enumerable.Range(1, 20).Select(id => new Store { StoreId = id, Name = string.Format(CultureInfo.InvariantCulture, "Store{0}", id) }).ToList();
            context.Stores.AddOrUpdate(x => x.Name, stores.ToArray());
            context.SaveChanges();

            var rainchecks = GetRainchecks(stores, products);
            context.RainChecks.AddOrUpdate(x => x.StoreId, rainchecks.ToArray());
            context.SaveChanges();
        }

        /// <summary>
        /// Generate an enumeration of rainchecks.  The random number generator uses a seed to ensure 
        /// that the sequence is consistent, but provides somewhat random looking data.
        /// </summary>
        public static IEnumerable<Raincheck> GetRainchecks(IList<Store> stores, IList<Product> products)
        {
            var random = new Random(1234);

            foreach (var store in stores)
            {
                for (var i = 0; i < random.Next(1, 5); i++)
                {
                    yield return new Raincheck
                    {
                        StoreId = store.StoreId,
                        Name = string.Format("John Smith{0}", random.Next()),
                        Count = random.Next(1, 10),
                        ProductId = products[random.Next(0, products.Count)].ProductId,
                        SalePrice = Math.Round(100 * random.NextDouble(), 2)
                    };
                }
            }
        }
    }
}

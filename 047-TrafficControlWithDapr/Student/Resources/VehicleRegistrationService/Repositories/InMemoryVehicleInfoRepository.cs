using System;
using System.Collections.Generic;
using System.Threading;
using RandomNameGeneratorLibrary;
using VehicleRegistrationService.Models;

namespace VehicleRegistrationService.Repositories
{
    public class InMemoryVehicleInfoRepository : IVehicleInfoRepository
    {
        private Random _rnd;

        private PersonNameGenerator _nameGenerator;

        private readonly string[] _vehicleBrands = new string[] {
            "Mercedes", "Toyota", "Audi", "Volkswagen", "Seat", "Renault", "Skoda", 
            "Kia", "Citroën", "Suzuki", "Mitsubishi", "Fiat", "Opel" };

        private Dictionary<string, string[]> _models = new Dictionary<string, string[]>
        {
            { "Mercedes", new string[] { "A Class", "B Class", "C Class", "E Class", "SLS", "SLK" } },
            { "Toyota", new string[] { "Yaris", "Avensis", "Rav 4", "Prius", "Celica" } },
            { "Audi", new string[] { "A3", "A4", "A6", "A8", "Q5", "Q7" } },
            { "Volkswagen", new string[] { "Golf", "Pasat", "Tiguan", "Caddy" } },
            { "Seat", new string[] { "Leon", "Arona", "Ibiza", "Alhambra" } },
            { "Renault", new string[] { "Megane", "Clio", "Twingo", "Scenic", "Captur" } },
            { "Skoda", new string[] { "Octavia", "Fabia", "Superb", "Karoq", "Kodiaq" } },
            { "Kia", new string[] { "Picanto", "Rio", "Ceed", "XCeed", "Niro", "Sportage" } },
            { "Citroën", new string[] { "C1", "C2", "C3", "C4", "C4 Cactus", "Berlingo" } },
            { "Suzuki", new string[] { "Ignis", "Swift", "Vitara", "S-Cross", "Swace", "Jimny" } },
            { "Mitsubishi", new string[] { "Space Star", "ASX", "Eclipse Cross", "Outlander PHEV" } },
            { "Ford", new string[] { "Focus", "Ka", "C-Max", "Fusion", "Fiesta", "Mondeo", "Kuga" } },
            { "BMW", new string[] { "1 Serie", "2 Serie", "3 Serie", "5 Serie", "7 Serie", "X5" } },
            { "Fiat", new string[] { "500", "Panda", "Punto", "Tipo", "Multipla" } },
            { "Opel", new string[] { "Karl", "Corsa", "Astra", "Crossland X", "Insignia" } }
        };

        public InMemoryVehicleInfoRepository()
        {
            _rnd = new Random();
            _nameGenerator = new PersonNameGenerator(_rnd);
        }

        public VehicleInfo GetVehicleInfo(string licenseNumber)
        {
            // simulate slow IO
            Thread.Sleep(_rnd.Next(5, 200));

            // get random vehicle info
            string brand = GetRandomBrand();
            string model = GetRandomModel(brand);
            
            // get random owner info
            var ownerName = _nameGenerator.GenerateRandomFirstAndLastName();
            var ownerEmail = $"{ownerName.ToLowerInvariant().Replace(' ', '.')}@outlook.com";

            // return info
            return new VehicleInfo
            {
                VehicleId = licenseNumber,
                Brand = brand,
                Model = model,
                OwnerName = ownerName,
                OwnerEmail = ownerEmail
            };
        }

        private string GetRandomBrand()
        {
            return _vehicleBrands[_rnd.Next(_vehicleBrands.Length)];
        }

        private string GetRandomModel(string brand)
        {
            string[] models = _models[brand];
            return models[_rnd.Next(models.Length)];
        }
    }
}
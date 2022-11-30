using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Pastel;
using Simulation.Proxies;

namespace Simulation
{
    class Program
    {
        static void Main(string[] args)
        {
            var httpClient = new HttpClient();
            int lanes = 3;

            var rand = new Random();
            int lanesOffsetWindow1 = rand.Next(0, 5);
            int lanesOffsetWindow2 = rand.Next(0, 5);

            var uiRenderingService = new UiRenderingService(Console.BufferWidth, Console.BufferHeight, lanes);

            Task.Run(() =>
            {
                while (true)
                {
                    uiRenderingService.RedrawScene(Console.BufferWidth - 1, Console.BufferHeight - 2, lanes, lanesOffsetWindow1, lanesOffsetWindow2);
                    Thread.Sleep(1000);
                }
            }
            );

            Task.Run(() =>
            {

                while (true)
                {
                    uiRenderingService.MoveAllCarsForWindow(0);
                    uiRenderingService.MoveAllCarsForWindow(1);
                    Thread.Sleep(100);
                }
            }
            );



            CameraSimulation[] cameras = new CameraSimulation[lanes];
            for (var i = 0; i < lanes; i++)
            {
                int camNumber = i + 1;
                var trafficControlService = new HttpTrafficControlService(httpClient);
                cameras[i] = new CameraSimulation(camNumber, trafficControlService, uiRenderingService);
            }
            Parallel.ForEach(cameras, cam => cam.Start());

            Task.Run(() => Thread.Sleep(Timeout.Infinite)).Wait();
        }
    }
}

using Pastel;
using Simulation.Events;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Simulation
{
    public class UiRenderingService
    {
        private static ConcurrentDictionary<int, Dictionary<int, string>> sceneMatrix = new ConcurrentDictionary<int, Dictionary<int, string>>();

        private const bool isDebugMatrixHighlighted = false;
        
        private const string DEFAULT_BACKGROUND = "#000000";
        private const string ROAD_COLOR = "#575757";
        private const string GRAY_COLOR = "#666666";
        private const string BLACK_COLOR = "#000000";
        private const string WHITE_COLOR = "#FFFFFF";
        private const string YELLOW_COLOR = "#FFFF00";
        private const string GREEN_COLOR = "#069420";

        private int _sceneWidth;
        private int _sceneHeight;

        private int _lanesCount;

        private Dictionary<int, int> _windowStartX = new Dictionary<int, int>();
        private Dictionary<int, int> _windowSize = new Dictionary<int, int>();


        private ConcurrentDictionary<int, ConcurrentDictionary<string, CarToBeRendered>> _windowCars = new ConcurrentDictionary<int, ConcurrentDictionary<string, CarToBeRendered>>();

        public UiRenderingService(int sceneWidth, int sceneHeight, int lanesCount)
        {
            _sceneWidth = sceneWidth;
            _sceneHeight = sceneHeight;
            _lanesCount = lanesCount;
        }

        /// returns last x position of the string's char
        public int SaveStringIntoMatrix(int y, int startX, string input, string foregroundColor, string backgroundColor, int ignoreLowerThanX = 0, int ignoreHigherThanX = 99999, int ignoreLowerThanY = 0, int ignoreHigherThanY = 99999)
        {
            var chars = input.ToCharArray();
            int x = startX;
            foreach (var myChar in chars)
            {
                if (x > ignoreHigherThanX || x < ignoreLowerThanX || y < ignoreLowerThanY || y > ignoreHigherThanY)
                {
                    x++;
                    continue;
                }
                if (!sceneMatrix.ContainsKey(y))
                {
                    continue;
                }

                sceneMatrix[y][x] = myChar.ToString();
                if (!string.IsNullOrEmpty(foregroundColor))
                {
                    sceneMatrix[y][x] = sceneMatrix[y][x].Pastel(foregroundColor);
                }

                if (!string.IsNullOrEmpty(backgroundColor))
                {
                    sceneMatrix[y][x] = sceneMatrix[y][x].PastelBg(backgroundColor);
                }

                x++;
            }

            return x;
        }


        private int RedrawSubWindow(int windowId, int startXPosition, int lanesOffset = 0)
        {
            _windowStartX[windowId] = startXPosition;

            //heading
            int currentY = 6;
            string tempText = $"▼    Camera {windowId + 1}    ▼";
            int windowStartXPosition = startXPosition;
            int windowTitlePaddingLength = (_sceneWidth / 4) - (tempText.Length / 2) - 5;
            startXPosition = SaveStringIntoMatrix(currentY, startXPosition, "".PadRight(windowTitlePaddingLength), "#000000", GRAY_COLOR);

            startXPosition = SaveStringIntoMatrix(currentY, startXPosition, tempText, BLACK_COLOR, GRAY_COLOR);
            startXPosition = SaveStringIntoMatrix(currentY, startXPosition, "".PadRight(windowTitlePaddingLength), "#000000", GRAY_COLOR);

            int windowSize = startXPosition - windowStartXPosition;

            currentY++;

            //grass
            SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), GREEN_COLOR, GREEN_COLOR);
            currentY++;

            SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), ROAD_COLOR, ROAD_COLOR);
            currentY++;

            //highway divider
            SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), YELLOW_COLOR, YELLOW_COLOR);
            currentY++;

            //lanes

            int lanesStartY = currentY;

            for (int i = 0; i < _lanesCount; i++)
            {
                SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), BLACK_COLOR, ROAD_COLOR);
                currentY++;
                SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), BLACK_COLOR, ROAD_COLOR);
                currentY++;
                SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), BLACK_COLOR, ROAD_COLOR);
                currentY++;


                if (i < _lanesCount - 1)
                {
                    //lane dividers
                    int currentX = windowStartXPosition - lanesOffset;

                    for (int j = 0; j < (windowSize / 11) + 1; j++)
                    {
                        SaveStringIntoMatrix(currentY, currentX, "".PadRight(6), BLACK_COLOR, WHITE_COLOR, windowStartXPosition, (windowStartXPosition + windowSize - 1));
                        currentX += 6;
                        SaveStringIntoMatrix(currentY, currentX, "".PadRight(5), BLACK_COLOR, ROAD_COLOR, windowStartXPosition, (windowStartXPosition + windowSize - 1));
                        currentX += 5;
                    }

                    currentY++;
                }
            }


            //highway divider
            SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), YELLOW_COLOR, YELLOW_COLOR);
            currentY++;

            SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), ROAD_COLOR, ROAD_COLOR);
            currentY++;

            //grass
            SaveStringIntoMatrix(currentY, windowStartXPosition, "".PadRight(windowSize), GREEN_COLOR, GREEN_COLOR);
            currentY++;

            _windowSize[windowId] = windowSize;


            //draw cars

            if (_windowCars.ContainsKey(windowId))
            {
                Parallel.For(1, _lanesCount + 1, (laneId, state) =>
                {
                    int currentFreeLanePosition = windowStartXPosition;
                    foreach (var car in _windowCars[windowId].Where(c => c.Value.Lane.Equals(laneId)).OrderBy(c => c.Value.PositionOnCameraImage))
                    {

                        int carXPosition = car.Value.PositionOnCameraImage + currentFreeLanePosition;
                        int carYPosition = 10 + (car.Value.Lane - 1) * 4;

                        SaveStringIntoMatrix(carYPosition, carXPosition, "┌──────────┐", BLACK_COLOR, car.Value.BackgroundColor, _windowStartX[windowId], (_windowStartX[windowId] + _windowSize[windowId] - 1));
                        SaveStringIntoMatrix(carYPosition + 1, carXPosition, $"| {car.Value.LicenseNumber} |", BLACK_COLOR, car.Value.BackgroundColor, _windowStartX[windowId], (_windowStartX[windowId] + _windowSize[windowId] - 1));
                        SaveStringIntoMatrix(carYPosition + 2, carXPosition, "└──────────┘", BLACK_COLOR, car.Value.BackgroundColor, _windowStartX[windowId], (_windowStartX[windowId] + _windowSize[windowId] - 1));
                        
                        currentFreeLanePosition += 20;
                    }
                });
            }

            return windowSize;
        }

        public void AddCarToBeAnimatedInWindow(int windowId, int laneId, string licenseNumber, string foregroundColor, string backgroundColor)
        {
            //if(!_windowsStartX.ContainsKey(windowId))
            //  return;
            if (!_windowCars.ContainsKey(windowId))
            {
                _windowCars.TryAdd(windowId, new ConcurrentDictionary<string, CarToBeRendered>());
            }

            _windowCars[windowId].TryAdd(licenseNumber, new CarToBeRendered()
            {
                Lane = laneId,
                LicenseNumber = licenseNumber,
                PositionOnCameraImage = 0,
                BackgroundColor = backgroundColor,

            });
        }

        public void RedrawScene(int sceneWidth, int sceneHeight, int lanesCount, int lanes1Offset = 0, int lanes2Offset = 0)
        {

            if (sceneWidth < 70)
            {
                Console.Clear();
                Console.WriteLine("Please resize the window to 70 cols width at minimum.");
                return;
            }

            if (sceneHeight < 22)
            {
                Console.Clear();
                Console.WriteLine("Please resize the window to 22 lines height at minimum.");
                return;
            }

            _sceneWidth = sceneWidth;
            _sceneHeight = sceneHeight;

            string tempText;
            int startXPosition;

            for (int y = 0; y < sceneHeight; y++)
            {
                sceneMatrix[y] = new Dictionary<int, string>();
            }


            // header
            tempText = " __________________________________________________________________ ";
            SaveStringIntoMatrix(0, (sceneWidth / 2) - (tempText.Length / 2), tempText, GRAY_COLOR, DEFAULT_BACKGROUND);

            tempText = "|                                                                  |";
            SaveStringIntoMatrix(1, (sceneWidth / 2) - (tempText.Length / 2), tempText, GRAY_COLOR, DEFAULT_BACKGROUND);

            tempText = "|  What The Hack - Traffic Control with Dapr - Traffic simulator   |";
            SaveStringIntoMatrix(2, (sceneWidth / 2) - (tempText.Length / 2), tempText, GRAY_COLOR, DEFAULT_BACKGROUND);

            tempText = "|__________________________________________________________________|";
            SaveStringIntoMatrix(3, (sceneWidth / 2) - (tempText.Length / 2), tempText, GRAY_COLOR, DEFAULT_BACKGROUND);


            // window #0
            int windowSize = RedrawSubWindow(0, 1, lanes1Offset);


            // window #1
            RedrawSubWindow(1, (sceneWidth - windowSize - 1), lanes2Offset);


            // windows separator
            for (int my = 6; my < sceneHeight; my++)
            {
                startXPosition = SaveStringIntoMatrix(my, (sceneWidth / 2) - 1, " ", GRAY_COLOR, GRAY_COLOR);
            }


            // Final scene render
            string scene = "";
            for (int y = 0; y < sceneHeight; y++)
            {

                for (int x = 0; x < sceneWidth; x++)
                {
                    if (sceneMatrix.ContainsKey(y) && sceneMatrix[y].ContainsKey(x))
                    {
                        scene += sceneMatrix[y][x];
                    }
                    else
                    {
                        if (isDebugMatrixHighlighted)
                        {
                            scene += " ".PastelBg("#FFFF00");
                        }
                        else
                        {
                            scene += " ";
                        }
                    }
                }

                scene += "\n";

            }

            Console.Clear();
            Console.Write(scene);

        }



        public void MoveAllCarsForWindow(int windowId)
        {
            if (!_windowCars.ContainsKey(windowId)) {
                return;
            }

            Parallel.For(1, _lanesCount + 1, (laneId, state) =>
            {
                foreach (var car in _windowCars[windowId].Where(c => c.Value.Lane.Equals(laneId)).OrderBy(c => c.Value.PositionOnCameraImage))
                {
                    car.Value.PositionOnCameraImage += 1;

                    if (car.Value.PositionOnCameraImage > 30)
                    {
                        CarToBeRendered carToBeDeleted;
                        _windowCars[windowId].Remove(car.Key, out carToBeDeleted);

                    }
                }
            });
        }

    }


    public class CarToBeRendered
    {
        public int Lane { get; set; }
        public string LicenseNumber { get; set; }
        public int PositionOnCameraImage { get; set; }
        public string BackgroundColor { get; set; }
    }
}
docker login --username=microservicesdiscovery

docker build -f %cd%\ContosoTravel.Web.Host.ItineraryService\Dockerfile -t microservicesdiscovery/travel-itinerary-service .
docker push microservicesdiscovery/travel-itinerary-service

docker build -f %cd%\ContosoTravel.Web.Host.DataService\Dockerfile -t microservicesdiscovery/travel-data-service .
docker push microservicesdiscovery/travel-data-service

docker build -f %cd%\Host.MVC.Core\Dockerfile -t microservicesdiscovery/travel-web .
docker push microservicesdiscovery/travel-web

docker build -f %cd%\DataLoader\Dockerfile -t microservicesdiscovery/travel-dataloader .
docker push microservicesdiscovery/travel-dataloader
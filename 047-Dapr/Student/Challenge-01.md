# Challenge 1 - Run the application

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

In this assignment, you'll run the reference application to ensure that everything works correctly.

## Description

As mentioned in the introduction, the hackathon assignments are built upon an existing microservice reference app, entitled the ***Traffic Control Application***. To start, you'll test the Traffic Control app to ensure that the application runs and your environment is configured correctly. You'll use Visual Studio Code to start each of the 4 microservices shown below:

<img src="../images/Challenge-01/services.png" style="zoom: 75%;padding-top: 50px;" />

Keep in mind that you'll be running the application ***without*** Dapr technology. As you work through the challenges, you'll add *Dapr-enable* the application by adding Dapr  Building Blocks and Components to it. Figure depicts the microservices in the reference application.

- Start by running the **Vehicle Registration** microservice. It exposes a single endpoint that listens for requests for vehicle and owner information.

- Next, run the **Fine Collection** service. It exposes an endpoint that assigns a fine to a speeding vehicles. To generate a fine, the Fine Collection service must make a call to the Vehicle Registration to obtain driver information.

- Then, run the **Traffic Control** service. It exposes entry and exit endpoints that capture a vehicle's a speed. When a motorist exceeds the speed limit, Traffic Control will call the Fine Collection service.

- Finally, run the **Simulation** service. It simulates vehicle traffic at varying speeds. It exposes entry and exit cameras that photograph the license plate of each vehicle. Vehicle telemetry is sent to the Traffic Control service.

> The Camera Simulation service is implemented as a Console application, the other services as as API applications.

## Success Criteria

To complete this assignment, you must achieve the following goals:

1. Successfully start each of the four microservices with no errors.

1. Observe activity flow from the top-level simulation service all the way through the Fine Collection service.

  > If you encounter an error, double-check to ensure that you have correctly installed all the [prerequisites](README.md#Prerequisites) for the workshop!

## Tips

1. Run the services in VS Code.

1. Using a single VS Code instance, open a [Terminal window](https://code.visualstudio.com/docs/editor/integrated-terminal) for each service.

1. Start each service using a ***dotnet run*** command.

1. Once running, test the VehcileRegistration service with the `REST Client extension tool` for VS Code.

    - Open the file `Resources/VehicleRegistrationService/test.http` using the (file) Explorer feature in VS Code. The request in this file simulates retrieving the vehicle and owner information for a certain license-number.
  
    - Click on Send request link, located immediately above the GET request, highlighted below with a red box, to send a request to the API:
        <img src="../images/Challenge-01/rest-client.png" />

    - The response from the request will be shown in a separate window on the right. It should have an HTTP status code 200 OK and the body should contain some random vehicle and owner-information:

    - The response from the request will be shown in a separate window on the right. It should have an HTTP status code 200 OK and the body should contain some random vehicle and owner-information:
  
      ```json
      HTTP/1.1 200 OK
      Connection: close
      Date: Mon, 01 Mar 2021 07:15:55 GMT
      Content-Type: application/json; charset=utf-8
      Server: Kestrel
      Transfer-Encoding: chunked
       
      {
           "vehicleId": "KZ-49-VX",
           "brand": "Toyota",
           "model": "Rav 4",
           "ownerName": "Angelena Fairbairn",
           "ownerEmail": "angelena.fairbairn@outlook.com"
      }
      ```
 
    - Finally, check the logging in the terminal window. It should look like this:
      <img src="../images/Challenge-01/logging-vehicleregistrationservice.png" />
 
1. For the remaining service, start and check the logging in the corresponding terminal window.

## Learning Resources

- [Visual Studio Code](https://code.visualstudio.com/)
- [VS Code Integrated Terminal](https://code.visualstudio.com/docs/editor/integrated-terminal)
- [Dotnet Command Line - Run](https://docs.microsoft.com/dotnet/core/tools/dotnet-run)

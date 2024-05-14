# Optional Challenge 07A - Scale the Cognitive Service - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07B.md)

## Notes & Guidance

None

## Step by Step Instructions

### Task 1: Observe your functions dynamically scaling when resource-constrained

In this task, you will change the Computer Vision API to the Free tier. This will limit the number of requests to the OCR service to 10 per minute. Once changed, run the UploadImages console app to upload 1,000 images again. The resiliency policy programmed into the FindLicensePlateText.MakeOCRRequest method of the ProcessImage function will begin exponentially backing off requests to the Computer Vision API, allowing it to recover and lift the rate limit. This intentional delay will greatly increase the function's response time, thus causing the Consumption plan's dynamic scaling to kick in, allocating several more servers. You will watch all of this happen in real time using the Live Metrics Stream view.

1.  Open your Computer Vision API service by opening the **ServerlessArchitecture** resource group, and then selecting the **Cognitive Services** service name.

2.  Select **Pricing tier** under Resource Management in the menu. Select the **F0 Free** pricing tier, then select **Select**.

    > **Note**: If you already have a **FO** free pricing tier instance, you will not be able to create another one.

3.  Switch to Visual Studio, debug the **UploadImages** project again, then enter **2** and press **ENTER**. This will upload 1,000 new photos.

4.  Switch back to the Live Metrics Stream window and observe the activity as the photos are uploaded. After running for a couple of minutes, you should start to notice a few things. The Request Duration will start to increase over time. As this happens, you should notice more servers being brought online. Each time a server is brought online, you should see a message in the Sample Telemetry stating that it is "Generating 2 job function(s)", followed by a Starting Host message. You should also see messages logged by the resilience policy that the Computer Vision API server is throttling the requests. This is known by the response codes sent back from the service (429). A sample message is "Computer Vision API server is throttling our requests. Automatically delaying for 32000ms".

    > **Note**: If you do not see data flow after a short period, consider restarting the Function App.

5.  After this has run for some time, close the UploadImages console to stop uploading photos.

6.  Navigate back to the **Computer Vision** API and set the pricing tier back to **S1 Standard**.


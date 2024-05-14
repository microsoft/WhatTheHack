# Challenge 10 - Run a Load Test - Coach's Guide

[< Previous Solution](./Solution-09.md) - **[Home](./README.md)** - [Next Solution >](./Solution-11.md)

## Notes & Guidance

### Initial test

1.  Create an Azure Load Test service in the Azure portal.

1.  Click on the **Upload a JMeter script->Create** button.

1.  On the **Test Plan** tab, upload the `quick-test.jmx` script.

1.  On the **Parameters** tab, create the following **Environment variables** to configure the test.

    - domain: `<web-app-name>.azurewebsites.net`
    - protocol: https
    - throughput_per_engine: 100
    - max_response_type: 500
    - ramp_up_time: 0
    - duration_in_sec: 120
    - path: `api/rungame`

1.  On the **Monitoring** tab, add your various Web Apps & SQL database so you can monitor them as well.

1.  Click the **Create** button

1.  Click the **Run** button to run the test

1.  Notice that the test is likely to fail due to lack of scaling on the Web App.

### Set up scaling on the Web App

1.  In the Azure portal, navigate to the Web App.

1.  Click on the **Scale up (App Service plan)** menu item.

1.  Change the **Size** to **Premium v2 P1V2** plan.

1.  Click the **Select** button.

1.  Click on the **Scale out (App Service plan)** menu item.

1.  Click on the **Scale out method->Rules Based** radio button.

1.  Click on the **Manage rules based scaling** button.

1.  Click on the **Custom autoscale** button.

1.  Click on the **Add a rule** button.

1.  Set the **Scale out** rule to **Scale out by 1 instance** when **CPU Percentage** is **greater than** **70** for **1** minutes.

1.  Click the **Add** button.

1.  Click the **Save** button.

### Run the test again

1.  In the Azure portal, navigate to the Azure Load Test service.

1.  Click on the **Run** button to run the test again.

1.  Notice that the test is likely to succeed this time. Review the results and see the different scaling events that occurred.

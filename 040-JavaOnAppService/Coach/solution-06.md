# Challenge 6: It's all about the scale

[< Previous Challenge](./solution-05.md) - **[Home](./README.md)**

## Notes & Guidance

- First the autoscale rules need to be created, you can do that manually from the portal or use the included [autoscale.bicep](./Solutions/autoscale.bicep) file.

    ```shell
    az deployment group create -g $RG -f Solutions/autoscale.bicep
    ```

- Now that's in place, you could either install and use JMeter with the JMX file from the repository, or explore the ACI option with `wrk`.

    ```shell
    az container create -g $RG -n wrk2 --image bootjp/wrk2 --restart-policy Never \
        --command-line "wrk -t2 -c100 -d10m -R300 -L https://$WEBAPP.azurewebsites.net/owners?lastName=Black"
    ```

- You can follow the number of instances through the CLI.

    ```shell
    az webapp list-instances -g $RG -n $WEBAPP -o tsv | wc -l
    ```

- However it's also possible to monitor the number of instances through the _Observed resource instance count chart_, available through App Service Plan Scale Out blade.
    ![Instances](./images/autoscale-instances.png)

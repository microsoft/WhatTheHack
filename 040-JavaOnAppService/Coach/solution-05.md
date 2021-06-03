# Challenge 5: Operational dashboards

[< Previous Challenge](./solution-04.md) - **[Home](./README.md)** - [Next Challenge >](./solution-06.md)

## Notes & Guidance

- It's possible to create a dashboard manually by building and pinning the correct charts, but the included [dashboard.bicep](./Solutions/dashboard.bicep) file does that automatically.

    ```shell
    az deployment group create -g $RG -f Solutions/dashboard.bicep
    ```

- Any layout is just fine, as long as the correct charts are there.
    ![Dashboard](./images/dashboard.png)

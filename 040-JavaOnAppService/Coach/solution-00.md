# Challenge 0: Getting your feet wet

**[Home](./README.md)** - [Next Challenge >](./solution-01.md)

## Notes & Guidance

- If the pre-requisites are in place all you need to do is to run the following command from the `spring-petclinic` directory

    ```shell
    mvnw spring-boot:run
    ```

- It's possible that the default port `8080` is already in use, in that case you can configure another port using the following option to `mvnw`

    ```shell
    mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dserver.port=8081"
    ```

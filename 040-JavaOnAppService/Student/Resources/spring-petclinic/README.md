# Spring PetClinic Sample Application

## Understanding the Spring Petclinic application with a few diagrams

[See the presentation here](https://speakerdeck.com/michaelisvy/spring-petclinic-sample-application)

## Running petclinic locally

Petclinic is a [Spring Boot](https://spring.io/guides/gs/spring-boot) application built using [Maven](https://spring.io/guides/gs/maven/). You can build a jar file and run it from the command line:

```shell
cd spring-petclinic
./mvnw package
java -jar target/app.jar
```

You can then access petclinic here: [http://localhost:8080/](http://localhost:8080/)

![petclinic-screenshot](https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png)

Or you can run it from Maven directly using the Spring Boot Maven plugin. If you do this it will pick up changes that you make in the project immediately (changes to Java source files require a compile as well - most people use an IDE for this):

```shell
./mvnw spring-boot:run
```

## Database configuration

In its default configuration, Petclinic uses an in-memory database (H2) which gets populated at startup with data. The h2 console is automatically exposed at `http://localhost:8080/h2-console` and it is possible to inspect the content of the database using the `jdbc:h2:mem:testdb` url.

A similar setup is provided for MySql in case a persistent database configuration is needed. Note that whenever the database type is changed, the app needs to be run with a different profile: `spring.profiles.active=mysql` for MySql (and also keep in mind that the database details, such as the url/user/password, need to be passed to the application).

## Working with Petclinic in your IDE

### Prerequisites

The following items should be installed in your system:

* Java 8 or newer.
* [Git command line tool](https://help.github.com/articles/set-up-git)
* Your preferred IDE
  * Eclipse with the m2e plugin. Note: when m2e is available, there is an m2 icon in `Help -> About` dialog. If m2e is
  not there, just follow the install process here: [Eclipse m2e](https://www.eclipse.org/m2e/)
  * [Spring Tools Suite](https://spring.io/tools) (STS)
  * IntelliJ IDEA
  * [VS Code](https://code.visualstudio.com)

### Steps

1. Inside Eclipse or STS

    ```shell
    File -> Import -> Maven -> Existing Maven project
    ```

    Then either build on the command line `./mvnw generate-resources` or using the Eclipse launcher (right click on project and `Run As -> Maven install`) to generate the css. Run the application main method by right clicking on it and choosing `Run As -> Java Application`.

1. Inside IntelliJ IDEA
    In the main menu, choose `File -> Open` and select the Petclinic [pom.xml](pom.xml). Click on the `Open` button.

    CSS files are generated from the Maven build. You can either build them on the command line `./mvnw generate-resources` or right click on the `spring-petclinic` project then `Maven -> Generates sources and Update Folders`.

    A run configuration named `PetClinicApplication` should have been created for you if you're using a recent Ultimate version. Otherwise, run the application by right clicking on the `PetClinicApplication` main class and choosing `Run 'PetClinicApplication'`.

1. Navigate to Petclinic
    Visit [http://localhost:8080](http://localhost:8080) in your browser.

## Looking for something in particular?

|Spring Boot Configuration | Class or Java property files  |
|--------------------------|---|
|The Main Class | [PetClinicApplication](./src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java) |
|Properties Files | [application.properties](./src/main/resources) |
|Caching | [CacheConfiguration](./src/main/java/org/springframework/samples/petclinic/system/CacheConfiguration.java) |

## License

The Spring PetClinic sample application is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).

## Notes

This is a slightly modified version of the sample Spring Boot Pet Clinic Application. The original can be found [here](https://github.com/spring-projects/spring-petclinic).

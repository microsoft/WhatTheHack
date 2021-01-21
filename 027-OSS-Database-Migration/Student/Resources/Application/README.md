[![Build Status](https://travis-ci.org/pzinsta/pizzeria.svg?branch=master)](https://travis-ci.org/pzinsta/pizzeria)

# Pizzeria ([Demo](https://pizzeria-pzinsta.herokuapp.com/))

A pizza ordering web application. 

![Home page](documentation/home.png?raw=true)

The app features a pizza builder that lets the user build a custom pizza from a number of 
ingredients, select a crust, size, bake and cut styles and desired quantity.

![Pizza Builder](documentation/builder.png?raw=true)

The user can also opt for one of the specialty pizzas, and either order one of those predefined templates or customize it however they like.

### Pizza Builder on iPad

![Pizza Builder on iPad](documentation/gifs/builder_ipad.gif?raw=true)

### Pizza Builder on iPhone

![Pizza Builder on iPhone](documentation/gifs/builder_mobile.gif?raw=true)

### Pizza Template

![Pizza Builder for a template](documentation/gifs/builder_template_mobile.gif?raw=true)

### Checkout

![Checkout](documentation/gifs/checkout_as_guest_mobile.gif?raw=true)

### Write a Review

![Write a review](documentation/gifs/write_review_mobile.gif?raw=true)

### Registration

![Registration](documentation/gifs/registration_mobile.gif?raw=true)

### Login

![Login](documentation/gifs/login_mobile.gif?raw=true)

## Design

### High-level Package Diagram

![Package diagram](https://rawgit.com/pzinsta/pizzeria/master/documentation/package_diagram.svg)

### Domain Model Class Diagram

![Domain model class diagram](https://rawgit.com/pzinsta/pizzeria/master/documentation/domain_model_class_diagram.svg)

### Database Schema

![Database schema](https://rawgit.com/pzinsta/pizzeria/master/documentation/database_schema.svg)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

#### 1. [Maven](https://maven.apache.org/download.cgi)
#### 2. [Node.js and npm](https://nodejs.org/en/)
#### 3. [Braintree](https://sandbox.braintreegateway.com/) API keys
1. Go to the [sandbox version](https://sandbox.braintreegateway.com/) of Braintree. 
2. Sign up / log in.
3. Go to Settings - API Keys and get the following:
   1. Merchant ID
   2. Public key
   3. Private key (you'll have to click 'View' to see it)
#### 4. [Google reCAPTCHA](https://www.google.com/recaptcha/admin) keys

1. Go to Google reCAPTCHA and register a new site. 

![recaptcha site registration](documentation/recaptcha_register_site.PNG?raw=true)

2. Get the public (site) and private (secret) keys.

![recaptcha keys](documentation/recaptcha_keys.PNG?raw=true)

The keys above are not valid, so don't try to use them.

### Running the app

#### 1. Clone the repository

```
git clone https://github.com/pzinsta/pizzeria.git
```

#### 2. Build the .war file

```
mvn clean package
```

#### 3. Launch the app

The application won't start unless all the following properties are provided.

| Property              | Description |
| --------------------- |-------------|
| braintree.merchantId  | Braintree merchant ID |
| braintree.publicKey   | Braintree public key |
| braintree.privateKey  | Braintree private key |
| recaptcha.public.key  | Google reCAPTCHA public (site) key |
| recaptcha.private.key | Google reCAPTCHA private (secret) key |

We have two options here. 

##### Option 1. Set the properties as environment variables.

If you've set the properties as environment variables, you can run the following command to start the app:

```
java -jar webapp/target/dependency/webapp-runner.jar --port 8081 --path pizzeria webapp/target/*.war
```

##### Option 2. Pass the properties as JVM arguments

In this case the command is going to be a bit more complicated.

```
java -Dbraintree.merchantId=<your Braintree merchant ID> -Dbraintree.publicKey=<your Braintree public key> -Dbraintree.privateKey=<your Braintree private key> -Drecaptcha.private.key=<your reCAPTCHA private key> -Drecaptcha.public.key=<your reCAPTCHA public key> -jar webapp/target/dependency/webapp-runner.jar --port 8081 --path pizzeria webapp/target/*.war
```

You can modify the port and the context path. Also, there are other [options](https://github.com/jsimone/webapp-runner#options) available.

#### 4. Verify

Go to [http://localhost:8081/pizzeria/](http://localhost:8081/pizzeria/) to check that the app is up and running.

## Built With

* [Maven](https://maven.apache.org/)
* [Spring MVC](https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html)
* [Spring Web Flow](https://projects.spring.io/spring-webflow/)
* [Spring Security](https://projects.spring.io/spring-security/)
* [Hibernate ORM](http://hibernate.org/orm/)
* [Hibernate Validator](http://hibernate.org/validator/)
* [JUnit 4](https://junit.org/junit4/)
* [Mockito](http://site.mockito.org/)
* [AssertJ](http://joel-costigliola.github.io/assertj/)
* [Apache Commons (lang, io, collections, dbcp, text, rng)](https://commons.apache.org/)
* [Google Guava](https://github.com/google/guava)
* [Moneta](http://javamoney.github.io/ri.html)
* [H2](http://www.h2database.com/)
* [PostgreSQL](https://www.postgresql.org/)
* [Bootstrap 3](http://getbootstrap.com/docs/3.3/) 
* [Font Awesome](https://fontawesome.com/v4.7.0/) 
* [Angular](https://angular.io/) 

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [jsimone/webapp-runner](https://github.com/jsimone/webapp-runner) - Webapp runner is designed to allow you to launch an exploded or compressed war that is on your filesystem into a tomcat container with a simple java -jar command.
* [schemacrawler/SchemaCrawler](https://github.com/schemacrawler/SchemaCrawler) - Free database schema discovery and comprehension tool
* [triologygmbh/reCAPTCHA-V2-java](https://github.com/triologygmbh/reCAPTCHA-V2-java) - Java Bindings for reCAPTCHA V2
* [sargue/java-time-jsptags](https://github.com/sargue/java-time-jsptags) - JSP tag support for Java 8 java.time (JSR-310)
* [eirslett/frontend-maven-plugin](https://github.com/eirslett/frontend-maven-plugin) - A Maven plugin that downloads/installs Node and NPM locally, runs NPM install, Grunt, Gulp and/or Karma.
* [auxiliary/rpage](https://github.com/auxiliary/rpage) - Highly responsive pagination for Bootstrap
* [michaelbromley/ngx-pagination](https://github.com/michaelbromley/ngx-pagination) - Pagination for Angular
* [NickeManarin/ScreenToGif](https://github.com/NickeManarin/ScreenToGif) - ScreenToGif allows you to record a selected area of your screen, edit and save it as a gif or video.
* [Full Page Screen Capture](https://chrome.google.com/webstore/detail/full-page-screen-capture/fdpohaocaechififmbbbbbknoalclacl) - Captures a screenshot of your current page

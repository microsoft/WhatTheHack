<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Pizza Builder</title>
        <%@ include file="fragments/head.jspf" %>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>

            <h1 class="page-header">Pizza Builder</h1>
            <form:form method="post" modelAttribute="pizzaBuilderForm">
                <form:errors element="div" cssClass="alert alert-danger"/>

                <%@ include file="fragments/orderItemFormFields.jspf" %>
                <button type="submit" class="btn btn-lg btn-success"><i class="fa fa-cart-plus" aria-hidden="true"></i>
                    Add to cart
                </button>

            </form:form>

        </div>
        <%@ include file="fragments/footer.jspf" %>

        <spring:url value="/resources/javascript/pizzaBuilder.js" var="pizzaBuilderJsUrl"/>
        <script src="${pizzaBuilderJsUrl}"></script>
    </body>
</html>

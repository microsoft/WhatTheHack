<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Edit order item</title>
        <%@ include file="fragments/head.jspf" %>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>
            <h1>Pizza Builder</h1>

            <form:form method="post" modelAttribute="pizzaBuilderForm">
                <spring:bind path="pizzaBuilderForm">
                    <c:if test="${status.error}">
                        <div class="alert alert-danger alert-dismissible">
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <form:errors />
                        </div>
                    </c:if>
                </spring:bind>
                <%@ include file="fragments/orderItemFormFields.jspf" %>

                <button type="submit" class="btn btn-lg btn-success"><i class="fa fa-floppy-o" aria-hidden="true"></i> Save</button>

            </form:form>
        </div>

        <%@ include file="fragments/footer.jspf" %>

        <spring:url value="/resources/javascript/pizzaBuilder.js" var="pizzaBuilderJsUrl"/>
        <script src="${pizzaBuilderJsUrl}"></script>
    </body>
</html>

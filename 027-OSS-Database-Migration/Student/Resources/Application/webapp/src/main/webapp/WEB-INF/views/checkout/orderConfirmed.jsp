<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="../fragments/head.jspf" %>
        <title>Order confirmation</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="../fragments/navbar.jspf" %>

            <h1 class="text-center page-header">Thank you for your order</h1>

            <p class="lead">Your order was placed successfully.</p>

            <p class="lead">You can use the following tracking number to track your order:

                <spring:url value="/order/track/{trackingNumber}" var="trackOrderUrl">
                    <spring:param name="trackingNumber" value="${order.trackingNumber}"/>
                </spring:url>
                <a href="${trackOrderUrl}">${order.trackingNumber}</a>
            </p>

            <div class="text-center">
                <a href="${flowExecutionUrl}&_eventId=finish" class="btn btn-primary btn-lg"><i class="fa fa-flag-checkered" aria-hidden="true"></i> Finish</a>
            </div>

        </div>

        <%@ include file="../fragments/footer.jspf" %>
    </body>
</html>

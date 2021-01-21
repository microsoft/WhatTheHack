<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://sargue.net/jsptags/time" prefix="javatime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Order Tracker</title>
        <%@ include file="fragments/head.jspf" %>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>

            <h1 class="page-header">${order.trackingNumber}</h1>

            <h2>Order events</h2>
            <ul class="list-group">
                <c:forEach items="${order.orderEvents}" var="orderEvent">
                    <li class="list-group-item">
                        <h4 class="list-group-item-heading">
                            <javatime:format value="${orderEvent.occurredOn}" style="MM" />
                        </h4>
                        <p class="list-group-item-text lead">
                            <spring:message code="orderEventType.${orderEvent.orderEventType}"/>
                        </p>
                    </li>
                </c:forEach>
            </ul>

            <c:if test="${not empty order.delivery}">
                <h2>Delivery status</h2>
                <div class="lead">
                    <spring:message code="deliveryStatus.${order.delivery.status}"/>
                </div>
            </c:if>


        </div>
        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>

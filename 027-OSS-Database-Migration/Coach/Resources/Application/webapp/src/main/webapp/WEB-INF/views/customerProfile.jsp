<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Customer profile</title>
        <%@ include file="fragments/head.jspf" %>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>

            <h1 class="page-header text-center">My Profile</h1>

            <div class="row">

                <div class="col-md-4">
                    <form:form modelAttribute="customer" method="post">
                        <%@ include file="fragments/customerDetailsFormFieds.jspf" %>

                        <button type="submit" class="btn btn-lg btn-success"><i class="fa fa-floppy-o"
                                                                                aria-hidden="true"></i> Save
                        </button>
                    </form:form>
                </div>

            </div>

            <c:set value="${requestScope['javax.servlet.forward.servlet_path']}" var="returnUrl"/>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <span class="panel-title"><i class="fa fa-map-marker"
                                                 aria-hidden="true"></i> My delivery addresses</span>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <c:choose>
                            <c:when test="${not empty customer.deliveryAddresses}">
                                <c:forEach var="deliveryAddress" items="${customer.deliveryAddresses}"
                                           varStatus="varStatus">
                                    <div class="col-md-4">
                                        <spring:url value="/customer/deliveryAddress/{deliveryAddressIndex}/remove"
                                                    var="removeDeliveryAddressUrl">
                                            <spring:param name="deliveryAddressIndex" value="${varStatus.index}"/>
                                            <spring:param name="returnUrl" value="${returnUrl}"/>
                                        </spring:url>

                                        <spring:url value="/customer/deliveryAddress/{deliveryAddressIndex}"
                                                    var="editDeliveryAddressUrl">
                                            <spring:param name="deliveryAddressIndex" value="${varStatus.index}"/>
                                            <spring:param name="returnUrl" value="${returnUrl}"/>
                                        </spring:url>

                                        <div class="panel panel-default">
                                            <div class="panel-body">
                                                <%@ include file="fragments/deliveryAddress.jspf" %>
                                            </div>
                                            <div class="panel-footer">
                                                <div>
                                                    <a href="${editDeliveryAddressUrl}" class="btn btn-primary"><i
                                                            class="fa fa-pencil" aria-hidden="true"></i> Edit</a>
                                                    <a href="${removeDeliveryAddressUrl}" class="btn btn-danger"><i
                                                            class="fa fa-trash" aria-hidden="true"></i> Remove</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <div class="col-md-4">You don't have any delivery addresses.</div>
                            </c:otherwise>

                        </c:choose>
                    </div>

                </div>
                <div class="panel-footer">
                    <spring:url value="/customer/deliveryAddress/add" var="addDeliveryAddressUrl"/>
                    <a href="${addDeliveryAddressUrl}" class="btn btn-success btn-lg"><i class="fa fa-plus"
                                                                                         aria-hidden="true"></i> Add a
                        delivery address</a>
                </div>
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <span class="panel-title"><i class="fa fa-shopping-cart" aria-hidden="true"></i> My orders</span>
                </div>

                <div class="panel-body">
                    <div class="row">
                        <c:choose>
                            <c:when test="${not empty customer.orders}">
                                <c:forEach items="${customer.orders}" var="order">
                                    <div class="col-sm-12">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="panel-title">
                                                    <span>${order.trackingNumber}</span>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
                                                    <c:forEach items="${order.orderItems}" var="orderItem">
                                                        <div class="col-md-4">
                                                            <div class="panel panel-default">
                                                                <div class="panel-heading">
                                                                    <div class="panel-title">

                                                                        <c:set var="leftPizzaSideName"
                                                                               value="${orderItem.pizza.leftPizzaSide.name}"/>
                                                                        <c:set var="rightPizzaSideName"
                                                                               value="${orderItem.pizza.rightPizzaSide.name}"/>
                                                                        <span>
                                                                            <c:choose>
                                                                                <c:when test="${empty leftPizzaSideName and empty rightPizzaSideName}">Custom</c:when>
                                                                                <c:when test="${leftPizzaSideName eq rightPizzaSideName}">${leftPizzaSideName}</c:when>
                                                                                <c:when test="${empty leftPizzaSideName}">${rightPizzaSideName}</c:when>
                                                                                <c:when test="${empty rightPizzaSideName}">${leftPizzaSideName}</c:when>
                                                                                <c:otherwise>${leftPizzaSideName} / ${rightPizzaSideName}</c:otherwise>
                                                                            </c:choose>
                                                                            <span>x ${orderItem.quantity}</span>
                                                                        </span>

                                                                    </div>
                                                                </div>
                                                                <div class="panel-body">
                                                                    <%@ include file="fragments/orderItem.jspf" %>
                                                                </div>
                                                                <div class="panel-footer">
                                                                    <spring:url value="/builder/template/{orderItemId}" var="buildFromOrderItemUrl">
                                                                        <spring:param name="orderItemId" value="${orderItem.id}"/>
                                                                    </spring:url>
                                                                    <a href="${buildFromOrderItemUrl}" class="btn btn-primary">Go to builder <i class="fa fa-chevron-right" aria-hidden="true"></i></a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="panel-footer">
                                                <spring:url value="/order/track/{trackingNumber}" var="orderTrackerUrl">
                                                    <spring:param name="trackingNumber" value="${order.trackingNumber}"/>
                                                </spring:url>
                                                <a href="${orderTrackerUrl}" class="btn btn-primary"><i
                                                        class="fa fa-search" aria-hidden="true"></i> Track the order</a>

                                                <spring:url value="/review/order/{trackingNumber}" var="reviewUrl">
                                                    <spring:param name="trackingNumber" value="${order.trackingNumber}"/>
                                                    <spring:param name="returnUrl" value="/customer"/>
                                                </spring:url>
                                                <a href="${reviewUrl}" class="btn btn-primary"><i class="fa fa-pencil"
                                                                                                  aria-hidden="true"></i>
                                                    Add/Edit a review</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                            </c:when>
                            <c:otherwise>
                                <div class="col-md-4">
                                    <span>You don't have any orders.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>

        </div>

        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>

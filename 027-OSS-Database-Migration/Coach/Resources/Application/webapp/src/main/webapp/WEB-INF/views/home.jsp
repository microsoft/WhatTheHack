<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="fragments/head.jspf" %>
        <title>Pizzeria</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>

            <div class="jumbotron">
                <h1 class="text-center">Build a pizza with our pizza builder</h1>
                <br>
                <spring:url var="builderUrl" value="/builder"/>
                <div class="text-center">
                    <a class="btn btn-lg btn-primary" href="${builderUrl}" role="button">Start building <i class="fa fa-chevron-right" aria-hidden="true"></i></a>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <span class="panel-title"><i class="fa fa-shopping-cart" aria-hidden="true"></i> My Cart</span>
                    <c:if test="${not empty cart.orderItems}">
                        <div>
                            <spring:url value="/checkout" var="checkoutUrl"/>
                            <a href="${checkoutUrl}" class="btn btn-success"><i class="fa fa-credit-card" aria-hidden="true"></i> Checkout</a>
                            <spring:url value="/order/orderItem/clear" var="clearUrl">
                                <spring:param name="redirectTo" value="${redirectToUrl}"/>
                            </spring:url>
                            <a href="${clearUrl}" class="btn btn-danger"><i class="fa fa-trash" aria-hidden="true"></i> Clear</a>
                        </div>
                    </c:if>
                </div>
                <div class="panel-body">
                    <c:choose>
                        <c:when test="${not empty cart.orderItems}">
                            <div class="row">
                                    <%--@elvariable id="cart" type="pzinsta.pizzeria.model.order.Cart"--%>
                                <c:forEach items="${cart.orderItems}" var="orderItem" varStatus="varStatus">
                                    <div class="col-sm-6">
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
                                                        x ${orderItem.quantity}
                                                    </span>
                                                </div>

                                                <c:set value="${requestScope['javax.servlet.forward.servlet_path']}"
                                                       var="redirectToUrl"/>

                                                <spring:url value="/order/orderItem/{orderItemId}/edit"
                                                            var="editOrderItemUrl">
                                                    <spring:param name="orderItemId" value="${varStatus.index}"/>
                                                    <spring:param name="redirectTo" value="${redirectToUrl}"/>
                                                </spring:url>
                                                <a href="${editOrderItemUrl}" class="btn btn-primary"><i
                                                        class="fa fa-pencil" aria-hidden="true"></i> Edit</a>

                                                <spring:url value="/order/orderItem/{orderItemId}/remove}"
                                                            var="removeOrderItemUrl">
                                                    <spring:param name="orderItemId" value="${varStatus.index}"/>
                                                    <spring:param name="redirectTo" value="${redirectToUrl}"/>
                                                </spring:url>
                                                <a href="${removeOrderItemUrl}" class="btn btn-danger"><i
                                                        class="fa fa-trash" aria-hidden="true"></i> Remove</a>
                                            </div>
                                            <div class="panel-body">
                                                <%@ include file="fragments/orderItem.jspf" %>

                                            </div>

                                        </div>
                                    </div>

                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            Cart is empty.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fa fa-cutlery" aria-hidden="true"></i> Specialty Pizzas</h3>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <c:forEach items="${orderItemTemplates}" var="orderItemTemplate">
                            <div class="col-sm-4 col-md-3">
                                <div class="thumbnail text-center">
                                    <spring:url value="/builder/template/{orderItemId}" var="pizzaBuilderTemplateUrl">
                                        <spring:param name="orderItemId" value="${orderItemTemplate.orderItem.id}"/>
                                    </spring:url>
                                    <a href="${pizzaBuilderTemplateUrl}">
                                        <spring:url value="/resources/images/{imageFileName}" var="imageUrl">
                                            <spring:param name="imageFileName" value="${orderItemTemplate.imageFileName}"/>
                                        </spring:url>
                                        <img src="${imageUrl}">
                                        <div class="caption">
                                            <h3>${orderItemTemplate.orderItem.pizza.leftPizzaSide.name}</h3>
                                        </div>
                                        <a href="${pizzaBuilderTemplateUrl}" class="btn btn-primary">Start Building <i class="fa fa-chevron-right" aria-hidden="true"></i></a>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

        </div>
        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>
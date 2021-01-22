<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="../fragments/head.jspf" %>
        <title>Select a delivery address</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="../fragments/navbar.jspf" %>

            <div class="row">
                <div class="col-xs-12">
                    <h1 class="text-center page-header">Select a delivery address</h1>
                    <spring:url value="${requestScope['javax.servlet.forward.servlet_path']}" context="/"
                                var="returnUrl">
                        <spring:param name="execution" value="${requestScope.flowExecutionKey}"/>
                    </spring:url>

                    <form:form method="post"><%--@elvariable id="customer" type="pzinsta.pizzeria.model.user.Customer"--%>
                            <div class="panel panel-info">
                                <div class="panel-body">
                                    <div class="row">
                                        <c:choose>
                                            <c:when test="${not empty customer.deliveryAddresses}">
                                                <c:forEach var="deliveryAddress" items="${customer.deliveryAddresses}"
                                                           varStatus="varStatus">
                                                    <div class="col-md-4 col-xs-12">
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                    <label for="deliveryAddress${varStatus.index}">
                                                                        <input type="radio" name="deliveryAddressIndex" value="${varStatus.index}" id="deliveryAddress${varStatus.index}">
                                                                    </label>
                                                            </div>
                                                            <div class="panel-body">
                                                                <%@ include file="../fragments/deliveryAddress.jspf" %>
                                                            </div>
                                                            <div class="panel-footer">
                                                                <div>
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
                            </div>


                        <spring:url value="/customer/deliveryAddress/add" var="addDeliveryAddressUrl">
                            <spring:param name="returnUrl" value="${returnUrl}"/>
                        </spring:url>

                        <a href="${addDeliveryAddressUrl}" class="btn btn-success"><i class="fa fa-plus" aria-hidden="true"></i> Add a delivery address</a>
                        <button type="submit" name="_eventId_continue" class="btn btn-primary">Continue <i class="fa fa-chevron-right" aria-hidden="true"></i></button>
                    </form:form>
                </div>
            </div>

        </div>


        <%@ include file="../fragments/footer.jspf" %>
    </body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            <h1 class="text-center page-header">Checkout</h1>
            <div class="row">
                <c:forEach items="${cart.orderItems}" var="orderItem">
                    <div class="col-md-4">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <%@ include file="../fragments/orderItem.jspf" %>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <form:form method="post">
                <input type="hidden" name="_flowExecutionKey" value="${flowExecutionKey}"/>
                <a href="${flowExecutionUrl}&_eventId=cancel" class="btn btn-danger"><i class="fa fa-ban" aria-hidden="true"></i> Cancel</a>
                <button type="submit" name="_eventId_continue" class="btn btn-primary">Continue <i class="fa fa-chevron-right" aria-hidden="true"></i></button>
            </form:form>

        </div>


        <%@ include file="../fragments/footer.jspf" %>
    </body>
</html>

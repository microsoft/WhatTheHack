<%--@elvariable id="customer" type="pzinsta.pizzeria.model.user.Customer"--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="../fragments/head.jspf" %>
        <title>Delivery address</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="../fragments/navbar.jspf" %>
            <h1 class="text-center page-header">Delivery address</h1>
            <div class="row">
                <div class="col-md-4 col-md-offset-4 col-xs-12 col-sm-6 col-sm-offset-3">
                    <form:form modelAttribute="deliveryAddress" method="post">

                        <%@ include file="../fragments/deliveryAddressFormFields.jspf" %>

                        <input type="hidden" name="_flowExecutionKey" value="${flowExecutionKey}"/>
                        <a href="${flowExecutionUrl}&_eventId=cancel" class="btn btn-danger"><i class="fa fa-ban" aria-hidden="true"></i> Cancel</a>
                        <button type="submit" name="_eventId_continue" class="btn btn-primary">Continue <i class="fa fa-chevron-right" aria-hidden="true"></i></button>
                    </form:form>
                </div>
            </div>

        </div>

        <%@ include file="../fragments/footer.jspf" %>
    </body>
</html>


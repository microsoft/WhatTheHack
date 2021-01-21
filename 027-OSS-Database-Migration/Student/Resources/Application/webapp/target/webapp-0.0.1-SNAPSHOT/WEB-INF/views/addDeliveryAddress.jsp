<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <%@ include file="fragments/head.jspf" %>
        <title>Add delivery address</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>
            <div class="row">
                <div class="col-sm-4 col-sm-offset-4 col-xs-12">
                    <form:form method="post" modelAttribute="deliveryAddressForm">
                        <%@ include file="fragments/deliveryAddressFormFields.jspf" %>
                        <button type="submit" class="btn btn-success btn-lg"><i class="fa fa-plus" aria-hidden="true"></i> Add</button>
                    </form:form>
                </div>
            </div>

        </div>
        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>

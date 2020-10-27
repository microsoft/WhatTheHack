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
            <h1 class="page-header text-center">Order type</h1>
            <div class="row">
                <div class="col-xs-12 text-center">
                    <form:form method="post">
                        <button type="submit" name="_eventId_carryOut" class="btn btn-default btn-lg"><i
                                class="fa fa-blind" aria-hidden="true"></i> Carry out
                        </button>
                        <button type="submit" name="_eventId_delivery" class="btn btn-default btn-lg"><i
                                class="fa fa-truck fa-flip-horizontal" aria-hidden="true"></i> Delivery
                        </button>
                    </form:form>
                </div>
            </div>
        </div>

        <%@ include file="../fragments/footer.jspf" %>
    </body>
</html>
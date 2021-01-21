<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Write a review</title>
        <%@ include file="fragments/head.jspf" %>
      </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>
            <div class="row">
                <div class="col-md-4 col-md-offset-4 col-xs-12 col-sm-6 col-sm-offset-3">

                    <spring:url value="/review/order" var="orderReviewSearchProcessingUrl"/>

                    <form:form method="post" action="${orderReviewSearchProcessingUrl}">
                        <c:if test="${orderNotFound}">
                            <div class="alert alert-danger alert-dismissible">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <span>Order with the given tracking number was not found.</span>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <input name="trackingNumber" id="trackingNumber" class="form-control input-lg" placeholder="Tracking number" autocomplete="on"/>
                        </div>
                        <button type="submit" class="btn btn-primary btn-lg"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
                    </form:form>
                </div>
            </div>


        </div>
        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>

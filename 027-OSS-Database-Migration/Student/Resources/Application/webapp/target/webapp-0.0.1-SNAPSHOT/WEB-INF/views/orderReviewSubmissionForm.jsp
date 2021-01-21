<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Write a review</title>
        <%@ include file="fragments/head.jspf" %>
        <spring:url value="/resources/css/starRating.css" var="starRatingUrl"/>
        <link rel="stylesheet" href="${starRatingUrl}">
    </head>
    <body>
        <div class="container">

            <%@ include file="fragments/navbar.jspf" %>

            <spring:url value="" var="actionUrl">
                <spring:param name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </spring:url>

            <div class="row">

                <div class="col-sm-6 col-sm-offset-3">
                    <h1>${order.trackingNumber}</h1>
                    <form:form method="post" modelAttribute="reviewForm" action="${actionUrl}" enctype="multipart/form-data">

                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-12">
                                    <fieldset class="rating">
                                        <c:forEach items="${ratings}" var="rating" varStatus="varStatus">
                                            <c:set value="${fn:length(ratings) - rating + 1}" var="stars"/>
                                            <form:radiobutton path="rating" id="star${stars}" value="${stars}"/>
                                            <form:label path="rating" for="star${stars}"
                                                        title="${stars} stars">${stars} stars</form:label>
                                        </c:forEach>
                                    </fieldset>
                                </div>
                            </div>
                            <form:errors path="rating" element="div" cssClass="col-md-12 text-danger"/>
                        </div>

                        <div class="form-group">
                            <form:label path="message" cssErrorClass="text-danger">Message:</form:label>
                            <form:textarea path="message" cols="50" rows="5" cssClass="form-control"/>
                            <form:errors path="message" cssClass="text-danger"/>
                        </div>

                        <div class="form-group">
                            <form:input path="images" type="file" multiple="multiple" accept="image/*"/>
                            <form:errors path="images" cssClass="text-danger"/>
                            <p class="help-block">Supported formats: PNG, JPG, GIF, BMP.</p>
                        </div>

                        <button type="submit" class="btn btn-primary">Submit</button>
                    </form:form>

                </div>
            </div>

        </div>
        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>

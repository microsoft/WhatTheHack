<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="../fragments/head.jspf" %>
        <title>Sign in</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="../fragments/navbar.jspf" %>
            <h1 class="text-center page-header">Sign in</h1>
            <div class="row">
                <div class="col-xs-12">
                    <c:choose>
                        <c:when test="${not empty currentUser}">
                            <div class="alert alert-success">
                                You logged in as ${currentUser.name}.
                            </div>
                            <form:form method="post">
                                <button type="submit" name="_eventId_continue" class="btn btn-primary">Continue <i
                                        class="fa fa-chevron-right" aria-hidden="true"></i></button>
                            </form:form>
                        </c:when>
                        <c:otherwise>
                            <c:url value="/login" var="loginUrl"/>

                            <form:form action="${loginUrl}" method="post" cssClass="form-horizontal">
                                <spring:url value="${requestScope['javax.servlet.forward.servlet_path']}"
                                            context="/"
                                            var="returnUrl">
                                    <spring:param name="execution" value="${requestScope.flowExecutionKey}"/>
                                </spring:url>
                                <input type="hidden" name="returnUrl" value="${returnUrl}">

                            </form:form>
                            <spring:url value="/account/register" var="registrationUrl">
                                <spring:param name="returnUrl" value="${returnUrl}"/>
                            </spring:url>

                            <form:form method="post" cssClass="form-horizontal">
                                <div class="form-group">
                                    <div class="col-xs-6">
                                        <c:set var="requestPath" value="${requestScope['javax.servlet.forward.servlet_path']}"/>
                                        <c:set var="params" value="${requestScope['javax.servlet.forward.query_string']}"/>
                                        <c:set var="pageUrl" value="${ requestPath }${ not empty params?'?'+=params:'' }"/>
                                        <spring:url value="/login" var="loginUrl">
                                            <spring:param name="returnUrl" value="${pageUrl}"/>
                                        </spring:url>
                                        <a href="${loginUrl}" class="btn btn-primary"><i class="fa fa-sign-in" aria-hidden="true"></i> Log in</a>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-xs-6">
                                        <a href="${registrationUrl}" class="btn btn-default">
                                            <i class="fa fa-user-plus" aria-hidden="true"></i> Register
                                        </a>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-xs-12">
                                        <button type="submit" name="_eventId_orderAsGuest" class="btn btn-default">
                                            <i class="fa fa-user-secret" aria-hidden="true"></i> Order as a guest
                                        </button>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-xs-12">
                                        <a href="${flowExecutionUrl}&_eventId=cancel" class="btn btn-danger">
                                            <i class="fa fa-ban" aria-hidden="true"></i> Cancel
                                        </a>
                                    </div>
                                </div>
                            </form:form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%@ include file="../fragments/footer.jspf" %>
    </body>
</html>



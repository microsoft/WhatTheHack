<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="fragments/head.jspf" %>
        <title>Log in</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>
            <h1 class="page-header text-center">Log in</h1>
            <div class="row">
                <div class="col-md-6 col-md-offset-3 col-xs-12 col-sm-8 col-sm-offset-2">
                    <form method="post" class="form-horizontal" id="login-form">
                        <%@ include file="fragments/loginFormFields.jspf" %>
                    </form>
                </div>
            </div>

        </div>
        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>
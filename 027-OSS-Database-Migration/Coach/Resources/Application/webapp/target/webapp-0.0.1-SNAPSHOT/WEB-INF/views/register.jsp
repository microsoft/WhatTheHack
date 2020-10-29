<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Register</title>
        <script src='https://www.google.com/recaptcha/api.js'></script>
        <%@ include file="fragments/head.jspf" %>
    </head>
    <body>
        <div class="container">
            <%@ include file="fragments/navbar.jspf" %>
            <h1 class="page-header text-center">Register</h1>
            <div class="row">
                <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-12">
                    <form:form method="post" modelAttribute="customerRegistrationForm">
                        <div class="form-group required">
                            <form:label path="username" cssClass="control-label">Username</form:label>
                            <form:input path="username" cssClass="form-control"/>
                            <form:errors path="username" cssClass="text-danger"/>
                        </div>

                        <div class="form-group required">
                            <form:label path="password" cssClass="control-label">Password</form:label>
                            <form:password path="password" cssClass="form-control"/>
                            <form:errors path="password" cssClass="text-danger"/>
                        </div>

                        <div class="form-group required">
                            <form:label path="passwordAgain" cssClass="control-label">Repeat password</form:label>
                            <form:password path="passwordAgain" cssClass="form-control"/>
                            <form:errors path="passwordAgain" cssClass="text-danger"/>
                        </div>

                        <div class="form-group">
                            <form:label path="firstName" cssClass="control-label">First name</form:label>
                            <form:input path="firstName" cssClass="form-control"/>
                            <form:errors path="firstName" cssClass="text-danger"/>
                        </div>

                        <div class="form-group">
                            <form:label path="lastName" cssClass="control-label">Last name</form:label>
                            <form:input path="lastName" cssClass="form-control"/>
                            <form:errors path="lastName" cssClass="text-danger"/>
                        </div>

                        <div class="form-group">
                            <form:label path="email" cssClass="control-label">Email</form:label>
                            <form:input path="email" type="email" cssClass="form-control"/>
                            <form:errors path="email" cssClass="text-danger"/>
                        </div>

                        <div class="form-group">
                            <form:label path="phoneNumber" cssClass="control-label">Phone number</form:label>
                            <form:input path="phoneNumber" cssClass="form-control"/>
                            <form:errors path="phoneNumber" cssClass="text-danger"/>
                        </div>

                        <div class="g-recaptcha form-group" data-sitekey="${recaptchaPublicKey}"></div>

                        <button type="submit" class="btn btn-lg btn-success"><i class="fa fa-user-plus" aria-hidden="true"></i> Sign up</button>
                    </form:form>
                </div>
            </div>


        </div>


        <%@ include file="fragments/footer.jspf" %>
    </body>
</html>

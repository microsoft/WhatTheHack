<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="../fragments/head.jspf" %>
        <title>Enter a comment</title>
    </head>
    <body>
        <div class="container">
            <%@ include file="../fragments/navbar.jspf" %>
            <h1 class="text-center page-header">Leave a comment</h1>

            <div class="row">
                <div class="col-xs-12 col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
                    <form:form modelAttribute="order">
                        <div class="form-group">
                            <form:label path="comment" cssClass="control-label">Comment</form:label>
                            <form:textarea path="comment" cssClass="form-control" rows="3" cols="20"/>
                            <form:errors path="comment"/>
                        </div>
                        <div class="form-group">

                            <button type="submit" name="_eventId_continue" class="btn btn-primary">Continue <i class="fa fa-chevron-right" aria-hidden="true"></i></button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>

        <%@ include file="../fragments/footer.jspf" %>
    </body>
</html>

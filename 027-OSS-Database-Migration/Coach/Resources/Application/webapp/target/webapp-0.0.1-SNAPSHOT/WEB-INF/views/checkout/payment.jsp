<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Payment</title>
        <%@ include file="../fragments/head.jspf" %>
        <script src="https://js.braintreegateway.com/web/dropin/1.10.0/js/dropin.min.js"></script>
    </head>
    <body>

        <div class="container">
            <%@ include file="../fragments/navbar.jspf" %>

            <h1 class="text-center page-header">Payment</h1>

            <dl class="dl-horizontal">
                <dt>Order:</dt>
                <dd>${orderCost}</dd>
                <dt>Delivery:</dt>
                <dd>${deliveryCost}</dd>
                <dt>Total:</dt>
                <dd><strong>${total}</strong></dd>
            </dl>

            <div class="alert alert-danger">
                <strong>Please do not use a real card number, expiration date and CVV!</strong>
            </div>

            <div class="alert alert-info">
                <p>Here's a valid test VISA card.</p>
                <p>Card Number: <strong>4111 1111 1111 1111</strong></p>
                <p>Expiration Date: <strong>11/22</strong></p>
                <p>CVV: <strong>111</strong></p>
                <p><a href="https://developers.braintreepayments.com/guides/credit-cards/testing-go-live/java">More test credit cards.</a></p>
            </div>

            <form:form method="post" id="paymentForm" autocomplete="false">

                <input type="hidden" id="nonce" name="payment_method_nonce"/>
                <input type="hidden" name="_eventId" value="continue">

                <div id="dropin-container"></div>

                <button class="btn btn-primary" type="submit" id="purchaseButton" data-loading-text="Processing..."><i class="fa fa-money" aria-hidden="true"></i> Purchase</button>
                <a href="${flowExecutionUrl}&_eventId=cancel" id="cancelButton" class="btn btn-danger"><i class="fa fa-ban" aria-hidden="true"></i> Cancel</a>
            </form:form>
        </div>

        <%@ include file="../fragments/footer.jspf" %>

        <script>

            var form = document.querySelector('#paymentForm');
            var client_token = '${clientToken}';

            braintree.dropin.create({
                authorization: client_token,
                container: '#dropin-container'
            }, function (createErr, instance) {
                form.addEventListener('submit', function (event) {
                    event.preventDefault();

                    $('#purchaseButton').button('loading');
                    $('#cancelButton').attr('disabled', true);

                    instance.requestPaymentMethod(function (err, payload) {
                        if (err) {
                            console.log('Error', err);
                            $('#purchaseButton').button('reset');
                            $('#cancelButton').attr('disabled', false);
                            return;
                        }
                        // Add the nonce to the form and submit
                        document.querySelector('#nonce').value = payload.nonce;
                        form.submit();
                    });
                });
            });

        </script>

    </body>
</html>

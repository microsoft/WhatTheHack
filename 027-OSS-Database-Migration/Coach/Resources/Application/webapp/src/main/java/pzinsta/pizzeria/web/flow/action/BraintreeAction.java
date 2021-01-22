package pzinsta.pizzeria.web.flow.action;

import com.braintreegateway.BraintreeGateway;
import com.braintreegateway.Result;
import com.braintreegateway.Transaction;
import com.braintreegateway.Transaction.Status;
import com.braintreegateway.TransactionRequest;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.money.MonetaryAmount;
import java.math.BigDecimal;
import java.util.EnumSet;
import java.util.Set;

@Component
public class BraintreeAction {

    private static final Set<Status> TRANSACTION_SUCCESS_STATUSES = EnumSet.of(
            Status.AUTHORIZED,
            Status.AUTHORIZING,
            Status.SETTLED,
            Status.SETTLEMENT_CONFIRMED,
            Status.SETTLEMENT_PENDING,
            Status.SETTLING,
            Status.SUBMITTED_FOR_SETTLEMENT
    );

    private BraintreeGateway braintreeGateway;

    @Autowired
    public BraintreeAction(BraintreeGateway braintreeGateway) {
        this.braintreeGateway = braintreeGateway;
    }

    public String generateClientToken() {
        return braintreeGateway.clientToken().generate();
    }

    public String chargeCustomer(String nonce, MonetaryAmount orderCost, MonetaryAmount deliveryCost) {
        BigDecimal amount = orderCost.add(deliveryCost).getNumber().numberValue(BigDecimal.class);

        TransactionRequest transactionRequest = new TransactionRequest().paymentMethodNonce(nonce)
                .amount(amount).options().submitForSettlement(true).done();


        Result<Transaction> transactionResult = braintreeGateway.transaction().sale(transactionRequest);

        return transactionResult.isSuccess() ? transactionResult.getTarget().getId() : StringUtils.EMPTY;
    }

    public boolean isTransactionSuccessful(String transactionId) {
        if (StringUtils.isEmpty(transactionId)) {
            return false;
        }

        Transaction transaction = braintreeGateway.transaction().find(transactionId);
        return TRANSACTION_SUCCESS_STATUSES.contains(transaction.getStatus());
    }
}

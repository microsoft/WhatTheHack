from shared.assistant_tools import (create_customer_account, get_customer_account_balance, make_bank_account_deposit,
                                    make_bank_account_withdrawal, \
                                    serialize_assistant_response, is_properly_formatted_email_address)


def v_is_properly_formatted_email_address(email_address: str) -> str:
    result = is_properly_formatted_email_address(email_address)
    return serialize_assistant_response(result)


def v_create_customer_account(customer_email: str, first_name: str, last_name: str) -> str:
    return serialize_assistant_response(create_customer_account(customer_email, first_name, last_name))


def v_get_customer_account_balance(customer_email: str) -> str:
    return serialize_assistant_response(get_customer_account_balance(customer_email))


def v_make_bank_account_deposit(customer_email: str, deposit_amount: float) -> str:
    return serialize_assistant_response(make_bank_account_deposit(customer_email, deposit_amount))


def v_make_bank_account_withdrawal(customer_email: str, withdrawal_amount: float) -> str:
    return serialize_assistant_response(make_bank_account_withdrawal(customer_email, withdrawal_amount))

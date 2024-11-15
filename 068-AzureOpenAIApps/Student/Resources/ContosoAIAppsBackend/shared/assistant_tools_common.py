from shared.assistant_tools import serialize_assistant_response, \
    check_if_customer_account_exists, get_customer_account_details


def v_check_if_customer_account_exists(customer_email: str) -> str:
    """
    Check if customer accounts exists. It returns True on success and False otherwise
    """
    return serialize_assistant_response(check_if_customer_account_exists(customer_email))


def v_get_customer_account_details(customer_email: str) -> str:
    """
    Returns a JSON object representing the profile of the customer
    :param customer_email: the email address of the customer account used for the lookup
    :return:
    """
    return serialize_assistant_response(get_customer_account_details(customer_email))




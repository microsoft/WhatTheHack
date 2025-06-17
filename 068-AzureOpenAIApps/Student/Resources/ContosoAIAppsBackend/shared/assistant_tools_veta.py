from shared.assistant_tools import serialize_assistant_response, get_yacht_details, \
    calculate_reservation_grand_total_amount, yacht_travel_party_size_within_capacity, \
    bank_account_balance_is_sufficient, yacht_is_available_for_date, get_valid_reservation_search_dates, \
    is_valid_search_date, get_yacht_availability_by_id, get_yacht_availability_by_date, create_yacht_reservation, \
    yacht_reservation_exists, get_reservation_details, cancel_yacht_reservation, get_customer_yacht_reservations, \
    get_customer_account_balance


def v_get_yacht_details(yacht_id: str) -> str:
    """Returns the yacht details for the given yacht id

        :param yacht_id: str - the yacht identifier
        :return: Yacht an object containing the yacht details"""
    result = get_yacht_details(yacht_id)
    return serialize_assistant_response(result)


def v_calculate_reservation_grand_total_amount(yacht_id: str, number_of_passengers: int) -> str:
    result = calculate_reservation_grand_total_amount(yacht_id, number_of_passengers)
    return serialize_assistant_response(result)


def v_yacht_travel_party_size_within_capacity(yacht_id: str, number_of_passengers: int) -> str:
    result = yacht_travel_party_size_within_capacity(yacht_id, number_of_passengers)
    return serialize_assistant_response(result)


def v_get_bank_account_balance(customer_email: str) -> str:
    response = get_customer_account_balance(customer_email)
    return serialize_assistant_response(response)


def v_bank_account_balance_is_sufficient(bank_account_balance: float, reservation_total: float) -> str:
    response = bank_account_balance_is_sufficient(bank_account_balance, reservation_total)
    return serialize_assistant_response(response)


def v_get_valid_reservation_search_dates() -> str:
    response = get_valid_reservation_search_dates()
    return serialize_assistant_response(response)


def v_yacht_is_available_for_date(yacht_id: str, search_date: str) -> str:
    response = yacht_is_available_for_date(yacht_id, search_date)
    return serialize_assistant_response(response)


def v_is_valid_search_date(search_date: str) -> str:
    response = is_valid_search_date(search_date)
    return serialize_assistant_response(response)


def v_get_yacht_availability_by_id(yacht_id: str) -> str:
    response = get_yacht_availability_by_id(yacht_id)
    return serialize_assistant_response(response)


def v_get_yacht_availability_by_date(search_date: str) -> str:
    response = get_yacht_availability_by_date(search_date)
    return serialize_assistant_response(response)


def v_yacht_reservation_exists(reservation_id: str) -> str:
    response = yacht_reservation_exists(reservation_id)
    return serialize_assistant_response(response)


def v_get_reservation_details(reservation_id: str) -> str:
    response = get_reservation_details(reservation_id)
    return serialize_assistant_response(response)


def v_cancel_yacht_reservation(reservation_id: str) -> str:
    response = cancel_yacht_reservation(reservation_id)
    return serialize_assistant_response(response)


def v_get_customer_yacht_reservations(customer_email: str) -> str:
    response = get_customer_yacht_reservations(customer_email)
    return serialize_assistant_response(response)


def v_create_yacht_reservation(yacht_id: str, reservation_date: str, customer_email: str, passenger_count: int) -> str:
    response = create_yacht_reservation(yacht_id, reservation_date, customer_email, passenger_count)
    return serialize_assistant_response(response)

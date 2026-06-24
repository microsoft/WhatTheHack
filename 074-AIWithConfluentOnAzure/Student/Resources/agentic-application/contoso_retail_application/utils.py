import base64

def base64_encode(input_value: str) -> str:
    encoded_bytes: str = base64.b64encode(input_value.encode("utf-8")).decode("utf-8")
    return encoded_bytes

def base64_decode(encoded_text: str) -> str:
    decoded_bytes: str = base64.b64decode(encoded_text.encode("utf-8")).decode('utf-8')
    return decoded_bytes

import hashlib


class CryptoUtils:

    @staticmethod
    def sha1_hash(input_string: str):
        # Create the SHA-1 hash object
        sha1_hash = hashlib.sha1()

        # Update the hash object with the input string
        sha1_hash.update(input_string.encode("utf-8"))

        # Get the hexadecimal representation of the hash
        hashed_result = sha1_hash.hexdigest()

        return hashed_result

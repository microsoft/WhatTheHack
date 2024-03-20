import redis
import json
import os


class RedisUtil:
    """Utility class to handle interacting with Redis to store and retrieve cached data"""

    def __init__(self):
        """Initialize RedisUtil object"""
        redis_host = os.environ.get('REDIS_HOST')
        redis_port = int(os.environ.get('REDIS_PORT', "6380"))
        redis_password = os.environ.get('REDIS_PASSWORD')

        self.redis_client = redis.StrictRedis(host=redis_host, port=redis_port, password=redis_password, ssl=True)

    def set(self, key, value):
        """Sets a value in the redis for the specified key"""
        self.redis_client.set(key, value)
        return self

    def set_json(self, key, value):
        """Sets a value in the redis for the specified key after the item is JSON serialized"""
        value_to_serialize = json.dumps(value)
        return self.set(key, value_to_serialize)

    def get(self, key):
        """Gets a value from the redis for the specified key"""
        return self.redis_client.get(key)

    def get_json(self, key):
        """Gets a deserialized value from the redis for the specified key"""
        serialized_value = self.get(key)
        de_serialized_value = json.loads(serialized_value)
        return de_serialized_value

    def delete(self, key):
        """Deletes a value from the redis for the specified key"""
        self.redis_client.delete(key)

    def l_push(self, key, values):
        """Appends a value to the redis list for the specified key to the head of the list"""
        return self.redis_client.lpush(key, values)

    def l_range(self, key, start, end):
        """Retrieves the items in the list for the specified key"""
        return self.redis_client.lrange(key, start, end)

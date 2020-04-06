import sys
import random
import string
import unittest
from src.main import *


class TestVotingSetup(unittest.TestCase):
    def test_button1_value_set_from_config(self):
        self.assertEqual(button1, app.config['VOTE1VALUE'])

    def test_button2_value_set_from_config(self):
        self.assertEqual(button2, app.config['VOTE2VALUE'])

    def test_title_should_be_initialized_from_config(self):
        self.assertEqual(title, app.config['TITLE'])

    def get_random_string(self, length=10):
        return ''.join(random.choice(string.ascii_lowercase) for i in range(length))


if __name__ == '__main__':
    unittest.main()

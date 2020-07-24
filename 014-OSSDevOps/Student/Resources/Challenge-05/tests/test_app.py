import sys
from src.main import app
import unittest
import json


class TestVotingApp(unittest.TestCase):
    def setUp(self):
        app.testing = True
        self.app = app.test_client()

    def test_app_not_none(self):
        self.assertIsNotNone(self.app)

    def test_index(self):
        index = self.app.get('/', follow_redirects=True)
        self.assertEqual(index.status_code, 200)

    def test_index_loads_html(self):
        index = self.app.get('/', follow_redirects=True)
        self.assertIn("html", str(index.data))


if __name__ == '__main__':
    unittest.main()

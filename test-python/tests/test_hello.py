import unittest
from src import hello


class TestHello(unittest.TestCase):
    def test_hello(self):
        res = hello()
        self.assertEqual(res, 0)

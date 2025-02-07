import unittest
import requests

BASE_URL = "http://localhost:5002"

class TesteLikes(unittest.TestCase):

    def test_get_likes_por_historia(self):
        response = requests.get(f"{BASE_URL}/likes_por_historia/1")
        assert response.status_code == 200
        data = response.json()
        assert "curtidas" in data

    def test_curtiu(self):
        response = requests.get(f"{BASE_URL}/curtiu/teste@example.com/1")
        assert response.status_code == 200
        data = response.json()
        assert "curtiu" in data

    def test_curtir(self):
        response = requests.post(f"{BASE_URL}/curtir/teste@example.com/1")
        assert response.status_code == 200
        data = response.json()
        assert data.get("situacao") == "ok"

    def test_descurtir(self):
        response = requests.post(f"{BASE_URL}/descurtir/teste@example.com/1")
        assert response.status_code == 200
        data = response.json()
        assert data.get("situacao") == "ok"
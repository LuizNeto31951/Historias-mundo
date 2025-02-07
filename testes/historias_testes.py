import unittest
import requests

BASE_URL = "http://localhost:5001"

class TesteHistorias(unittest.TestCase):

    def test_get_info(self):
        response = requests.get(f"{BASE_URL}/")
        assert response.status_code == 200
        data = response.json()
        assert "descricao" in data
        assert "versao" in data

    def test_get_historias(self):
        response = requests.get(f"{BASE_URL}/historias/0/5")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

    def test_find_historias(self):
        response = requests.get(f"{BASE_URL}/historias/0/5/Boto")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

    def test_find_historia(self):
        response = requests.get(f"{BASE_URL}/historia/1")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, dict)
        if data:
            assert "historia_id" in data
            assert "titulo_historia" in data

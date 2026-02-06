from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_root_health():
    response = client.get("/")
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "healthy"
    assert payload["version"] == "1.0.0"


def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "healthy"
    assert payload["service"] == "fitola-backend"

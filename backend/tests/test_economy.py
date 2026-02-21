from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_get_economy_profile():
    response = client.get('/api/v1/economy/profile/user-123')
    assert response.status_code == 200

    payload = response.json()
    assert payload['user_id'] == 'user-123'
    assert payload['model']['f2p']['enabled'] is True
    assert payload['model']['p2e']['enabled'] is True


def test_complete_economy_session_awards_rewards():
    response = client.post(
        '/api/v1/economy/session-complete',
        json={
            'user_id': 'user-123',
            'workout_minutes': 45,
            'intensity': 'intense',
            'shared_progress': True,
        },
    )
    assert response.status_code == 200

    payload = response.json()
    assert payload['f2p_rewards']['earned_fitcoins'] > 0
    assert payload['p2e_projection']['status'] == 'pending_verification'


def test_claim_p2e_rewards_threshold_enforced():
    below_threshold = client.post(
        '/api/v1/economy/claim',
        json={'user_id': 'user-123', 'amount_fitcoins': 300},
    )
    assert below_threshold.status_code == 400

    valid_claim = client.post(
        '/api/v1/economy/claim',
        json={'user_id': 'user-123', 'amount_fitcoins': 700},
    )
    assert valid_claim.status_code == 200
    assert valid_claim.json()['status'] == 'queued'

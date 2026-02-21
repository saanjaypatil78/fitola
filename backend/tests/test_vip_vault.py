from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_vip_window_returns_surrounding_levels():
    response = client.get('/api/v1/vip/level-window/10')
    assert response.status_code == 200
    payload = response.json()
    levels = payload['window']
    assert levels[0]['level'] == 5
    assert levels[-1]['level'] == 15


def test_vip_upgrade_quote_uses_growth_model():
    response = client.post(
        '/api/v1/vip/upgrade-quote',
        json={'current_level': 1, 'target_level': 3},
    )
    assert response.status_code == 200
    payload = response.json()
    assert payload['pricing_model'] == 'geometric_1.5x'
    assert payload['total_upgrade_cost'] > payload['next_level_cost']


def test_trophy_unbox_is_hash_based_and_saved_to_vault():
    unbox = client.post(
        '/api/v1/vault/trophy/unbox',
        json={
            'user_id': 'u-1',
            'vip_level': 99,
            'box_type': 'legendary',
            'client_seed': 'seed-abc',
            'nonce': 7,
        },
    )
    assert unbox.status_code == 200
    result = unbox.json()
    assert result['provably_fair']['hash']
    assert result['randomized_reward']['rarity'] in {'rare', 'epic', 'legendary', 'mythic'}

    vault = client.get('/api/v1/vault/u-1')
    assert vault.status_code == 200
    assert len(vault.json()['entries']) >= 1

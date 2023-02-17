import requests

def _get_data(url):
    response = requests.get(url, headers=None)
    return response.json()

def get_player(allycode):
    url = f'http://api.swgoh.gg/player/{allycode}/'
    data = _get_data(url)

    if 'detail' not in data.keys():
        data['result'] = True
    else:
        data['result'] = False

    return data
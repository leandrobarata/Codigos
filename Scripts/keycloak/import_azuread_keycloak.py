import csv
import requests

# Configurações do Keycloak
KEYCLOAK_URL = 'https://ssso.com.br/auth'
REALM = 'glpi'
CLIENT_ID = 'admin-cli'  # Tente com admin-cli para testes
USERNAME = 'admin'
PASSWORD = 'admin'

# Autenticação no Keycloak
def get_token():
    data = {
        'client_id': CLIENT_ID,
        'username': USERNAME,
        'password': PASSWORD,
        'grant_type': 'password'
    }
    response = requests.post(f'{KEYCLOAK_URL}/realms/master/protocol/openid-connect/token', data=data)
    
    if response.status_code != 200:
        print(f"Erro ao obter token: {response.text}")
        return None

    return response.json().get('access_token')

# Função para importar usuários
def import_users(csv_file):
    token = get_token()
    if not token:
        return

    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    }

    with open(csv_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            user_data = {
                'username': row['UserPrincipalName'],
                'email': row['Mail'],
                'enabled': True,
                'firstName': row['DisplayName'].split()[0],
                'lastName': ' '.join(row['DisplayName'].split()[1:])
            }

            response = requests.post(f'{KEYCLOAK_URL}/admin/realms/{REALM}/users', json=user_data, headers=headers)
            if response.status_code == 201:
                print(f"Usuário {user_data['username']} importado com sucesso!")
            else:
                print(f"Erro ao importar {user_data['username']}: {response.text}")

# Executar a importação
import_users('AzureADUsers.csv')

import requests
import json
import os


BASE_URL = "http://book.local"
REGISTER_URL = f"{BASE_URL}/auth/register"
LOGIN_URL = f"{BASE_URL}/auth/login"
CLIENTS_URL = f"{BASE_URL}/v1/clients"


auth_payload = {
	"email": "Naruto@gmail.com",
	"password": "222"
}


def get_access_token():
    print("--- Passo 1: Registrando/Logando Usuário ---")
    # Tenta registrar (se já existir, ignoramos o erro e tentamos login)
    requests.post(REGISTER_URL, json=auth_payload)
    
    # Login para obter o Token
    response = requests.post(LOGIN_URL, json=auth_payload)
    if response.status_code == 200:
        token = response.json().get("accessToken") # Verifique se o nome da chave no seu JSON é este
        print(" Token obtido com sucesso!")
        return token
    else:
        print(f" Erro no login: {response.text}")
        return None

def run_api_tests(token):
    if not os.path.exists("person.json"):
        print("Arquivo person.json não encontrado na pasta.")
        return
    with open("person.json", "r", encoding='utf-8') as f:
        test_data = json.load(f)
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {token}"
    }
    print(f"--- Passo 2: Enviando {len(test_data)} clientes para a API ---")
    for data in test_data:
        nome_completo = f"{data['name']} {data['lastName']}"
        response = requests.post(CLIENTS_URL, json=data, headers=headers)
        
        if response.status_code == 201:
            print(f" Sucesso: {nome_completo} cadastrado!")
        elif response.status_code == 409:
            print(f" Conflito: CPF {data['cpfNumber']} já existe ({nome_completo}).")
        else:
            print(f" Erro {response.status_code} em {nome_completo}: {response.text}")
if __name__ == "__main__":
    token = get_access_token()
    if token:
        run_api_tests(token)
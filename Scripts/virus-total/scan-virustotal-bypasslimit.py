import requests
import time

# Função para consultar uma URL no VirusTotal
def consultar_url_virustotal(api_key, url):
    base_url = 'https://www.virustotal.com/vtapi/v2/url/report'
    
    params = {
        'apikey': api_key,
        'resource': url,
        'scan': 1  # O parâmetro 'scan=1' envia a URL para uma nova varredura, se necessário
    }
    
    try:
        response = requests.get(base_url, params=params)
        # Verifica se a resposta é válida e contém JSON
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Erro: Código de status {response.status_code} para a URL {url}")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Erro de conexão ao consultar {url}: {e}")
        return None

# Função para processar o arquivo com URLs
def processar_arquivo_urls(api_key, arquivo_txt):
    with open(arquivo_txt, 'r') as file:
        urls = [linha.strip() for linha in file.readlines() if linha.strip()]

    resultados = {}
    for idx, url in enumerate(urls):
        try:
            print(f"Consultando URL {idx+1}/{len(urls)}: {url}")
            resultado = consultar_url_virustotal(api_key, url)

            if resultado:
                resultados[url] = resultado
                # Exibe informações básicas do resultado
                if resultado.get('response_code') == 1:
                    print(f"URL {url} encontrada. Total de detecções: {resultado['positives']}/{resultado['total']}")
                else:
                    print(f"URL {url} não encontrada no VirusTotal.")
            else:
                print(f"Erro ao consultar {url}: resposta inválida ou vazia.")

            # Espera 16 segundos para evitar o limite de requisições (máx. 4 requisições/minuto)
            time.sleep(16)

        except ValueError as e:
            print(f"Erro ao processar a resposta da URL {url}: {e}")
        except Exception as e:
            print(f"Erro inesperado ao consultar {url}: {e}")
    
    return resultados

# Configurações
API_KEY = ''  # Insira sua chave de API aqui
ARQUIVO_URLS = 'urls.txt'  # Arquivo contendo as URLs

# Executa a consulta
resultados = processar_arquivo_urls(API_KEY, ARQUIVO_URLS)

# Opcional: Salvar resultados em um arquivo
with open('resultados_virustotal.json', 'w') as output_file:
    import json
    json.dump(resultados, output_file, indent=4)

print("Consulta finalizada. Resultados salvos em 'resultados_virustotal.json'.")

# 📚 Book Platform — Kubernetes Stack

O **Book Platform** é uma plataforma de gerenciamento de livros baseada em **arquitetura de microsserviços**, desenvolvida com **Spring Boot** e executada em um ambiente **Kubernetes local (Kind)**.

O projeto tem como objetivo demonstrar boas práticas de **orquestração**, **mensageria assíncrona**, **observabilidade**, **infraestrutura como código** e **modelagem de domínio relacional**, sendo ideal como projeto de estudo avançado e portfólio.

---

## 🚀 Arquitetura e Tecnologias

A aplicação é composta por serviços desacoplados, projetados para garantir **escalabilidade**, **resiliência** e **manutenibilidade**.

### 🔧 Backend
- **Java 21**
- **Spring Boot**
- **Spring Data JPA / Hibernate**
- **Spring Security + JWT**
- **Swagger / OpenAPI 3**

### 📨 Mensageria
- **RabbitMQ**
  - Processamento assíncrono
  - Suporte a **Dead Letter Queue (DLQ)**
  - Serviço dedicado para consumo de mensagens falhadas

### 🗄️ Bancos de Dados
- **PostgreSQL**  
  Persistência relacional do domínio principal (**Cliente e seus Livros**).
- **MongoDB**  
    Armazenamento de logs de falhas (DLQ).
- **Redis**  
  Cache de alta performance.

### 📊 Observabilidade
- **Prometheus** → Coleta de métricas  
- **Grafana** → Visualização e dashboards

### ☸️ Infraestrutura
- **Kubernetes (Kind)**
- **Ingress-Nginx**
- **Helm v3** utilizando o padrão **Umbrella Chart**

---

## 🧱 Modelo de Domínio

O domínio central da aplicação é persistido no **PostgreSQL** e segue um modelo relacional simples e bem definido:

- **Cliente**
  - Entidade raiz do domínio
  - Possui **um ou mais livros**
- **Livro**
  - Associado a **um único cliente**

```text
Cliente (1) ────────── (M) Livro
```
O código-fonte da API e do modelo de domínio está disponível em:  
🔗 https://github.com/Sc4rlxrd/Book

---

## 🛠️ Pré-requisitos

Antes de iniciar, certifique-se de ter as seguintes ferramentas instaladas:

- **Docker**
- **Kind**
- **kubectl**
- **Helm v3**
- **Python 3.9+** (opcional, para carga em massa de dados)

---

## ⚡ Como Iniciar (Quick Start)

Toda a infraestrutura é provisionada automaticamente através de um **Shell Script**.

### 1️⃣ Clone o repositório

```bash
git clone https://github.com/Sc4rlxrd/Book-Platform-K8s-Helm
cd Book-Platform-K8s-Helm/book-api
```
### 2️⃣ Execute o script de instalação
```bash
chmod +x setup.sh
./setup.sh
```
> **Nota:**  
> Por padrão, o script utiliza as imagens públicas:
>
> - `sc4rlxrd/book:v3`
> - `sc4rlxrd/bookdlq:v1`
>
 Para utilizar suas próprias imagens:
 ```bash
 DOCKER_USER=seu_usuario ./setup.sh
 ```
## 🌐 Configuração de DNS Local

O **Ingress-Nginx** expõe os serviços utilizando domínios locais.  
Adicione as seguintes entradas ao arquivo de hosts do seu sistema:

📍 **Linux / Mac:** `/etc/hosts`  
📍 **Windows:** `C:\Windows\System32\drivers\etc\hosts`

```text
127.0.0.1 book.local
127.0.0.1 rabbit.local
127.0.0.1 grafana.local
```
## 📊 Endpoints Disponíveis

| Serviço | URL | Descrição |
|--------|-----|-----------|
| **API Principal** | http://book.local | Endpoints REST |
| **Swagger UI** | http://book.local/swagger-ui.html | Documentação da API |
| **RabbitMQ** | http://rabbit.local | Painel de Mensageria |
| **Grafana** | http://grafana.local | Dashboards de Métricas |

## 🐍 📦 Ambiente Python — Carga em Massa

O projeto inclui um **script em Python** para criação de **clientes e seus livros em lote**, facilitando:

- Testes de carga
- Popular o banco de dados
- Validação do modelo relacional

O script consome diretamente os **endpoints REST da API** e utiliza um **ambiente virtual Python (`venv`)** para isolamento de dependências.

### 🔹 Criando e ativando o ambiente virtual

```bash
# Criar ambiente virtual
python3 -m venv venv

# Ativar o ambiente (Linux / Mac)
source venv/bin/activate

# Ativar o ambiente (Windows)
venv\Scripts\activate
```
### 🔹 Instalando dependências

As dependências necessárias para execução do script estão definidas no arquivo `requirements.txt`.

```bash
pip install -r requirements.txt

```
## 🏗️ Estrutura da Infraestrutura

```text
.
├── setup.sh                # Script de provisionamento do cluster
├── cluster.yml             # Definição do cluster Kind
├── ingress-values.yaml     # Configuração do Ingress-Nginx
├── charts/                 # Helm Umbrella Chart
│   ├── book-api
│   ├── postgres
│   ├── mongo
│   ├── redis
│   ├── rabbitmq
│   └── monitoring
```
## 🔍 Comandos Úteis

```bash
# Listar todos os recursos no namespace default
kubectl get all -n default

# Acompanhar logs da API
kubectl logs -f -l app.kubernetes.io/name=app-book

# Atualizar ou reinstalar o Helm Chart
helm upgrade --install book-system .

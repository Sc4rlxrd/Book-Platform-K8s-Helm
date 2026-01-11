# 📚 Book Platform - Kubernetes Stack

Este projeto é uma plataforma completa de gerenciamento de livros baseada em microsserviços. A infraestrutura utiliza **Kubernetes (Kind)**, **Helm** e **Ingress-Nginx** para orquestrar serviços Spring Boot e instâncias de banco de dados robustas.

---

## 🚀 Arquitetura e Tecnologias

O sistema é dividido em componentes especializados para garantir alta disponibilidade e escalabilidade:

* **Backend:** Java 21 (Spring Boot)
* **Mensageria:** RabbitMQ (Processamento assíncrono com suporte a DLQ)
* **Bancos de Dados:**
    * **PostgreSQL:** Persistência de dados relacionais (Livros/Autores).
    * **MongoDB:** Auditoria e logs de falhas (DLQ).
    * **Redis:** Cache de alta performance.
* **Observabilidade:** Prometheus & Grafana para monitoramento de métricas.
* **Orquestração:** Kubernetes (Kind) com Ingress-Nginx.
* **Gerenciamento:** Helm v3 utilizando o padrão **Umbrella Chart**.



---

## 🛠️ Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas:
* **Docker**
* **Kind**
* **Kubectl**
* **Helm v3**

---

## ⚡ Como Iniciar (Quick Start)

Toda a infraestrutura foi automatizada via Shell Script para facilitar o ambiente de desenvolvimento.

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/Sc4rlxrd/Book-Platform-K8s-Helm](https://github.com/Sc4rlxrd/Book-Platform-K8s-Helm)
    cd Book-Platform-K8s-Helm/book-api
    ```

2.  **Execute o script de instalação:**
    ```bash
    chmod +x setup.sh
    ./setup.sh
    ```

> **Nota:** Por padrão, o script utiliza as imagens públicas `sc4rlxrd/book:v2` e `sc4rlxrd/bookdlq:v1`. Para usar seu próprio repositório, utilize: `DOCKER_USER=seu_usuario ./setup.sh`.

---

## 🌐 Configuração de DNS Local

O Ingress-Nginx mapeia os serviços para domínios locais. Para que funcionem no seu navegador, adicione as linhas abaixo ao seu arquivo de hosts:

**Caminho:** `/etc/hosts` (Linux/Mac) ou `C:\Windows\System32\drivers\etc\hosts` (Windows).

```text
127.0.0.1 book.local
127.0.0.1 rabbit.local
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
```
## 📊 Endpoints Disponíveis

| Serviço | URL | Acesso |
| :--- | :--- | :--- |
| **API Principal** | [http://book.local](http://book.local) | Endpoints REST |
| **RabbitMQ** | [http://rabbit.local](http://rabbit.local) | Painel (guest/guest) |
| **Grafana** | [http://grafana.local](http://grafana.local) | Dashboards de Métricas |
| **Prometheus** | [http://prometheus.local](http://prometheus.local) | Queries de Performance |

---

## 🏗️ Estrutura da Infraestrutura

* **`setup.sh`**: Script mestre que cria o cluster, configura o Ingress e faz o deploy do Helm.
* **`cluster.yml`**: Definição de nós do Kind (1 Control Plane + 2 Workers) com mapeamento de portas 80/443.
* **`ingress-values.yaml`**: Configuração otimizada para o Nginx Ingress Controller rodar em rede local.
* **`charts/`**: Contém as definições de cada componente da stack.

---

## 🔍 Comandos Úteis

```bash
# Verificar o status de todos os componentes
kubectl get all -n default

# Acompanhar logs em tempo real da API
kubectl logs -f -l app.kubernetes.io/name=app-book

# Forçar atualização do Helm Chart
helm upgrade --install book-system .
```
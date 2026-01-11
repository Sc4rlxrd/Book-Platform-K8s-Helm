#!/bin/bash

# --- CONFIGURAÇÕES ---
CLUSTER_NAME="bookplatform"
# Se a pessoa rodar: DOCKER_USER=joao ./setup.sh, usará 'joao'.
# Caso contrário, usa o seu usuário padrão abaixo.
DEFAULT_USER="sc4rlxrd"
DOCKER_USER="${DOCKER_USER:-$DEFAULT_USER}"
RELEASE_NAME="book-system"

echo "🔍 Verificando requisitos..."
for cmd in kind kubectl helm docker; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ Erro: O comando '$cmd' não foi encontrado. Instale-o antes de continuar."
        exit 1
    fi
done

echo "🧹 Removendo cluster antigo (se existir)..."
kind delete cluster --name $CLUSTER_NAME

echo "📦 Criando cluster Kind com Nodes..."
# O arquivo cluster.yml deve estar no mesmo diretório
kind create cluster --name $CLUSTER_NAME --config cluster.yml --wait 5m

echo "🌐 Instalando Ingress-Nginx via Helm..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  -n ingress-nginx \
  --create-namespace \
  -f ingress-values.yaml

echo "⏳ Aguardando Ingress ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo "🏗️  Preparando as dependências do Helm Chart..."
helm dependency build .

echo "☸️  Instalando Stack $RELEASE_NAME puxando de: $DOCKER_USER/..."
# Ajustado para os nomes exatos: $DOCKER_USER/book e $DOCKER_USER/bookdlq
helm upgrade --install $RELEASE_NAME . \
  --set app-book.image.repository=$DOCKER_USER/book \
  --set app-book.image.tag=v2 \
  --set app-dlq.image.repository=$DOCKER_USER/bookdlq \
  --set app-dlq.image.tag=v1 \
  --wait

echo "-------------------------------------------------------"
echo "✅ DEPLOY FINALIZADO COM SUCESSO!"
echo "-------------------------------------------------------"
kubectl get pods
echo "-------------------------------------------------------"
echo "🚨 ATENÇÃO: CONFIGURAÇÃO DE HOSTS NECESSÁRIA"
echo "Para acessar os serviços, adicione as linhas abaixo no seu /etc/hosts:"
echo ""
echo "127.0.0.1 book.local"
echo "127.0.0.1 rabbit.local"
echo "127.0.0.1 grafana.local"
echo "127.0.0.1 prometheus.local"
echo ""
echo "🔗 Endpoints disponíveis:"
echo "API:         http://book.local"
echo "Grafana:     http://grafana.local"
echo "Prometheus:  http://prometheus.local"
echo "-------------------------------------------------------"
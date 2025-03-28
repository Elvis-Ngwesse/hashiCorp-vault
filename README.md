# hashiCorp-vault

## Enable vault cli ##
brew tap hashicorp/tap
brew install hashicorp/tap/vault
vault --version

## Start vault docker-compose ##
docker-compose up -d
Open your browser and navigate to http://localhost:8200.
You can log in using the root token (root)

## Start vault helm ##
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm show values hashicorp/vault > vault.yaml
helm install vault hashicorp/vault -f vault.yaml


helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault hashicorp/vault --set "server.dev.enabled=true"

kubectl port-forward svc/vault 8200:8200
Open your browser and navigate to http://localhost:8200.
You can log in using the root token (root)

## Login using cli ##
export VAULT_ADDR=http://127.0.0.1:8200
vault login root
vault status

## Uninstall vault ##
helm uninstall vault

## Start minikube ##
minikube start --nodes 3 
minikube delete --all
minikube ssh
minikube ssh --node=minikube-m02
minikube ssh --node=minikube-m03
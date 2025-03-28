#!/bin/bash

# Get the token for the credentials-sa service account
token_reviewer_jwt=$(kubectl -n default create token credentials-sa)

# Get the Kubernetes host from the cluster-info command
kubernetes_host=$(kubectl cluster-info | grep Kubernetes)

# Get the Minikube client certificate
kubernetes_ca_cert=$(cat ~/.minikube/profiles/minikube/client.crt)

# Print the results to the console
echo "Token Reviewer JWT: $token_reviewer_jwt"
echo "Kubernetes Host: $kubernetes_host"
echo "Kubernetes CA Cert: $kubernetes_ca_cert"

# Configure Vault with the dynamic values and capture the output
echo "Configuring Vault for Kubernetes authentication..."
vault_output=$(vault write auth/kubernetes/config \
  token_reviewer_jwt="$token_reviewer_jwt" \
  kubernetes_host="$kubernetes_host" \
  kubernetes_ca_cert="$kubernetes_ca_cert")

# Print the output of the Vault command
echo "Vault Command Output: $vault_output"

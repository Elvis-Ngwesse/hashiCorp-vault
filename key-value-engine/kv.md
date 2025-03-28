kubectl get pods

The vault-0 pod runs a Vault server in development mode. The vault-agent-injector pod performs the injection based on the annotations present or patched on a deployment.

Running a Vault server in development is automatically initialized and unsealed.

## List secret paths available ##
vault secrets list

## Enable the Vault KV engine ##
vault secrets enable -path=credentials kv

## Create a secret at the path ##
vault kv put credentials/secret username="db-readonly-username" password="db-secret-password"

## Verify that the secret ##
vault kv get credentials/secret

## Create policy ##
vault policy write credentials-policy key-value-engine/app-secret.hcl
vault policy delete credentials-policy

## Create a Kubernetes Service Account ##
kubectl create sa credentials-sa

## Enable the Kubernetes authentication method ##
vault auth enable kubernetes

## Create role ##
vault write auth/kubernetes/role/credentials-role \
      bound_service_account_names=credentials-sa \
      bound_service_account_namespaces=default \
      policies=credentials-policy \
      ttl=24h

vault read auth/kubernetes/role/credentials-role

## Enable Vault Kubernetes authentication ##

chmod +x key-value-engine/vault_k8s_config.sh
./key-value-engine/vault_k8s_config.sh

## Deploy pod ##
kubectl apply -f key-value-engine/deployment.yaml
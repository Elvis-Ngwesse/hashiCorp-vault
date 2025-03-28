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

## Enable Vault Kubernetes authentication ##
- kubectl -n default create token credentials-sa
- kubectl cluster-info | grep Kubernetes
- cat ~/.minikube/profiles/minikube/client.crt

vault write auth/kubernetes/config \
  token_reviewer_jwt="eyJhbGciOiJSUzI1NiIsImtpZCI6Il9HaXBTOW1FWFNUR3ZWZHY4MHloVS04WlRhSTV3Q1hpTjNVSjNCNmxGWjAifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNzQzMTQ4MjkzLCJpYXQiOjE3NDMxNDQ2OTMsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwianRpIjoiNmM3YWMzYTktZDI4Yy00ZWNmLWE1YjgtMDU4MjFiOGIxZmQ0Iiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJkZWZhdWx0Iiwic2VydmljZWFjY291bnQiOnsibmFtZSI6ImNyZWRlbnRpYWxzLXNhIiwidWlkIjoiNzYyM2FkNTMtODJiYy00NjIwLTk4NDEtZTBiN2I5MDkxYmJkIn19LCJuYmYiOjE3NDMxNDQ2OTMsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmNyZWRlbnRpYWxzLXNhIn0.C1T3SWDAKCd0ndG8OSefTNrPd5bTD3BhsKAHu16p7CaabUmN6rEGxsCMqC2fp3ko3HPighjbMim6dHNlcuiuNWL-liwSD9PTjBg1N6_9HwoFG8ksXzHaTp1NycJsylgUWTbiMvRbFm6fyLTEv0rWLZRySNl69fxdZKe6wqwr6XnPaZPjdy9TqbIonBU5kuv6iRFTIqOvn7zl6I1ldMAu5zAuARuULWIaPOtUS0mgidO-UxX0HwpshS6486FpH8LP7Dcig68KQwReD9wG2rV4u-FYxnSh89kb0Ut_mFdmcZCt7y9a12PF5FCCdgqAlTSi4mfPej4ZP9_Mdj96ZmGzwA" \
  kubernetes_host=https://127.0.0.1:50852 \
  kubernetes_ca_cert="-----BEGIN CERTIFICATE-----
MIIDITCCAgmgAwIBAgIBAjANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwptaW5p
a3ViZUNBMB4XDTI1MDMyNzA2NDgwNFoXDTI4MDMyNzA2NDgwNFowMTEXMBUGA1UE
ChMOc3lzdGVtOm1hc3RlcnMxFjAUBgNVBAMTDW1pbmlrdWJlLXVzZXIwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCenUYaAJi5fRpmRiTjo7fjGD7zwj/9
hR0Z0KyeOSGVnhG7h1D3Es6M5UwkrS9iVMtRfCi5XOamCoCV9MoVYYdOLMbS7Lqu
Tz/dYC9tfHTsX6JwO9Z6UVgqGIIaSvPf6lnCTog8dm6FD5D4QW73KGispJLvyw5d
bO4rjCOpQ70KLaaN3Wx8e3YbBdzItteWuqYLlNcPOz7SaBIt2xDKFNnUU0S7g6aa
X758dIf/67Abv52Ug+WNzsz0SFiksnqHla28zhwgJOPWX7Ue5rZF89BpqWXCVjia
/NsZsnkCKgCLGM4QVxKCEz/gCn0ny/t/2di6EWAJy5bBQS7bzsDwhFzTAgMBAAGj
YDBeMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUH
AwIwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBT/7GLj5puwkpmjAWFpKZLCRloN
kjANBgkqhkiG9w0BAQsFAAOCAQEAGnRH0gS9kH/7BOuqyYJdrBBFlFmNFjA4+wFT
/QoSMSGwGsdEvV6/mqPOz9kFrarFc6GV1xW5gsEMQUBvge/9ZrjtVQyrns6gl33l
fqX34v01MrVMJd+QFv2ZGF1VbLdU6TxL5rWl6FULYK75UohjeGQnCEZ0Mu/olqHz
u+46CU/WqGQsvMShvjNrPdVs2N8n25OFYzAlqgbkSG0hIjyOQ2YexUEOsina1N9s
3NPklIY27R0G5Ci7wZO9fdTw/kwkp3Y91f+NnCA/o+ND3mimkgVqcMjVKLttT3Af
770TgfdXcZk4SvQ/DDAErQp5VXdYYg7IpDH5MMJ+fcAORoNwPg==
-----END CERTIFICATE-----"




kubectl apply -f key-value-engine/deployment.yaml
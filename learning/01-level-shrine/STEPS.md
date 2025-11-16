# Level 1 – Steps Executed

## 1. Installed gcloud and Terraform
Set up the CLI environment needed for GCP + Terraform.

## 2. Authenticated to GCP
gcloud init
gcloud auth login

## 3. Fetched kubeconfig
gcloud container clusters get-credentials <cluster-name> --region <region>

## 4. Created Terraform structure
- providers.tf
- main.tf
- variables.tf

## 5. Wrote provider blocks
Included:
- google provider
- kubernetes provider
- helm provider

## 6. Deployed first Helm chart
Used helm_release resource to deploy a sample NGINX chart.

## 7. Applied Terraform
terraform init  
terraform apply

## 8. Verified deployment
kubectl get pods -n default
kubectl get svc

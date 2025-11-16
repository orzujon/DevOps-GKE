# Level 2 – Steps Executed

## 1. Created local Helm chart
helm create hello

## 2. Cleaned default Helm chart files
Removed extra templates not needed.

## 3. Added custom values and templates
Updated deployment.yaml, service.yaml, and values.yaml.

## 4. Connected Terraform to local chart
Used:
chart = "${path.module}/charts/hello"

## 5. Added value override files
Created values/hello.yaml with custom replicas and service type.

## 6. Ran Terraform to deploy the chart
terraform init  
terraform apply

## 7. Verified deployment in GKE
kubectl get pods -n app-dev
kubectl get svc

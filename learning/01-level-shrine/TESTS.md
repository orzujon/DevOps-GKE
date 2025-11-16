# Level 1 – Tests Performed

## 1. Verified connection to the cluster
kubectl get nodes

## 2. Verified Helm release
kubectl get pods  
kubectl get deployments  
kubectl get svc

## 3. Checked service accessibility
Used kubectl port-forward or external service IP.

## 4. Confirmed Terraform state updated
Terraform showed resources in state file.

## 5. Confirmed terraform plan after deployment
terraform plan → No changes (idempotent)

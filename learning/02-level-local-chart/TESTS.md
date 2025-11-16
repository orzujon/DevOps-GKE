# Level 2 – Tests Performed

## 1. Verified chart installed correctly
kubectl get deployments  
kubectl get pods

## 2. Rendered chart locally for debugging
helm template ./charts/hello

## 3. Verified service exposure
kubectl get svc  
kubectl port-forward svc/hello 8080:80

## 4. Confirmed Terraform controls updates
Modified a value → terraform apply → rollout triggered.

## 5. Confirmed deletion behavior
terraform destroy → Helm release removed cleanly.

# Level 3 – Steps Executed

## 1. Created Terraform deployer GSA
gcloud iam service-accounts create terraform-deployer \
  --display-name="Terraform Deployer"

## 2. Granted Terraform GSA minimal IAM roles
gcloud projects add-iam-policy-binding $PROJECT \
  --member "serviceAccount:terraform-deployer@$PROJECT.iam.gserviceaccount.com" \
  --role "roles/container.clusterViewer"

gcloud projects add-iam-policy-binding $PROJECT \
  --member "serviceAccount:terraform-deployer@$PROJECT.iam.gserviceaccount.com" \
  --role "roles/container.developer"

## 3. Allowed my user to impersonate the Terraform GSA
gcloud iam service-accounts add-iam-policy-binding \
  terraform-deployer@$PROJECT.iam.gserviceaccount.com \
  --member="user:ahrorovor@gmail.com" \
  --role="roles/iam.serviceAccountTokenCreator"

## 4. Updated Terraform provider configuration
Added to providers.tf:
impersonate_service_account = "terraform-deployer@$PROJECT.iam.gserviceaccount.com"

## 5. Re-initialized Terraform
terraform init -upgrade

## 6. Applied infrastructure using impersonation
terraform apply -var="project_id=$PROJECT" \
                -var="region=$REGION" \
                -var="cluster_name=$CLUSTER"

## 7. Verified cluster connection and Helm deployment worked
kubectl get pods -n app-dev

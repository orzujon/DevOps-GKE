# Level 4 – Steps Executed

## 1. Created a Google Service Account for the app
gcloud iam service-accounts create hello-app \
  --display-name="Hello App GSA"

## 2. Granted minimal IAM role
gcloud projects add-iam-policy-binding $PROJECT \
  --member "serviceAccount:hello-app@$PROJECT.iam.gserviceaccount.com" \
  --role "roles/storage.objectViewer"

## 3. Created a Kubernetes Service Account (KSA)
kubectl create serviceaccount hello-app-ksa -n app-dev

## 4. Bound KSA ↔ GSA using Workload Identity
gcloud iam service-accounts add-iam-policy-binding \
  hello-app@$PROJECT.iam.gserviceaccount.com \
  --member "serviceAccount:$PROJECT.svc.id.goog[app-dev/hello-app-ksa]" \
  --role "roles/iam.workloadIdentityUser"

## 5. Annotated the KSA with the GSA
kubectl annotate serviceaccount hello-app-ksa \
  iam.gke.io/gcp-service-account=hello-app@$PROJECT.iam.gserviceaccount.com \
  -n app-dev

## 6. Updated pod/deployment to use the KSA
serviceAccountName: hello-app-ksa

## 7. Deployed a debug pod (cloud-sdk) for testing metadata server
Created wi-debug pod using:
image: gcr.io/google.com/cloudsdktool/google-cloud-cli:slim

## 8. Connected terraform local chart to use these identities
Modified charts and tested deployment through terraform apply.

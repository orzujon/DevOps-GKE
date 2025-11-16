# Level 4 – Tests Performed

## 1. Verified KSA annotation
kubectl describe sa hello-app-ksa -n app-dev

## 2. Verified GSA binding in IAM policy
Checked for workloadIdentityUser binding in:
gcloud iam service-accounts get-iam-policy hello-app@...

## 3. Executed into debug pod
kubectl -n app-dev exec -it wi-debug -- bash

## 4. Confirmed pod identity through metadata server
curl -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email

(Expected: hello-app@PROJECT.iam.gserviceaccount.com)

## 5. Confirmed token retrieval
curl -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token

## 6. Verified logs in Cloud Audit Logs
Searched for principalEmail matching hello-app@...

## 7. Confirmed pod could reach GCP API (e.g., GCS list)
gsutil ls gs://some-bucket/
(Allowed or denied based on IAM role)

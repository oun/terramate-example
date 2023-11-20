# Terramate Example

This repository contains example code that you can use with Terramate to keep Terraform code DRY.

## Getting Started

### Prerequisites

- [Terramate](https://terramate.io/docs/cli/)
- [tfenv](https://github.com/tfutils/tfenv)
- [Terraform](https://www.terraform.io/)
- [pre-commit](https://pre-commit.com/)
- [tflint](https://github.com/terraform-linters/tflint)

### Install

```
brew install terramate tfenv pre-commit tflint
```

Install Terraform
```
tfenv install
```

Install git hook scripts
```
pre-commit install
```

### Setup Github Actions Workflows

To authenticate and authorize Github Actions Workflows to Google Cloud,
you need to setup and configure Workload Identity Federation by creating Workload Identity Pool
and Workload Identity Provider.

```
PROJECT_ID=<your-project-id>
gcloud iam workload-identity-pools create "github-pool" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="Github pool"
```

```
gcloud iam workload-identity-pools providers create-oidc "github-oidc" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --display-name="Github provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

```
SA_NAME=github-actions
gcloud iam service-accounts create ${SA_NAME} \
  --project="${PROJECT_ID}" \
  --display-name="Github Actions"
```

```
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
REPO_OWNER=<your-github-repo-owner>
REPO_NAME=<your-github-repo-name>
gcloud iam service-accounts add-iam-policy-binding "${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/github-pool/attribute.repository/${REPO_OWNER}/${REPO_NAME}"
```

Add the following Github Actions secrets in your repository settings.

```
PROVIDER_NAME: github-oidc
SA_EMAIL: ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```

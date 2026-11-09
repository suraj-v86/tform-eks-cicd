# AWS EKS Provisioning and NGINX Deployment with Terraform and Jenkins

A hands-on DevOps practice project that brings together Terraform, AWS, Jenkins, and Kubernetes to provision AWS infrastructure and deploy an NGINX application to Amazon EKS.

> **Project scope:** This repository contains Terraform configurations, a Jenkins installation script, a Jenkins pipeline, and Kubernetes manifests. It documents the intended automation workflow. The repository alone does not include Jenkins build logs or other evidence proving a successful end-to-end pipeline run.

## Architecture overview

The project is organized into two Terraform configurations:

1. **Jenkins server infrastructure** (`Jenkins_server/`): provisions a VPC, a public EC2 instance, and installs Jenkins and supporting CLI tools through EC2 user data.
2. **EKS infrastructure and application deployment** (`CICD-EKS/`): provisions a VPC and an EKS cluster with a managed node group. A Jenkins pipeline runs Terraform commands and applies the NGINX Kubernetes manifests.

High-level workflow:

```text
GitHub repository
       |
       v
Jenkins on AWS EC2
       |
       +--> Terraform init / fmt / validate / plan
       |
       +--> Manual approval
       |
       +--> Terraform apply or destroy (selected by action parameter)
       |
       +--> Configure kubectl for EKS
       |
       +--> Apply Kubernetes Deployment and Service
                    |
                    v
              NGINX on EKS
             2 replicas / LoadBalancer
```

## Repository structure

```text
.
├── Jenkins_server/
│   ├── backend.tf
│   ├── data.tf
│   ├── jenkins_install.sh
│   ├── main.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
└── CICD-EKS/
    ├── backend.tf
    ├── data.tf
    ├── JenkinsFile
    ├── main.tf
    ├── provider.tf
    ├── terraform.tfvars
    ├── variables.tf
    └── configuration-files/
        ├── deployment.yml
        └── service.yml
```

## Technologies

- **AWS:** VPC, EC2, S3, EKS, managed node groups, IAM
- **Infrastructure as Code:** Terraform and AWS community modules
- **CI/CD:** Jenkins Declarative Pipeline
- **Containers and orchestration:** Kubernetes, NGINX
- **Automation and CLI:** Bash, AWS CLI, kubectl, Linux

## What the configuration does

### 1. Jenkins server

The Terraform configuration in `Jenkins_server/`:

- Uses the AWS VPC module to create a VPC and public subnet.
- Provisions an EC2 instance using an Ubuntu 22.04 AMI lookup.
- Runs `jenkins_install.sh` as EC2 user data.
- Installs Java 17, Jenkins, Terraform, kubectl, and AWS CLI.

### 2. EKS infrastructure

The configuration in `CICD-EKS/`:

- Uses the AWS VPC module to create public and private subnets.
- Configures a NAT gateway.
- Uses the AWS EKS Terraform module to create an EKS cluster.
- Configures an EKS managed node group with a desired size of two nodes (minimum one, maximum three).

### 3. Terraform remote state

Both Terraform configurations declare an S3 backend in `us-east-1`, using separate state keys:

- `Jenkins/terraform.tfstate`
- `EKS/terraform.tfstate`

The referenced S3 bucket, `cicd-jenkins-server`, must already exist before running `terraform init`. The backend configuration does not create that bucket.

### 4. Jenkins pipeline

The pipeline in `CICD-EKS/JenkinsFile` defines these stages:

1. Check out the `main` branch from GitHub.
2. Initialize Terraform.
3. Format Terraform configuration.
4. Validate Terraform configuration.
5. Generate a Terraform plan and request manual approval.
6. Run the Terraform action supplied through the Jenkins `action` variable.
7. Update the local kubeconfig for the EKS cluster and apply the Kubernetes manifests.

AWS credentials are referenced from Jenkins credentials with the IDs `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. Configure these credentials securely in Jenkins; do not store access keys in this repository.

### 5. NGINX deployment

The Kubernetes manifests in `CICD-EKS/configuration-files/`:

- Create an NGINX Deployment with two replicas using `nginx:1.14.2`.
- Create a Kubernetes Service of type `LoadBalancer` on port 80, targeting port 80 on the pods.

## Prerequisites and configuration notes

Before running the project, review and configure the following:

- An AWS account and an IAM identity with permissions appropriate for creating the VPC, EC2, EKS, IAM-related resources, and S3 state access.
- An existing S3 bucket named `cicd-jenkins-server` in `us-east-1`, or update both backend configurations to use your own bucket.
- An EC2 key pair matching the `key_value` in `Jenkins_server/terraform.tfvars`.
- Jenkins credentials with the IDs expected by the Jenkinsfile.
- Terraform, AWS CLI, kubectl, and the required Jenkins plugins installed and configured.
- A Jenkins job configured to use this repository and the `CICD-EKS/JenkinsFile` pipeline script.
- A Jenkins parameter named `action` with an allowed Terraform action such as `apply` or `destroy`. Review the pipeline carefully before enabling destroy.
- Valid AWS authentication and authorization for Jenkins to provision infrastructure and access the EKS cluster.

The values in `terraform.tfvars` are example configuration values and may need adjustment for your AWS account and environment.

## Running the Terraform configurations manually

From the repository root, initialize and review the Jenkins server configuration:

```bash
cd Jenkins_server
terraform init
terraform fmt
terraform validate
terraform plan
```

After reviewing the plan and configuring AWS access, apply only when you are ready to create the resources:

```bash
terraform apply
```

Then initialize and review the EKS configuration:

```bash
cd ../CICD-EKS
terraform init
terraform fmt
terraform validate
terraform plan
```

Apply only after checking the plan:

```bash
terraform apply
```

After the EKS cluster is available and your AWS identity has access to it:

```bash
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
kubectl apply -f configuration-files/deployment.yml
kubectl apply -f configuration-files/service.yml
kubectl get deployments
kubectl get pods
kubectl get services
```

The LoadBalancer external address is provisioned asynchronously by AWS. Check the Service status until an external address is assigned.

## Security and production-readiness considerations

This is a learning project, not a production-ready reference architecture. Before using it in a real environment:

- Restrict SSH and Jenkins inbound access to trusted IP ranges; the current EC2 security group allows access from `0.0.0.0/0`.
- Avoid exposing administrative services directly to the public internet. Consider private access, VPN, or a controlled reverse proxy.
- Prefer an EC2 instance profile / IAM role for AWS access from Jenkins instead of long-lived access keys where possible.
- Enable S3 bucket versioning and encryption, and configure appropriate access controls for Terraform state.
- Pin and test Terraform provider and module versions.
- Review security group rules, subnet tags, IAM permissions, and EKS endpoint access.
- Upgrade the NGINX image to a currently supported version and consider image scanning and resource requests/limits.
- Add pipeline validation, failure handling, and evidence from successful runs before describing the workflow as verified end-to-end automation.

## Learning outcomes

- Structuring AWS infrastructure with reusable Terraform modules.
- Separating Jenkins host provisioning from EKS cluster provisioning.
- Configuring Terraform remote state with an S3 backend.
- Building a Jenkins pipeline with Terraform validation, plan review, and approval.
- Deploying an application to EKS using Kubernetes Deployment and Service resources.

## Author

Suraj Vasudevan C K

GitHub: https://github.com/suraj-v86

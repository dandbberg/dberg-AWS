# AWS EKS & Bastion Deployment with Terraform (Modular)

##Overview
This Terraform configuration provisions a secure, production-ready AWS environment using reusable modules for VPC, EKS, Bastion, and Private EC2.
It also automates Kubernetes add-ons like NGINX Ingress Controller and a sample Podinfo application via Terraform and Helm.
Key components:

- VPC with public & private subnets across multiple AZs
- EKS cluster with managed node groups and add-ons
- Bastion Host for secure SSH access to private resources
- Private EC2 instance for testing & internal workloads
- Security Groups with least-privilege rules
- S3 Bucket for remote Terraform state
- CI/CD deployment via GitHub Actions (.github/workflows/)


## Project Structure
```plaintext
Infra/
├── envs/               # Environment-specific variables
│   ├── perf.auto.tfvars
│   ├── prod.auto.tfvars
│   └── qa.auto.tfvars
├── modules/            # Reusable Terraform modules
│   ├── bastion_ec2/
│   ├── eks/            # EKS + Ingress Controller + Podinfo
│   ├── private_ec2/
│   └── vpc/
├── main.tf             # Module composition
├── variables.tf        # Global input variables
├── outputs.tf          # Global outputs
├── provider.tf         # AWS & Kubernetes providers
└── .gitignore
```

# Components
### 1. VPC & Networking (module: vpc)
- Custom VPC with DNS support
- Public & private subnets across AZs
- Internet Gateway for public subnets
- NAT Gateway per AZ for private subnets
- Separate route tables for isolation

### 2. Security Groups
- Bastion SG – SSH from a configurable CIDR (e.g., office IP)
- Private EC2 SG – SSH only from Bastion SG
- EKS API SG – Access restricted to Bastion SG
### 3. Bastion Host (module: bastion_ec2)
- Public subnet EC2 instance
- Jump host for accessing private resources
- Uses preconfigured SSH key pair
### 4. Private EC2 Instance (module: private_ec2)
- Private subnet EC2 instance
- Accessible only via Bastion Host
- Proof-of-concept setup
### 5. EKS Cluster & Add-ons (module: eks)
- EKS cluster in private subnets
- Managed node group with configurable size and type
- IAM Roles for Service Accounts (IRSA)
- Helm-based installs:
- NGINX Ingress Controller for HTTP/HTTPS routing
- Podinfo sample app for testing deployment and ingress
- Tags for environment & Terraform tracking
### 6. Terraform State Storage
- S3 bucket with encryption and versioning for Terraform state

### 7. Deployment via GitHub Actions
CI/CD automation is configured under:
.github/workflows/
On push or pull request to the main branch, GitHub Actions will:
- Initialize Terraform with the correct .auto.tfvars file
- Run terraform plan for a dry run
- Run terraform apply (commented out for now)
### 8. Additional Applications (Deployments/)
- Contains one folder per application
- Each app has its own Helm chart
- Deployment automated via GitHub Actions on push/merge

### Usage
- Clone the repository
- Initialize Terraform with the environment vars:
- terraform init -var-file="envs/perf.auto.tfvars"
- Plan & Apply:
- terraform plan -var-file="envs/perf.auto.tfvars"
- terraform apply -var-file="envs/perf.auto.tfvars"

### Notes
Update CIDR blocks, SSH key names, and AWS region in your .tfvars before deployment.
Ingress hostname will be available after the ingress controller is provisioned.

SSH into Private EC2 via Bastion
ssh -i bastion-key.pem ec2-user@<bastion-ip>
ssh -i private-key.pem ec2-user@<private-ec2-ip>


## Architecture Diagram

![Architecture Diagram](./Architecture%20Design.png)


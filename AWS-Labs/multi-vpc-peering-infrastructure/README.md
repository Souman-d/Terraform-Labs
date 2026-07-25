# AWS Multi-VPC Peering Infrastructure

A production-grade Terraform project that provisions a cross-VPC network architecture on AWS, demonstrating intra-VPC and inter-VPC routing across public and private subnets.

---

## 📐 Architecture Diagram & Overview

```text
                  ┌─────────────────────────────────────────────────────────┐
                  │                    AWS REGION (us-east-1)               │
                  │                                                         │
                  │   ┌─────────────────────────────────────────────────┐   │
                  │   │ VPC A (10.1.0.0/16)                             │   │
                  │   │   ├── Public Subnet (10.1.1.0/24) + IGW         │   │
                  │   │   │   └── EC2 Instance (Public IP + Private IP) │   │
                  │   │   └── Private Subnet (10.1.2.0/24) + NAT GW     │   │
                  │   │       └── EC2 Instance (Private IP)             │   │
                  │   └────────────────────────┬────────────────────────┘   │
                  │                            │                            │
                  │                 VPC Peering Connection                  │
                  │                            │                            │
                  │   ┌────────────────────────┴────────────────────────┐   │
                  │   │ VPC B (10.2.0.0/16)                             │   │
                  │   │   ├── Public Subnet (10.2.1.0/24) + IGW         │   │
                  │   │   │   └── EC2 Instance (Public IP + Private IP) │   │
                  │   │   └── Private Subnet (10.2.2.0/24) + NAT GW     │   │
                  │   │       └── EC2 Instance (Private IP)             │   │
                  │   └─────────────────────────────────────────────────┘   │
                  └─────────────────────────────────────────────────────────┘
```

### Key Components
* **VPC A (`10.1.0.0/16`)**:
  * Public Subnet (`10.1.1.0/24`) with Internet Gateway (IGW) and public EC2 instance.
  * Private Subnet (`10.1.2.0/24`) with NAT Gateway and private EC2 instance.
* **VPC B (`10.2.0.0/16`)**:
  * Public Subnet (`10.2.1.0/24`) with Internet Gateway (IGW) and public EC2 instance.
  * Private Subnet (`10.2.2.0/24`) with NAT Gateway and private EC2 instance.
* **VPC Peering Connection**: Auto-accepted peering connection with route table entries allowing full ICMP/IP traffic flow across all four instances.

---

## 📁 Repository Structure

```text
aws-vpc-peering-lab/
├── main.tf          # Core network: VPCs, Subnets, IGWs, NAT Gateways & Route Tables
├── peering.tf       # VPC Peering connection and route configuration
├── compute.tf       # EC2 instances, Security Groups, and dynamic AMI data sources
├── variables.tf     # Input variables (CIDR blocks, Region, Instance types)
├── outputs.tf       # Infrastructure outputs (Public/Private IP addresses)
├── terraform.tfvars  # Environment variable assignments
└── README.md        # Project documentation
```

---

## 📋 Prerequisites

* **Terraform**: `>= 1.0.0` installed locally.
* **AWS CLI**: Installed and configured with valid credentials (`aws configure`).
* **IAM Permissions**: Sufficient privileges to manage VPCs, Subnets, Route Tables, Internet/NAT Gateways, EC2 instances, and Security Groups.
* **VS Code Extensions**: HashiCorp Terraform extension (recommended).

---

## 🚀 Quick Start Guide

### 1. Clone & Navigate
```bash
git clone https://github.com/your-username/aws-vpc-peering-lab.git
cd aws-vpc-peering-lab
```

### 2. Initialize Terraform
Initialize working directory and download necessary providers:
```bash
terraform init
```

### 3. Review Provisioning Plan
```bash
terraform plan
```

### 4. Deploy Infrastructure
```bash
terraform apply --auto-approve
```

---

## 🧪 Verification & Connectivity Testing

Upon execution completion, Terraform will output the IP addresses of all 4 EC2 instances:

```text
Outputs:

vpc_a_private_ec2_ip = "10.1.2.X"
vpc_a_public_ec2_ip  = "34.X.X.X"
vpc_b_private_ec2_ip = "10.2.2.Y"
vpc_b_public_ec2_ip  = "54.Y.Y.Y"
```

### Testing Inter-VPC Reachability (Ping Test)

1. SSH into the **VPC-A Public EC2** instance:
   ```bash
   ssh -i /path/to/key.pem ec2-user@<vpc_a_public_ec2_ip>
   ```

2. Test ping to all other nodes:
   ```bash
   # Ping VPC-A Private Instance
   ping 10.1.2.X

   # Ping VPC-B Public Instance (over Peering)
   ping 10.2.1.Y

   # Ping VPC-B Private Instance (over Peering)
   ping 10.2.2.Y
   ```

---

## ⚙️ Configuration Variables

| Variable | Description | Default |
| :--- | :--- | :--- |
| `aws_region` | AWS region to deploy infrastructure | `us-east-1` |
| `vpc_a_cidr` | Network range for VPC A | `10.1.0.0/16` |
| `vpc_b_cidr` | Network range for VPC B | `10.2.0.0/16` |
| `instance_type` | Compute size for EC2 test nodes | `t2.micro` |

---

## 🧹 Cleanup / Teardown

To avoid ongoing AWS charges (especially for NAT Gateways), destroy the environment when finished:

```bash
terraform destroy --auto-approve
```

---

## 🛡️ License

This project is licensed under the MIT License - see the LICENSE file for details.

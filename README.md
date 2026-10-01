# AWS DevOps & Database Reliability Engineering Project

## Project Overview

Designed and implemented a **production-oriented AWS infrastructure architecture using Terraform**, following Infrastructure as Code (IaC), modular design, environment separation, network security, and database reliability best practices.

The solution was designed to support a scalable application architecture with controlled network access between the application and database layers, while maintaining separate configurations for **Development and Production environments**.

## Architecture

**Internet → Application Load Balancer → ECS Fargate → Amazon RDS PostgreSQL**

### Infrastructure Components

* **Amazon VPC** with dedicated public and private subnets
* **Internet Gateway** for public connectivity
* **NAT Gateway** for controlled outbound access from private subnets
* **Application Load Balancer (ALB)** for application traffic distribution
* **Amazon ECS Fargate** for containerized application workloads
* **Amazon RDS PostgreSQL** deployed in private subnets
* **Security Groups** implementing controlled traffic flow between layers
* **IAM Execution Role** for ECS task execution
* **Encrypted RDS storage**
* Automated RDS backup configuration and retention policies

## Terraform Implementation

Implemented Terraform using a **reusable module-based architecture**:

```text
infra/
├── modules/
│   ├── network/
│   ├── ecs/
│   └── rds/
│
└── envs/
    ├── dev/
    └── prod/
```

### Terraform Modules

**Network Module**

* VPC
* Public/Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Subnet Associations
* Elastic IP

**ECS Module**

* Application Load Balancer
* Target Group
* Listener
* ECS Cluster
* ECS Task Definition
* ECS Fargate Service
* ALB and ECS Security Groups
* IAM Execution Role

**RDS Module**

* RDS Subnet Group
* PostgreSQL RDS Instance
* RDS Security Group
* Encryption
* Automated Backup Configuration
* Storage Auto Scaling
* Deletion Protection

## Environment Strategy

Created separate **Dev and Production environments** using the same reusable Terraform modules.

### Development

* Smaller ECS resources
* Single ECS task
* Smaller RDS instance
* 20 GB initial database storage
* 3-day backup retention
* Deletion protection disabled

### Production

* Larger ECS resources
* Multiple ECS tasks
* Larger RDS instance
* 50 GB initial storage with auto-scaling capability
* 7-day backup retention
* Deletion protection enabled
* Final snapshot enabled

This approach ensures that infrastructure can be **scaled and configured independently without duplicating Terraform module logic**.

## Security Design

Implemented a layered security model:

```text
Internet
   │
   ▼
ALB Security Group
   │
   ▼
ECS Security Group
   │
   │ TCP 5432
   ▼
RDS Security Group
```

Key security controls:

* ALB exposed for application traffic
* ECS tasks deployed in private subnets
* RDS deployed in private subnets
* RDS is not publicly accessible
* PostgreSQL access restricted to the ECS security group
* RDS storage encryption enabled
* IAM role used for ECS task execution

## Database Reliability

Configured PostgreSQL RDS with:

* Automated backups
* Environment-specific backup retention
* Storage auto scaling
* Encryption at rest
* Maintenance and backup windows
* Production deletion protection
* Final snapshot configuration

The design provides a foundation for database backup, recovery, query optimization, and operational reliability.

## Infrastructure Validation

Terraform configuration was validated using:

```bash
terraform fmt
terraform init
terraform validate
terraform plan
```

The infrastructure was designed so that changes can be reviewed through Terraform plans before being applied.

## Project Outcome

The project demonstrates the ability to design and structure a **scalable, secure, and maintainable AWS infrastructure using Terraform**, with clear separation between application, networking, and database layers.

It also demonstrates practical understanding of **DevOps automation, cloud infrastructure, container orchestration, AWS networking, Infrastructure as Code, and database reliability engineering**.


![alt text](<Screenshot 2026-10-01 221355.png>) ![alt text](<Screenshot 2026-10-01 221648.png>) ![alt text](<Screenshot 2026-10-01 220132.png>) ![alt text](<Screenshot 2026-10-01 220141.png>) ![alt text](<Screenshot 2026-10-01 220214.png>) ![alt text](<Screenshot 2026-10-01 220934.png>) ![alt text](<Screenshot 2026-10-01 220947.png>) ![alt text](<Screenshot 2026-10-01 221156.png>)
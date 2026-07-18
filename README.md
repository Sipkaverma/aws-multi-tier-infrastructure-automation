# Automated Multi-Tier Secure Infrastructure Pipeline (AWS + Terraform + Ansible)

An end-to-end Infrastructure-as-Code (IaC) and Configuration Management pipeline that automates the deployment of a highly secure, multi-tier cloud application environment on AWS. 

## 🏗️ Architecture Blueprint
The platform eliminates manual dashboard configuration and implements a zero-trust network boundary:
- **Networking:** Dedicated AWS VPC consisting of isolated Public and Private Subnets spanned across Availability Zones, fully integrated with Internet Gateways and NAT Gateways.
- **Compute Layer:** High-performance, Free-Tier eligible `t3.micro` EC2 instances provisioned dynamically.
- **Security Topology:** Strict network isolation using tailored AWS Security Groups. The core App Server resides in the private subnet and is **completely inaccessible** from the public internet. Access is strictly mediated via a secure Public Bastion Host proxy layer.
- **Configuration Engine:** Ansible Core acting as a detached deployment operator, executing remote runtime tasks over automated SSH proxy tunnels without leaking keys onto public-facing compute instances.

---

## 🛠️ Tech Stack & Tooling
- **Cloud Provider:** Amazon Web Services (AWS)
- **Infrastructure as Code (IaC):** Terraform (v1.15+)
- **Configuration Management:** Ansible Core
- **Deployment Platform:** AWS CloudShell / Linux Environment

---

## 🚀 Deployment Workflow

### 1. Infrastructure Provisioning (Terraform)
Initialize the state engine and deploy the hardware fabric:

- terraform init
- terraform validate
- terraform apply --auto-approve

### 2. Configuration & Application Injection (Ansible)

Generate the dynamic mapping (hosts.ini) leveraging secure proxy commands, and deploy the application environment:
# Verify secure connectivity framework across the proxy boundary
- ANSIBLE_HOST_KEY_CHECKING=False ansible all -i hosts.ini -m ping

# Execute the deployment directive
- ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini deploy-app.yml

# 🔧 Engineering Insights & Live Troubleshooting
During the lifecycle testing phase, several cloud orchestration challenges were successfully resolved:

1. Dynamic Ephemeral Path Alignment: Managed custom HashiCorp repository injections inside temporary AWS CloudShell container runtimes to preserve package integrity between session timeouts.

2. Modern Compute Optimization: Identified and bypassed hardware tier compatibility restrictions related to older legacy instances (t2.micro) by dynamically modifying the hardware definition layers to leverage optimized t3.micro architectures within the live environment.

3. Detached Proxy Management: Orchestrated an advanced Ansible ProxyCommand configuration pattern, achieving end-to-end runtime application deployment on a completely private subnet target without compromising root SSH credentials or copying private keys to edge hosts.

# 🧹 Cost-Control & De-provisioning
To enforce corporate resource management and strict cloud cost governance, the entire infrastructure stack is systematically decommissioned using a single declarative lifecycle command:
- terraform destroy --auto-approve

# Pipeline Execution & Architecture Verification Guide

This document outlines the operational execution commands utilized to deploy and validate the secure cloud infrastructure.

## Phase 1: Key Generation & Environment Setup
Generate the explicit RSA keypair inside the project directory:

- ssh-keygen -t rsa -b 2048 -f ./prod-ssh-key -N ""

## Phase 2: Terraform Orchestration
- terraform init
- terraform validate
- terraform apply --auto-approve
![terraform -approve](<WhatsApp Image 2026-07-18 at 12.41.30 PM.jpeg>)

## Phase 3: Ansible Infrastructure Targeting
Generate the dynamic inventory specification required to establish proxy SSH tunneling: hosts.ini
Execute the configuration engine and deploy the playbook layers over the SSH tunnel:
- ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini deploy-app.yml
![output](<WhatsApp Image 2026-07-18 at 12.44.28 PM.jpeg>)

## Phase 5: Resource Teardown (Cost Optimization)
Wipe the dynamic execution state clean to guarantee absolute cost-control safety:
- terraform destroy --auto-approve
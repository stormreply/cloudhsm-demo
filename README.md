# CloudHSM Demo

A complete demonstration of deploying and configuring AWS CloudHSM cluster with KMS Custom Key Store integration using Terraform.

## Overview

This project automates the setup of an AWS CloudHSM cluster with the following features:
- FIPS-compliant CloudHSM cluster with multiple HSM instances
- Custom certificate authority for HSM authentication
- EC2 controller instance for cluster management
- KMS Custom Key Store integration
- Automated initialization and activation scripts

## Architecture

- **CloudHSM Cluster**: Multi-AZ deployment with `hsm2m.medium` instances
- **Controller Instance**: EC2 instance with CloudHSM CLI for cluster management
- **Custom Key Store**: KMS integration for CloudHSM-backed encryption keys
- **Networking**: Uses default VPC subnets across availability zones

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.11.4
- S3 backend configured for Terraform state
- CloudHSM service permissions in target AWS account

## Required AWS Permissions

Your AWS credentials need permissions for:
- CloudHSM cluster creation and management
- EC2 instance creation and management
- IAM role and policy creation
- KMS Custom Key Store operations
- VPC and networking resources

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

## Deployment

1. **Configure Terraform backend**:
   ```bash
   # Update terraform.tf with your S3 backend configuration
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan deployment**:
   ```bash
   terraform plan
   ```

4. **Deploy infrastructure**:
   ```bash
   terraform apply
   ```

5. **Monitor cluster initialization**:
   The deployment includes automated scripts that will:
   - Generate required certificates
   - Initialize the CloudHSM cluster
   - Install CloudHSM CLI on controller instance
   - Activate the cluster
   - Create KMS user
   - Set up Custom Key Store connection

## Scripts

The `scripts/` directory contains automated setup scripts:

- `01-create-certificates.sh` - Generates customer CA and HSM certificates
- `02-initialize-cluster.sh` - Initializes CloudHSM cluster
- `03-install-cloudhsm-cli.sh` - Installs CloudHSM CLI tools
- `04-activate-cluster.sh` - Activates the cluster
- `05-create-kmsuser.sh` - Creates KMS integration user
- `06-poll-cluster-state.sh` - Monitors cluster state
- `07-copy-customer-ca-crt.sh` - Copies CA certificate
- `08-poll-connection-state.sh` - Monitors KMS connection

## Key Components

### CloudHSM Cluster
- Type: `hsm2m.medium` (FIPS-compliant)
- Mode: FIPS
- Multi-AZ deployment for high availability

### Controller Instance
- Manages cluster operations
- Pre-configured with CloudHSM CLI
- Automated setup via user data scripts

### Custom Key Store
- Integrates CloudHSM with AWS KMS
- Enables CloudHSM-backed encryption keys
- Automated connection setup

## Outputs

After successful deployment, Terraform will output:
- CloudHSM cluster ID
- Controller instance details
- Custom Key Store information
- Connection status

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

**Note**: Ensure all KMS keys using the Custom Key Store are deleted before destroying the infrastructure.

## Security Considerations

- All HSM operations use FIPS-compliant hardware
- Custom CA certificates provide secure cluster authentication
- Controller instance uses IAM roles for secure AWS API access
- Network security groups restrict access to HSM instances

## Cost Optimization

- CloudHSM instances incur hourly charges when active
- Consider cluster state management to minimize costs during development
- Monitor usage through AWS Cost Explorer

## Troubleshooting

### Common Issues

1. **Cluster initialization timeout**: Check certificate validity and format
2. **KMS connection failures**: Verify HSM user permissions and cluster state
3. **Controller access**: Ensure security groups allow necessary traffic

### Logs

Check CloudTrail and CloudWatch logs for detailed error information during deployment.

## Support

This is a demonstration project. For production deployments, consider:
- Enhanced monitoring and alerting
- Backup and disaster recovery procedures
- Multi-region deployment strategies
- Advanced security configurations


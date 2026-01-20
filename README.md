# CloudHSM Demo

An AWS CloudHSM cluster demo with KMS Custom Key Store integration

## Installation

This repository is a member of the **Storm Library for Terraform** and
can be built using GitHub Actions. It you want to do so, you need to

- [Install the Storm Library for Terraform](https://github.com/stormreply/storm-library-for-terraform/blob/main/docs/INSTALL-LIBRARY.md)
- [Deploy this member repository](https://github.com/stormreply/storm-library-for-terraform/blob/main/docs/DEPLOY-MEMBER.md)

Deployment of this member will take 40-50 minutes on GitHub resources.

Below is a list of resources taking particularly long to deploy:

<table>
  <tr><td>aws_cloudhsm_v2_hsm</td><td>up to 10 minutes</td></tr>
  <tr><td>wait_cluster_active</td><td>up to 15 minutes</td></tr>
  <tr><td>aws_kms_custom_key_store</td><td>up to 30 minutes</td></tr>
</table>

## Architecture

[Image]

## Explore this demo

Follow these steps in order to explore this demo:

#### Storm Library for Terraform

This repository is a member of the SLT | Storm Library for Terraform,
a collection of Terraform modules for Amazon Web Services. The focus
of these modules, maintained in separate GitHub™ repositories, is on
building examples, demos and showcases on AWS. The audience of the
library is learners and presenters alike - people that want to know
or show how a certain service, pattern or solution looks like, or "feels".

[Learn more](https://github.com/stormreply/storm-library-for-terraform)

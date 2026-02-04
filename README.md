# CloudHSM Demo

An AWS CloudHSM cluster demo with KMS Custom Key Store integration

#### Storm Library for Terraform

This repository is a member of the SLT | Storm Library for Terraform,
a collection of Terraform modules for Amazon Web Services. The focus
of these modules, maintained in separate GitHub™ repositories, is on
building examples, demos and showcases on AWS. The audience of the
library is learners and presenters alike - people that want to know
or show how a certain service, pattern or solution looks like, or "feels".

[Learn more](https://github.com/stormreply/storm-library-for-terraform)

## Installation

This demo can be built using GitHub Actions. In order to do so

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

1. Find and select the _cloudhsm-demo controller_ in the _EC2 > Instances_
   view in the AWS Console
1. Click _Connect_ to login into the instance
1. In the terminal that will open inside the browser, enter

    ```
    sudo -i
    /opt/cloudhsm/bin/cloudhsm-cli interactive
    ```

   in order to login as root in your terminal and start the cloudhsm cli
   in interactive mode
1. In interactive mode, use ```help``` to get an overview over available
   cloudhsm cli commands
1. Try out ```cluster hsm-info``` to obtain details about the HSMs in your
   cluster
1. Login as cloudhsm admin typing

   ```login --username admin --role admin```

   You will be prompted to enter a password. Check the output of the _Apply_
   workflow, searching for the _admin\_password_ output value. Copy that value
   (be careful to not copy the surrounding double quotes), paste it into the
   ```Enter password:``` prompt and press ```Enter ⮐```.

1. Type ```user list``` to see the users on your cluster. Notice the _kmsuser_.
1. Try to login as the _kmsuser_ typing

   ```login --username kmsuser --role crypto-user```

   Again, you will be prompted to enter a password. Check the output of the
   _Apply_ workflow, search for the _kmsuser\_password_, copy-paste and enter
   it. Login will fail. This is not because the password was wrong, but because
   the _kmsuser_ has been configured in our code as the _crypto user_ for our
   CloudHSM cluster, and the CloudHSM service will rotate the password as soon
   as it has connected to KMS as a custom key store.
   Check

   https://docs.aws.amazon.com/kms/latest/developerguide/keystore-cloudhsm.html

   for more details.

1. Use the ```key list``` command to list all currently defined keys in your
   CloudHSM. Initially, the list will show zero keys.
1. Feel free to add customer-managed kms keys to your CloudHSM cluster, but

   **Understand that you will be generating costs by doing so.**

   Even if you delete a KMS key immediately after creation, it will still be
   alive for the time of a
   [waiting period](https://docs.aws.amazon.com/kms/latest/developerguide/deleting-keys.html#deleting-keys-how-it-works)
   with a default of 30 days and a minimum of 7 days that you need to set
   upon deletion. During this period, your key will create costs. However,
   as you will probably almost never use your key apart from in this demo,
   it is maybe worth it. Please get yourself informed about
   [standard KMS key charges](https://aws.amazon.com/kms/pricing/?nc1=h_ls).
   Also note that if you have configured customer-managed KMS keys in your
   CloudHSM,

   **The _Destroy_ workflow won't be able to destroy your custom key store.**

   The keystore itself won't create any additional costs, but keep in mind
   to delete it manually after the waiting period. All other resources should
   always be destroyed by means of the _Destroy_ workflow, especially the
   CloudHSM instances, which are the really expensive parts of this demo.
   Please make sure that they have been properly destroyed.

Reference for CloudHSM CLI commands:

- https://docs.aws.amazon.com/cloudhsm/latest/userguide/cloudhsm_cli-getting-started-use.html
- https://docs.aws.amazon.com/cloudhsm/latest/userguide/cloudhsm_cli-reference.html

## Terraform Docs

<details>
<summary>Click to show</summary>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.8.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.5.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.4 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.7.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.8.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.5.3 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.4 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.7.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_controller"></a> [controller](#module\_controller) | git::https://github.com/stormreply/ssm-managed-instance.git | n/a |

## Resources

| Name | Type |
|------|------|
| [aws\_cloudhsm\_v2\_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_cluster) | resource |
| [aws\_cloudhsm\_v2\_hsm.hsm\_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_hsm) | resource |
| [aws\_cloudhsm\_v2\_hsm.hsm\_two](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_hsm) | resource |
| [aws\_default\_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet) | resource |
| [aws\_iam\_policy.controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws\_key\_pair.controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws\_kms\_custom\_key\_store.cloudhsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_custom_key_store) | resource |
| [aws\_secretsmanager\_secret.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws\_secretsmanager\_secret\_version.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws\_security\_group.controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local\_file.private\_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null\_resource.copy\_customer\_ca\_crt](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null\_resource.delete\_cloudhsm\_log\_group](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null\_resource.private\_key\_chmod](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null\_resource.wait\_cluster\_active](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random\_string.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random\_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls\_private\_key.controller](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws\_availability\_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws\_caller\_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws\_iam\_policy\_document.controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws\_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [cloudinit\_config.controller](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [local\_file.customer\_ca\_crt](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input__metadata"></a> [\_metadata](#input\_\_metadata) | n/a | <pre>object({<br/>    actor      = string # Github actor (deployer) of the deployment<br/>    catalog_id = string # SLT catalog id of this module<br/>    deployment = string # slt-<catalod_id>-<repo>-<actor><br/>    ref        = string # Git reference of the deployment<br/>    ref_name   = string # Git ref_name (branch) of the deployment<br/>    repo       = string # GitHub short repository name (without owner) of the deployment<br/>    repository = string # GitHub full repository name (including owner) of the deployment<br/>    sha        = string # Git (full-length, 40 char) commit SHA of the deployment<br/>    short_name = string # slt-<catalog_id>-<actor><br/>    time       = string # Timestamp of the deployment<br/>  })</pre> | <pre>{<br/>  "actor": "",<br/>  "catalog_id": "",<br/>  "deployment": "",<br/>  "ref": "",<br/>  "ref_name": "",<br/>  "repo": "",<br/>  "repository": "",<br/>  "sha": "",<br/>  "short_name": "",<br/>  "time": ""<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output__default_tags"></a> [\_default\_tags](#output\_\_default\_tags) | n/a |
| <a name="output__metadata"></a> [\_metadata](#output\_\_metadata) | n/a |
| <a name="output__name_tag"></a> [\_name\_tag](#output\_\_name\_tag) | n/a |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | n/a |
| <a name="output_kmsuser_password"></a> [kmsuser\_password](#output\_kmsuser\_password) | n/a |
<!-- END_TF_DOCS -->

</details>

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

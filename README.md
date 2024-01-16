# Terraform Cloud Azure MarkLogic IaC - tf-az-ml

This is the terraform project to kickstart an Azure MarkLogic ondemand.
The goal is to automate everything to provision a MarkLogic server with the offical MarkLogic published images

Key Benefits

- Customizable hardware spec.
- VPN access is always from Australia Eastcoast even if the remote desktop access is from NZ or China.
- Quiet and free from physical office laptop.
- Freedom to install 3rd parties software.

## Overview

### Objectives

1. Cloud based rapid Win desktop infra
    - Start up - terraform apply
    - Shut down - backup vm image to snapshop and terrform destroy
2. Support multiple workspaces (different prebuild desktop for different purpose)
3. Support further customization of the ML vm configuration parameter with TF variables
4. Support auto osDisk snapshot before terraform destroy
5. Automate everthing

### Dependency

It is based on the Azure ARM template mantained in [ml-azure-iac](https://github.com/xcelerent/ml-azure-iac)

> **Important Notes**
> - Remove all *comments* from the ARM template. (Terraform won't parse the comments elements in json file)
> - Need to convert the ARM parameter json file into Terraform json format. It won't be able to load.

### Limitation

1. It is to deploy to **Australia East** only
2. it is for perosnal use only.

## Configration Varaibles

Project variables are organized based on how liklyhood to make the change.

### Frequently Change

||Variable Name|Description|Config Scope|Notes|
|--|--|--|--|--|
|1|vm_size|Matchine Spec|Workspace GUI|CPU and RAM|
|2|storage_account_type|Disk Type|Workspace GUI|How fast the disk is|
|||||Standard_LRS - *Standard_HDD*|
|||||StandardSSD_LRS - *Standard SSD*|
|||||Premium_LRS *- Premium SSD*|
|3|disk_size_gb|Disk Size|Workspace GUI|Disk size|
|||||It is related with the vm osDisk snapshot size and publisher base image size|
|||||It could be resized with windows disk utility|

### Change By Workspace

||Variable Name|Description|Config Scope|Notes|
|--|--|--|--|--|
|1|domain_name|Public DNS name|Workspace Code|xxx.australiaeast.cloudapp.azure.com|
|||||(a) cloudpc|
|||||(b) sa-sim-migration|
|2|environment.name|Prefix|Workspace Code|Short descrioption of the environment|
|||||(a) dev|
|||||(b) sa-sim-migration|
|3|environment.network_prefix|Unique network address prefix|Workspace Code|(a) 10.0|
|||||(b) 10.1|
|4|cloudpc-vm-snapshot-name|back up vm snapshot|Workspace Code|cloudpc-win11-dev-vm-snapshot-latest|
|||||(It is related with the powershell script to take vm snapshot)|

### Seldom Change

||Variable Name|Description|Config Scope|Notes|
|--|--|--|--|--|
|1|admin_username|Win admin login name|Modules Code|lingtao|
|2|admin_password|admin password|Modules Code|1q2w3e4r5t^Y|
|3|source_image_reference.sku|Official microsoft win base OS image|Modules Code|It is used when to create a brand new VM|

## Operational Manual

### How to update restore osDisk image

1. Login to az portal *cloudpc-vm-snapshot-backup-rg*

    ![](https://i.imgur.com/rVTTFq4.png)

2. Copy uri from the browser

    ![](https://i.imgur.com/azqcYCm.png)

3. Extract snapshot setting

    ```txt
    <!-- Original -->
    https://portal.azure.com/#@standards.org.au/resource/subscriptions/e249c303-8e43-46b5-80f9-169f76396c9e/resourceGroups/cloudpc-vm-snapshot-backup-rg/providers/Microsoft.Compute/snapshots/cloudpc-win11-dev-vm-snapshot-latest/overview

    <!-- Sample -->
    /subscriptions/*************/resourceGroups/My-prod-rg/providers/Microsoft.Compute/snapshots/test-01-c-drive

    <!-- Final -->
    /subscriptions/e249c303-8e43-46b5-80f9-169f76396c9e/resourceGroups/cloudpc-vm-snapshot-backup-rg/providers/Microsoft.Compute/snapshots/cloudpc-win11-dev-vm-snapshot-latest
    ```

### How to enlarge osDisk size

The allocated disk size must be bigger than the image size.
That could be done with terrafrom *disk_size_gb* variable.
However the addtional disk size is not available until using the disk management util to extend the volumn. 

![](https://i.imgur.com/mQHbG34.png)

## Appendix

### VM Catalog

|Index|Host Name|Purpose|Creation Date|Workspace|IP prefix|Disk Size|os Disk Snapshot Name|
|--|--|--|--|--|--|--|--|
|1|dev-cloudpc|main development workstation|2024-01-08|dev|10.0|128|cloudpc-win11-dev-vm-snapshot-latest|
|2|sa-sim-migration|SA MarkLogic win for full data migration|2024-01-08|sa-sim-migration|10.1|1024|cloudpc-win11-ml-vm-snapshot-latest|

### Base OS Image
Defaul windows base image from MicrosoftWindowsDesktop (publisher)

[win11-23h2-pro](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-11-version-23h2)

Note:

- It should get updated once every year.
- The default image size is 128 gb.

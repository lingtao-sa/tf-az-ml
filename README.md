# Terraform Cloud Azure MarkLogic IaC - tf-az-ml

This is the terraform project to kickstart an Azure MarkLogic ondemand.
The goal is to automate everything to provision a MarkLogic server with the offical MarkLogic published images

## Overview

### Objectives

1. Customizable hardware spec.
2. Upgradable with the official MarkLogic Azure ARM templates

### Dependency

It is based on the Azure ARM template mantained in [ml-azure-iac](https://github.com/xcelerent/ml-azure-iac)

> **Important Notes**
>
> - Remove all *comments* from the ARM template. (Terraform won't parse the comments elements in json file)
> - Need to convert the ARM parameter json file into Terraform json format. It won't be able to load.

### Limitation

1. It is to deploy to **Australia East** only
2. it is pending to build the network module to join SA domain.

## Configration Varaibles

Project variables are organized based on how liklyhood to make the change.

### Frequently Change

||Variable Name|Description|Config Scope|Notes|
|--|--|--|--|--|
|1|vm_size|Matchine Spec|Workspace GUI|CPU and RAM|
|2|storage_account_type|Disk Type|Workspace GUI|How fast the disk is|
|||||StandardSSD_LRS - *Standard SSD*|
|||||Premium_LRS *- Premium SSD*|
|3|disk_size_gb|Disk Size|Workspace GUI|Disk size|
|||||It is related with the vm osDisk snapshot size and publisher base image size|
|||||It could be resized with windows disk utility|

### Change By Workspace

||Variable Name|Description|Config Scope|Notes|
|--|--|--|--|--|
|1|domain_name|Public DNS name|Workspace Code|xxx.australiaeast.cloudapp.azure.com|
|||||(a) ml-azure-centos-node1|
|2|environment.name|Prefix|Workspace Code|Short descrioption of the environment|
|||||(a) dev|
|3|environment.network_prefix|Unique network address prefix|Workspace Code|(a) 10.1|

## Operational Manual

### How to restore sim-content db from thebackup

1. putty telnet to ml-azure-centos-node1 and azcopy backup from blob to */home/lingtao/ml-backup*

    ```bash
    pwd

    mkdir ml-backup

    azcopy copy "https://lingtao.blob.core.windows.net/ml-backup-container/docker-ml/ml-backup/20240202-1855040962340/?sv=2023-01-03&st=2024-01-28T19%3A35%3A22Z&se=2024-12-31T07%3A35%3A00Z&sr=c&sp=racwdxlf&sig=RfLfCzLbF%2BoWCIn6w%2FtpIv%2BOldDz8q46p8j%2FG6EB2Co%3D" "/home/lingtao/ml-backup" --recursive
    ```

    ![putty tellnet](https://i.imgur.com/LfYSMwQ.png)

    ![azcopy download backup](https://i.imgur.com/x75W0fZ.png)

2. Deploy from *ml-sim-lab* project to az-ml

    ![](https://i.imgur.com/JBenDsd.png)

3. Restore DB from */home/lingtao/ml-backup/* folder

    ![DB Restore location](https://i.imgur.com/34ylyhh.png)

    ![DB Restore confirmation](https://i.imgur.com/S2XXzNb.png)

4. Verfiy DB Restore Status

    ![Verfify DB Docuemnt Size](https://i.imgur.com/TMBRh6W.png)

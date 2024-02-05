# Devlopment Single Node ML Centos - tf-az-ml

_Remote Desktop Connection Detail_

|Configuration|Value|
|---|---|
|HostName|ml-azure-centos-node1.australiaeast.cloudapp.azure.com|
|Putty (SSH)|MLAzure CentOS|
|login|su|
|password|Mikyl@2012|

## Varaibles

### 1 vm_size

![vm size summary](https://i.imgur.com/EQK5AF4.png)

> [virual machine size](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes)

General Purpose **[dv2-dsv2-series-memory](https://learn.microsoft.com/en-us/azure/virtual-machines/dv2-dsv2-series-memory)**

- Standard_DS11_v2
- Standard_DS12_v2
- Standard_DS13_v2
- Standard_DS14_v2

### 2 storage_account_type

> [sku type](https://learn.microsoft.com/en-us/rest/api/storagerp/srp_sku_types)

- StandardSSD_LRS
- Premium_LRS

### 3 disk_size_gb

- 512
- 1024
- 2048

> Core XML is only about 38G in size.

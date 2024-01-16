provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  skip_provider_registration = "true"

  # Connection to Azure
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}


resource "azurerm_resource_group" "ml" {
  name     = "${var.environment.name}-ml-rg"
  location = "Australia East"
}

resource "azurerm_resource_group_template_deployment" "ml" {
  name                = "${var.environment.name}-ml-deployment"
  resource_group_name = azurerm_resource_group.ml.name
  deployment_mode     = "Incremental"

  template_content = file("${path.module}/ARM_Template/single-node/template.json")
  # parameters = file("${path.module}/ARM_Template/single-node/parameters.json")
  # parameters_content = templatefile("${path.module}/ARM_Template/single-node/parameters.json", {
  #   environment_name = var.environment.name
  # })

  parameters_content = jsonencode({
    location = {
      value = "australiaeast"
    }
    networkInterfaceName = {
      value = "ml-azure-centos-n158"
    }
    networkSecurityGroupName = {
      value = "ml-azure-centos-node1-nsg"
    }
    networkSecurityGroupRules = {
      value = [
        {
          name = "Admin"
          properties = {
            priority                             = 1010
            protocol                             = "TCP"
            access                               = "Allow"
            direction                            = "Inbound"
            sourceApplicationSecurityGroups      = []
            destinationApplicationSecurityGroups = []
            sourceAddressPrefix                  = "*"
            sourcePortRange                      = "*"
            destinationAddressPrefix             = "*"
            destinationPortRange                 = "8001"
          }
        },
        {
          name = "Manage"
          properties = {
            priority                             = 1020
            protocol                             = "TCP"
            access                               = "Allow"
            direction                            = "Inbound"
            sourceApplicationSecurityGroups      = []
            destinationApplicationSecurityGroups = []
            sourceAddressPrefix                  = "*"
            sourcePortRange                      = "*"
            destinationAddressPrefix             = "*"
            destinationPortRange                 = "8002"
          }
        },
        {
          name = "QConsole"
          properties = {
            priority                             = 1030
            protocol                             = "TCP"
            access                               = "Allow"
            direction                            = "Inbound"
            sourceApplicationSecurityGroups      = []
            destinationApplicationSecurityGroups = []
            sourceAddressPrefix                  = "*"
            sourcePortRange                      = "*"
            destinationAddressPrefix             = "*"
            destinationPortRange                 = "8000"
          }
        },
        {
          name = "HealthCheck"
          properties = {
            priority                             = 1040
            protocol                             = "TCP"
            access                               = "Allow"
            direction                            = "Inbound"
            sourceApplicationSecurityGroups      = []
            destinationApplicationSecurityGroups = []
            sourceAddressPrefix                  = "*"
            sourcePortRange                      = "*"
            destinationAddressPrefix             = "*"
            destinationPortRange                 = "7997"
          }
        },
        {
          name = "default-allow-ssh"
          properties = {
            priority                             = 1050
            protocol                             = "TCP"
            access                               = "Allow"
            direction                            = "Inbound"
            sourceApplicationSecurityGroups      = []
            destinationApplicationSecurityGroups = []
            sourceAddressPrefix                  = "*"
            sourcePortRange                      = "*"
            destinationAddressPrefix             = "*"
            destinationPortRange                 = "22"
          }
        },
        {
          name = "CUSTOM-APP"
          properties = {
            priority                             = 1060
            protocol                             = "TCP"
            access                               = "Allow"
            direction                            = "Inbound"
            sourceApplicationSecurityGroups      = []
            destinationApplicationSecurityGroups = []
            sourceAddressPrefix                  = "*"
            sourcePortRange                      = "*"
            destinationAddressPrefix             = "*"
            destinationPortRange                 = "8003-9500"
          }
        },
        {
          name = "DATADOG"
          properties = {
            priority                             = 1070
            protocol                             = "TCP"
            access                               = "Allow"
            direction                            = "Outbound"
            sourceApplicationSecurityGroups      = []
            destinationApplicationSecurityGroups = []
            sourceAddressPrefix                  = "*"
            sourcePortRange                      = "*"
            destinationAddressPrefix             = "*"
            destinationPortRange                 = "10516"
          }
        }
      ]
    }
    subnetName = {
      value = "default"
    }
    virtualNetworkName = {
      value = "ml-azure-centos-rg-vnet"
    }
    addressPrefixes = {
      value = ["10.1.0.0/16"]
    }
    subnets = {
      value = [
        {
          name = "default"
          properties = {
            addressPrefix = "10.1.0.0/24"

          }
        }
      ]
    }
    publicIpAddressName = {
      value = "ml-azure-centos-node1-ip"
    }
    publicIpAddressType = {
      value = "Dynamic"
    }
    publicIpAddressSku = {
      value = "Basic"
    }
    pipDeleteOption = {
      value = "Detach"
    }
    virtualMachineName = {
      value = "ml-azure-centos-node1"
    }
    virtualMachineComputerName = {
      value = "ml-azure-centos-node1"
    }
    virtualMachineRG = {
      value = "ml-azure-centos-rg"
    }
    osDiskType = {
      value = "Premium_LRS"
    }
    osDiskSizeGiB = {
      value = var.disk_size_gb
    }
    osDiskDeleteOption = {
      value = "Delete"
    }
    dataDisks = {
      value = [
        {
          lun                     = 0
          createOption            = "attach"
          deleteOption            = "Delete"
          caching                 = "ReadOnly"
          writeAcceleratorEnabled = false
          id                      = null
          name                    = "ml-azure-centos-node1_DataDisk_0"
          storageAccountType      = null
          diskSizeGB              = null
          diskEncryptionSet       = null
        }
      ]
    }

    dataDiskResources = {
      value = [
        {
          name = "ml-azure-centos-node1_DataDisk_0"
          sku  = "StandardSSD_LRS"
          properties = {
            diskSizeGB = 32
            creationData = {
              createOption = "empty"
            }
          }
        }
      ]
    }

    virtualMachineSize = {
      value = "Standard_DS13_v2"
    }
    nicDeleteOption = {
      value = "Detach"
    }
    adminUsername = {
      value = "lingtao"
    }
    adminPublicKey = {
      value = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAYmKmWpwNTkOzOLOsW8y/mE9zEHSFUdP5DHQ3IZ654O21WOm9DYzQ9XuSyvNnvuiXur2RQSYSmS7izGL/NDuznU6KTTXPqL+VP7RpCgtHY/zKVzMFtO5NcD7+cKaPYTnbyvVigkKqiZVvIOPoU1j2Fu+jSa0dta+EeMaDlPMNUhJfwwJ7LLLSWwvMDtJM4uZN/7yh9njm7yq9kMkGPvb1swyYP1qPkdJD/YOTmlXRRGvtqAz9WhggRJwCjemQ8l3/IFb4O+QZscb/wzJDUiySdJZYIy4Z8XQjCLzUV2OILm+Ze7cC6OpeVn010w4g81wLIPYBBlGJ+S1U8kBSGqVB3yFLI4KPR3/WCFuw5C6rB6YpFO4y+Ea0Xx3e36mCykvP6oLhQVlhWCsPsbSJHZ/YyKwjokoZ0xrxJXXkt4R8Gs3m2cSL930pM4oPK5UIZEMM9zI5N9HcHg+/TgntJ23GKvc5uIL4ay52uq6OqzonWrsq7+u/u8bvovNV35CRACU= generated-by-azure"
    }
    autoShutdownStatus = {
      value = "Enabled"
    }
    autoShutdownTime = {
      value = "19:00"
    }
    autoShutdownTimeZone = {
      value = "AUS Eastern Standard Time"
    }
    autoShutdownNotificationStatus = {
      value = "Enabled"
    }
    autoShutdownNotificationLocale = {
      value = "en"
    }
    autoShutdownNotificationEmail = {
      value = "Tao.Ling@standards.org.au"
    }
    dnsNameLabel = {
      value = "ml-azure-centos-node1"
    }
    }
  )

}

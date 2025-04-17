# Hub and Spoke Network

### Overview

This project sets up a Hub and Spoke Network topology in Azure using Terraform. It follows Infrastructure as Code (IaC) best practices to ensure automated and efficient deployment.

![](https://raw.githubusercontent.com/strek-o/azure-hub-spoke-network/media/images/spokes.png)

![](https://raw.githubusercontent.com/strek-o/azure-hub-spoke-network/media/images/resources.png)

### File Structure

```
|   .gitignore
|   LICENSE
|   main.tf
|   providers.tf
|   README.md
|   terraform.tfvars
|   variables.tf
|
\---modules
    +---firewall
    |   |   main.tf
    |   |   outputs.tf
    |   |   variables.tf
    |   |
    |   \---application_rule_collection
    |           main.tf
    |           variables.tf
    |
    +---network_interface
    |       main.tf
    |       outputs.tf
    |       variables.tf
    |
    +---network_manager
    |   |   main.tf
    |   |   outputs.tf
    |   |   variables.tf
    |   |
    |   +---admin_rule
    |   |       main.tf
    |   |       variables.tf
    |   |
    |   +---admin_rule_collection
    |   |       main.tf
    |   |       outputs.tf
    |   |       variables.tf
    |   |
    |   +---deployment
    |   |       main.tf
    |   |       variables.tf
    |   |
    |   +---network_group
    |   |       main.tf
    |   |       outputs.tf
    |   |       variables.tf
    |   |
    |   +---security_admin_configuration
    |   |       main.tf
    |   |       outputs.tf
    |   |       variables.tf
    |   |
    |   \---static_member
    |           main.tf
    |           variables.tf
    |
    +---public_ip
    |       main.tf
    |       outputs.tf
    |       variables.tf
    |
    +---resource_group
    |       main.tf
    |       outputs.tf
    |       variables.tf
    |
    +---route
    |       main.tf
    |       variables.tf
    |
    +---route_table
    |       main.tf
    |       outputs.tf
    |       variables.tf
    |
    +---subnet
    |       main.tf
    |       outputs.tf
    |       variables.tf
    |
    +---subnet_route_table_association
    |       main.tf
    |       variables.tf
    |
    +---virtual_network
    |   |   main.tf
    |   |   outputs.tf
    |   |   variables.tf
    |   |
    |   \---peering
    |           main.tf
    |           variables.tf
    |
    \---windows_virtual_machine
            main.tf
            variables.tf
```

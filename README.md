# Hub and Spoke Network

### Overview

Repository holds a `Terraform` implementation of **Hub and Spoke** network topology in Microsoft Azure.
It delivers a scalable, modular, and secure network architecture that follows best practices for network segmentation and centralized management.

### Infrastructure

![](https://raw.githubusercontent.com/strek-o/azure-hub-spoke-network/media/images/spokes.png)

- **RDPConnectionVM** is the only virtual machine with a public IP address.
- Users have to first establish an RDP connection with **RDPConnectionVM**, and from there, access **TestingVM** through another RDP session within the internal network.
- This setup allows for straightforward validation that **Azure Firewall** is functioning correctly.

> [!CAUTION]
> This is intended solely for testing purposes - in a properly secured, production-grade network topology, such direct access should not be allowed.

### Resources

![](https://raw.githubusercontent.com/strek-o/azure-hub-spoke-network/media/images/resources.png)

The infrastructure defined in this project is composed of various Azure resources focused on networking, security, and computing. The list below outlines all Azure resource types that are provisioned and managed as part of the deployment.

Used resources documentation:

- [resource groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [virtual networks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
  - [peerings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering)
- [subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
- [route tables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table)
- [routes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route)
- [route table associations](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association)
- [network manager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager)
  - [network groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_network_group)
  - [static members](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_static_member)
  - [security admin configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_security_admin_configuration)
  - [admin rule collections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_admin_rule_collection)
  - [admin rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_admin_rule)
  - [deployment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_deployment)
- [public IPs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
- [network interfaces](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
- [virtual machines](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine)
- [firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall)
  - [application rule collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection)
- [policy definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition)
- [policy assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment)

### Deployment

1. Clone the repository to your local machine.
   ```
   git clone https://github.com/strek-o/azure-hub-spoke-network.git
   ```
2. Navigate to the cloned directory in your terminal.
   ```
   cd azure-hub-spoke-network
   ```

> [!TIP]
> Create a file named `terraform.tfvars` and set your environment variables (names must match those in `variables.tf`). Otherwise, you will be prompted to enter them during the deployment process.

3. Initialize Terraform to download the necessary providers and modules.
   ```
   terraform init
   ```
4. Review the Terraform plan to see what resources will be created.
   ```
   terraform plan
   ```
5. Apply the Terraform configuration to create the resources in Azure.
   ```
   terraform apply
   ```
6. To destroy the resources created by Terraform, run the following command:
   ```
   terraform destroy
   ```

### File Structure

```powershell
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

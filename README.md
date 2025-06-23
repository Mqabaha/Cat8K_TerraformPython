# Cat8K_TerraformPython
This project automates the deployment and configuration of a Cisco Catalyst 8000V (Cat8K) instance on AWS using Terraform for infrastructure provisioning and Python for router configuration
The repository demonstrates the integration of Terraform and Python to:


Provision AWS Resources:

Retrieve the most recent Cisco Catalyst 8000V AMI from the AWS Marketplace.
Create an AWS EC2 instance with the specified AMI and instance type.
Assign an Elastic IP to the instance.
Automate Router Configuration:

Wait for the instance to become reachable via SSH.
Use a Python script to establish an SSH connection to the instance and configure it with basic settings (e.g., hostname, loopback interface).
Output Key Details:

Provide the instance's private IP and Elastic IP as outputs for further use.

# tf-demo
Terraform demo
1. Created AWS linux instance and used as base for provisioning of EC2 using Terraform
2. Created main.tf, to create the resources include security group and EC2 instance
3. security group created to restrict traffic only to ports 80 and 22
4. ssh key are generated and used for authentication. (using ssh-keygen)
5. Upon execution, EC2 instance got created with traffic open to port 80 and 22, and based on ssh user authentication.
6. Bootstrapping code executed to install apache server, and displayed test page successfully.
7. Display of public IP of instance code has been provided as part main.tf. Connection issues with instance 'for file' and 'remote-exec' function have been in progress.
AWS user has been created and provided the access key and secret key for access.

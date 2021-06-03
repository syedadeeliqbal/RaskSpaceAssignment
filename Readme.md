To run terraform apply
You must run the aws configure command and setup the CLI with valid credentials

Code Structure
- All of the modules under the module folder have 3 files
  a. main.tf        b. output.tf       c. variables.tf

  main.tf: Contains all the code required for creating the resource
  output.tf: Returns the resource
  variables.tf: Contains all the variables used by the module

  Note: I still have some resources like the "target group" etc which I have not moved to modules or did not get time to use the resources.

main.tf
|
|
|______  modules
|       (All modules come here)
|
|
variables.tf

Overall Workflow
1. First step is the networking where I create
    a. VPC
    b. Subnets
    c. Internet Gateway (For public subnets)
    d. Route tables and its association
    e. Create Security Group to allow Http traffic for ALB
    f. Create Security for ASG. The ALB's Security Group will send Http traffic to this Security Group
2. Create Auto Scaling Group
    a. Create ASG
    b. Create Launch Configuration for ASG (I have also tested this with Launch Template. Its commented in code)
    c. Create an auto scale policy based upon the number of requests recieved on the Load Balancer
3. Create an Application Load Balancer
    a. Create an Application Load balancer
    b. Create Lisntener for ALB so it can listen on port 80
    c. Create a target group for the VPC with scaling thresholds 
    d. Link the target group and the ASG

Further Improvements:
1. Move all the resources from the main.tf to modules
2. Move the ASG subnet to a private subnet
3. Allow Https traffic
4. As per the AWS documentation it is recommended to use Launch Template instead of Launch configuration.
   I have tested this with both Launch Templates and Launch configuration but commented it since RS AWS account does not allow Launch Templates.

To run and Test:
- Go to the main.tf add your access keys 
- terraform init
- terraform apply --auto-approve
- Go the load balancer dns and browse it
- Refresh multiple times to see the nodes being load balanced

(I have personally done these verification steps)
- Write some kind of script which will continuously requests to the Load Balancer DNS.
  You will see the nodes scaling up

  Stop sending the requests to LB
  You will see the instances being terminated



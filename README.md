# seamlesshr infrastructure
This infrastructur consist of an EC2 autoscaling group, where the sample application will be deployed, a vpc and its components like two public subnets and one private subnet, a Nat gateway for internet access to resources in the private subnet, an internet gateway and an application load balancer.
To ensure a consistent configuration for our autoscaling group and ensure a faster satart up time, we baked an AMI with the desired configiration leveraging on "packer".
Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel.
configurations like the ami type, root volume size, installing dockr and docker compose have been baked into the AMI as against running the same script through user data. This will increase the start up time of the instance when an autoscaling action is triggered.
Go to the `packer` folder and `ec2-image` and change the values in `template.json` according to your specification and run:

`packer init` (for initialization)

`packer validate template.json` (to ensure that the configuration is correct)

`packer build template.json` (to build the AMI)

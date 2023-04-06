

# AWS SA Certification (SAA-C03):

* reference from [AWS SA Tips on Medium](https://medium.com/@neonforge/the-ultimate-cheatsheet-for-aws-solutions-architect-exam-saa-c02-part-1-ed56a8096392)

## subjects:
-------------
* IAM - AWS Identity and Access Management 
* AMI - Amazon Machine Images
* VPC -
* EC2 -
* S3 -
* RDS -
* Lambda - 
* SQS  -
* API Gateway -
* Kinesis - 

## Questions:
---------------

Here is an overview of common keywords and possible solutions:

* HA Highly Available = Use Multiple Availability zones

* Fault-Tolerant = Use Multiple Availability zones and a complete replica of the application environment for fail-over. 
				   The application failure in one AZ should automatically lead to recovery in a different AZ or region

* Real-Time Data = if you read real-time data processing, it’s likely related to Kinesis services

* Disaster = Failover to a different region is required

* Long Term Storage = Glacier or Deep Glacier storage

* Managed Service = S3 for data storage, 
					Lambda for computing, 
					Aurora for RDS 
					DynamoDB for NoSQL database

Use AWS Network = usually, these keywords are related to communication between VPC instances and AWS services. 
				  Use VPC gateways and endpoints to connect to these services.

Many questions in the exam are related to a classic 2-tier application architecture, which consists of Web servers and Database servers. 
You will likely to be asked about security settings for the infrastructure.

## Scenario 1 (simple setup):
-------------------------------
Internet -> Web server (EC2) -> MySQL(RDS instance)

- Web Server needs to be in the public subnet of your VPC and MySQL instance in the private subnet. 
- Security Group for the Web server is open for all incoming requests on port 80(HTTP) or/and 443(HTTPS) to all IPs, 
  and the Security Group for the MySQL instance has only port 3306 open for the Security Group of the Web Server.
  
## Scenario 2 (setup with Load Balancing “ELB” and AutoScalingGroup “ASG”):
--------------------------------------------------------------------------------
Internet -> ELB -> ASG -> Web Server(EC2) -> MySQL(RDS instance)

- This scenario usually requires high availability and fault tolerance, combined with correct security requirements.
- On security: place ELB in the public subnet and open the ports for HTTP or/and HTTPS, 
- place web servers and SQL instance in a private subnet.

And talking about security, you need to remember the difference between:
 WAF (Web Application Firewall): WAF is used to protect against attacks like cross-site scripting
 and AWS Shield: Shield is offering protection against DDOS attacks.

## Scenario 3 (serverless web application):
-----------------------------------------------
Internet -> API Gateway -> Lambda -> DynamoDB or/and S3

- Serverless applications are usually highly available because they operate in multiple Availability Zones. 
  But you need to do some extra work to make them fault-tolerant. 
- Usually, it means adding Cloudfront distribution for better caching (more on that later in the text) 
  and latency, setting up a Multi-region application for disaster recovery, use of SQS for data digestion, and use of Auto Scaling on DynamoDB.

## VPC = Virtual Private Cloud
----------------------------------------------------
VPC stands for Virtual Private Cloud, and it includes all of your virtual server infrastructure. 
A single VPC can span over multiple Availability Zones in a region. 
It can’t span over multiple regions, although you can use VPC peering to connect VPCs from different regions.

VPC can contain public and private subnets and they are defined by specific private IP ranges. 
Public subnets are open to the Internet, but only if you have set up Internet Gateway on your VPC. 

Private subnets don’t have access to the Internet and if you need to provide access to the internet for some of the instances (i.e. Software updates) 
you will need to create a NAT Gateway in the public subnet, and enable traffic from private instances to the NAT Gateway 
(Very common question in the exam)

Another common scenario is the use of Bastion hosts. 
Bastion hosts are required to secure SSH admin access from the internet to the instances in a private subnet. 
Bastion host needs to be placed in a public subnet and private instance must allow traffic from Bastion host Security Group on Port 22 (also a common question)

Network Access Control List (NACL) = defines rules for incoming and outgoing traffic for your subnet. Important to remember are 2 things.
	- Default NACL allows all traffic to go out and go in (all ports open)
	- NACL can block traffic (explicit Deny), for instance, you can block particular IP or IP range from accessing your subnet.

Route Tables = define network traffic paths through your VPC. Route tables are attached to each subnet

VPC Endpoints = Access to all AWS services which are not part of the VPC. 
				Important to remember that there a 2 types of Endpoints:
				- Gateway Endpoint = enables use of S3 and DynamoDB services
				- Interface Endpoint = enables use of all other AWS services

CIDR = stands for Classless Inter-Domain Routin

CIDR Range is used to define a range of IP addresses and it may look like that

192.168.10/32 = /32 means that that the IP range selected only a single IP address 192.168.10.255
192.168.10/31 = /31 means that that the IP range selected only 2 IP addresses 192.168.10.254 and 192.168.10.255
192.168.10/30 = /31 means that that the IP range selected only 4 IP addresses 192.168.10.252, 192.168.10.253, 192.168.10.254 and 192.168.10.255

Here you can play with different CIDR scenarios https://www.ipaddressguide.com/cidr


VPC Gateway = enables connection to your On-Prem network via the public internet.

NAT Gateway = enables internet connection from instances in a private subnet (i.e. for software updates). 
			  Some exam questions may give you a choice between NAT Gateway and NAT Instance. 
			  Generally, NAT Gateway is the right answer, as NAT instance needs to be managed by the user and doesn’t scale automatically. 
			  NAT Gateway on the other hand is an AWS managed service and can scale automatically based on demand. 
			  A question may come up in the exam asking for high availability of NAT Gateways if your VPC spans across multiple AZs. 
			  The right answer is to use individual NAT Gateways in each AZ.

VPC peering = enables you to establish connection between different VPCs. 
			  You can connect to your own VPC as well to other accounts/users VPCs (with their permission). 
			  Important to remember that the CIDR-range of connected VPCs shouldn’t overlap. 
			  VPC peering doesn't work as transconnectivity tool. 
			  For instance if you have 3 VPCs (A, B and C) and create peering between A and B, and between B and C, 
			  the instances in VPC A are not able to connect to instances in VPC C, you have to peer VPC A with VPC B if you need to establish connection.

AWS Transit Gateway = acts as VPC hub and connects multiple VPC as a giant VPC web. 
					  You can connect AWS VPCs and your on-premises VPCs. 
					  Here is also important to remember that CIDR ranges shouldn't overlap.


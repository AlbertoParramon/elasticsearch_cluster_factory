#!/bin/bash

AWS_ZONE=eu-west-1
echo "Deleting namespace es-secure"
kubectl delete namespace es-secure --wait=true

echo "Waiting for namespace to be deleted to avoid orphaned resources"
sleep 180

echo "Destroying terraform infrastructure"
terraform destroy -auto-approve

echo "Deleting repositories"
aws ecr delete-repository   --repository-name aws-es-kibana-img-repository   --region eu-west-1   --force
aws ecr delete-repository   --repository-name aws-es-node-img-repository   --region eu-west-1   --force

echo "Delete docker images"
docker rmi -f $(docker images | grep aws-es  | awk -F' ' '{print$3}')


echo "Checking orphaned resources. If any resource is found, you need to delete it manually."
DEFAULT_VPC=$(aws ec2 describe-vpcs --region $AWS_ZONE --filters "Name=isDefault,Values=true" --query 'Vpcs[0].VpcId' --output text)
echo "=== EBS VOLUMES DISPONIBLES ==="
aws ec2 describe-volumes --region $AWS_ZONE --query 'Volumes[?State==`available`].[VolumeId,Size,VolumeType,CreateTime]' --output text
echo "=== VPCS ==="
aws ec2 describe-vpcs --region $AWS_ZONE --filters "Name=isDefault,Values=false" --query 'Vpcs[].[VpcId,State,CidrBlock,Tags[?Key==`Name`].Value|[0]]' --output text
echo "=== SECURITY GROUPS ==="
aws ec2 describe-security-groups --region $AWS_ZONE --query 'SecurityGroups[?GroupName!=`default`].[GroupId,GroupName,VpcId,Description]' --output text
echo "=== INTERNET GATEWAYS ==="
aws ec2 describe-internet-gateways --region $AWS_ZONE --query "InternetGateways[?Attachments[0].VpcId!='$DEFAULT_VPC'].[InternetGatewayId,Attachments[0].State,Attachments[0].VpcId]" --output text
echo "=== NAT GATEWAYS ==="
aws ec2 describe-nat-gateways --region $AWS_ZONE --query "NatGateways[?VpcId!='$DEFAULT_VPC'].[NatGatewayId,State,VpcId,SubnetId,NatGatewayAddresses[0].PublicIp]" --output text
echo "=== ROUTE TABLES ==="
aws ec2 describe-route-tables --region $AWS_ZONE --query "RouteTables[?VpcId!='$DEFAULT_VPC'].[RouteTableId,VpcId,Associations[0].Main]" --output text
echo "=== SUBNETS ==="
aws ec2 describe-subnets --region $AWS_ZONE --filters "Name=defaultForAz,Values=false" --query 'Subnets[].[SubnetId,VpcId,State,CidrBlock]' --output text
echo "=== LOAD BALANCERS ==="
aws elbv2 describe-load-balancers --region $AWS_ZONE --query 'LoadBalancers[].[LoadBalancerName,LoadBalancerArn,VpcId,State.Code]' --output text
echo "=== EKS CLUSTERS ==="
aws eks list-clusters --region $AWS_ZONE --query 'clusters[]' --output text
echo "=== EFS FILE SYSTEMS ==="
aws efs describe-file-systems --region $AWS_ZONE --query 'FileSystems[].[FileSystemId,Name,LifeCycleState]' --output text
echo "=== IAM ROLES ==="
aws iam list-roles --query 'Roles[?contains(RoleName, `elasticsearch`) || contains(RoleName, `efs`) || contains(RoleName, `eks`)].RoleName' --output text
echo "=== NETWORK INTERFACES ==="
aws ec2 describe-network-interfaces --region $AWS_ZONE --query 'NetworkInterfaces[].[NetworkInterfaceId,Status,VpcId,SubnetId]' --output text
echo "=== REPOSITORIES ==="
aws ecr describe-repositories --region $AWS_ZONE
echo "=== TARGET GROUPS ==="
aws elbv2 describe-target-groups --region $AWS_ZONE --query 'TargetGroups[].TargetGroupArn' --output text
echo "=== ADDRESSES ==="
aws ec2 describe-addresses --region $AWS_ZONE --query 'Addresses[?AssociationId==null].AllocationId' --output text


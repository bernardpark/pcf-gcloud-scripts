#!/bin/bash
#******************************************************************************
#    GCP PCF (PKS and/or PAS) Installation Script
#******************************************************************************i
#
# DESCRIPTION
#    Automates PCF Installation on GCP using the GCP CLI.
#
#
#==============================================================================
#   Global properties and tags. Modify according to your configuration.
#==============================================================================

# Region and Zone
REG="us-east1"
ZNE_1="$REG-b"
ZNE_2="$REG-c"
ZNE_3="$REG-d"

# IAM
GCP_USR="gcp-user"
GCP_PRJ="pa-bpark"

# NAT Instance Tags
NAT_TAG="nat-traverse,bpark-pcf-nat-instance"

# NAT Route Tags
NAT_RTE_TAG="bpark-pcf"

# Firewall Tags
FRW_TAG_1="allow-ssh"
FRW_TAG_2="allow-http,router"
FRW_TAG_3="allow-https,router"
FRW_TAG_4="router"
FRW_TAG_5="bpark-pcf,bpark-pcf-opsman,nat-traverse"
FRW_TAG_6="bpark-pcf-cf-tcp"
FRW_TAG_7="bpark-pcf-ssh-proxy,diego-brain"

#==============================================================================
#   Resources names. Modify to match your convention.
#==============================================================================

# VPC
VPC_NME="bpark-pcf-virt-net"

SBN_NME_1="bpark-pcf-subnet-infrastructure-us-east1"
SBN_NME_2="bpark-pcf-subnet-pas-us-east1"
SBN_NME_3="bpark-pcf-subnet-services-us-east1"

# Compute
NAT_NME_1="bpark-pcf-nat-gateway-pri"
NAT_NME_2="bpark-pcf-nat-gateway-sec"
NAT_NME_3="bpark-pcf-nat-gateway-ter"

# Routes
NAT_RTE_1="bpark-pcf-nat-pri"
NAT_RTE_2="bpark-pcf-nat-sec"
NAT_RTE_3="bpark-pcf-nat-ter"

# Firewall
FRW_RLE_1="bpark-pcf-allow-ssh"
FRW_RLE_2="bpark-pcf-allow-http"
FRW_RLE_3="bpark-pcf-allow-https"
FRW_RLE_4="bpark-pcf-allow-http-8080"
FRW_RLE_5="bpark-pcf-allow-pas-all"
FRW_RLE_6="bpark-pcf-allow-cf-tcp"
FRW_RLE_7="bpark-pcf-allow-ssh-proxy"

#==============================================================================
#   Configuration details. No need to modify.
#==============================================================================

# VPC
SBN_RNG_1="192.168.101.0/26"
SBN_RNG_2="192.168.16.0/22"
SBN_RNG_3="192.168.20.0/22"

# Compute
NAT_TYP="n1-standard-4"

NAT_BT_DSK="10GB"
NAT_BT_DSK_TYP="pd-standard"

NAT_IMG_FML="ubuntu-1404-lts"
NAT_IMG_PRJ="ubuntu-os-cloud"

NAT_SCR_LOC="./nat-startup-script.sh"

NAT_IP_1="192.168.101.2"
NAT_IP_2="192.168.101.3"
NAT_IP_3="192.168.101.4"

# Firewall
FRW_PRT_1="tcp:22"
FRW_PRT_2="tcp:80"
FRW_PRT_3="tcp:443"
FRW_PRT_4="tcp:8080"
FRW_PRT_5="tcp,udp,icmp"
FRW_PRT_6="tcp:1024-65535"
FRW_PRT_7="tcp:2222"

#==============================================================================
#   Installation script below. Do not modify.
#==============================================================================

echo "*********************************************************************************************************"
echo "*** THIS SCRIPT WILL CONFIGURE AND USE YOUR GCP CLI. BEFORE YOU BEGIN MAKE SURE THIS SCRIPT IS SECURE ***"
echo "*********************************** REQUIRES gcloud and gsutil ******************************************"
echo "*********************************************************************************************************"
echo ""
echo ""

# Create Service Account
echo ""
echo "*********************************************************************************************************"
echo "************************************ Creating IAM Service Account ***************************************"
echo ""

gcloud iam service-accounts create \
  $GCP_USR \
  --display-name $GCP_USR

gcloud iam service-accounts keys create \
  --iam-account=$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com \
  $GCP_USR.key.json

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser" &> /dev/null

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator" &> /dev/null

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/compute.instanceAdmin.v1" &> /dev/null

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/compute.networkAdmin" &> /dev/null

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/compute.storageAdmin" &> /dev/null

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/storage.admin" &> /dev/null

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/cloudsql.admin" &> /dev/null

gcloud projects add-iam-policy-binding \
  $GCP_PRJ \
  --member="serviceAccount:$GCP_USR@$GCP_PRJ.iam.gserviceaccount.com" \
  --role="roles/owner"

# Create VPC and Subnets
echo ""
echo "******************************************** Creating VPC ***********************************************"
echo ""

gcloud compute networks create \
  $VPC_NME \
  --subnet-mode=custom \
  --bgp-routing-mode=regional

gcloud compute networks subnets create \
  $SBN_NME_1 \
  --network=$VPC_NME \
  --range=$SBN_RNG_1 \
  --region=$REG

gcloud compute networks subnets create \
  $SBN_NME_2 \
  --network=$VPC_NME \
  --range=$SBN_RNG_2 \
  --region=$REG

gcloud compute networks subnets create \
  $SBN_NME_3 \
  --network=$VPC_NME \
  --range=$SBN_RNG_3 \
  --region=$REG

# Create NAT Instances
echo ""
echo "******************************************** Creating NAT ***********************************************"
echo ""

gcloud compute instances create \
  $NAT_NME_1 \
  --zone=$ZNE_1 \
  --machine-type=$NAT_TYP \
  --boot-disk-size=$NAT_BT_DSK \
  --boot-disk-type=$NAT_BT_DSK_TYP \
  --image-family=$NAT_IMG_FML \
  --image-project=$NAT_IMG_PRJ \
  --metadata-from-file=startup-script=$NAT_SCR_LOC \
  --tags=$NAT_TAG \
  --network=$VPC_NME \
  --subnet=$SBN_NME_1 \
  --private-network-ip=$NAT_IP_1 \
  --can-ip-forward
  
gcloud compute instances create \
  $NAT_NME_2 \
  --zone=$ZNE_2 \
  --machine-type=$NAT_TYP \
  --boot-disk-size=$NAT_BT_DSK \
  --boot-disk-type=$NAT_BT_DSK_TYP \
  --image-family=$NAT_IMG_FML \
  --image-project=$NAT_IMG_PRJ \
  --metadata-from-file=startup-script=$NAT_SCR_LOC \
  --tags=$NAT_TAG \
  --network=$VPC_NME \
  --subnet=$SBN_NME_1 \
  --private-network-ip=$NAT_IP_2 \
  --can-ip-forward

gcloud compute instances create \
  $NAT_NME_3 \
  --zone=$ZNE_3 \
  --machine-type=$NAT_TYP \
  --boot-disk-size=$NAT_BT_DSK \
  --boot-disk-type=$NAT_BT_DSK_TYP \
  --image-family=$NAT_IMG_FML \
  --image-project=$NAT_IMG_PRJ \
  --metadata-from-file=startup-script=$NAT_SCR_LOC \
  --tags=$NAT_TAG \
  --network=$VPC_NME \
  --subnet=$SBN_NME_1 \
  --private-network-ip=$NAT_IP_3 \
  --can-ip-forward

# Create NAT Routes
echo ""
echo "**************************************** Creating NAT Routes ********************************************"
echo ""

gcloud compute routes create \
  $NAT_RTE_1 \
  --network=$VPC_NME \
  --destination-range=0.0.0.0/0 \
  --priority=800 \
  --tags=$NAT_RTE_TAG \
  --next-hop-instance=$NAT_NME_1 \
  --next-hop-instance-zone=$ZNE_1

gcloud compute routes create \
  $NAT_RTE_2 \
  --network=$VPC_NME \
  --destination-range=0.0.0.0/0 \
  --priority=800 \
  --tags=$NAT_RTE_TAG \
  --next-hop-instance=$NAT_NME_2 \
  --next-hop-instance-zone=$ZNE_2

gcloud compute routes create \
  $NAT_RTE_3 \
  --network=$VPC_NME \
  --destination-range=0.0.0.0/0 \
  --priority=800 \
  --tags=$NAT_RTE_TAG \
  --next-hop-instance=$NAT_NME_3 \
  --next-hop-instance-zone=$ZNE_3

# Create Firewall Rules
echo ""
echo "************************************** Creating Firewall Rules ******************************************"
echo ""

gcloud compute firewall-rules create \
  $FRW_RLE_1 \
  --network=$VPC_NME \
  --allow $FRW_PRT_1 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$FRW_TAG_1

gcloud compute firewall-rules create \
  $FRW_RLE_2 \
  --network=$VPC_NME \
  --allow $FRW_PRT_2 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$FRW_TAG_2

gcloud compute firewall-rules create \
  $FRW_RLE_3 \
  --network=$VPC_NME \
  --allow $FRW_PRT_3 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$FRW_TAG_3

gcloud compute firewall-rules create \
  $FRW_RLE_4 \
  --network=$VPC_NME \
  --allow $FRW_PRT_4 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$FRW_TAG_4

gcloud compute firewall-rules create \
  $FRW_RLE_5 \
  --network=$VPC_NME \
  --allow $FRW_PRT_5 \
  --source-tags=$FRW_TAG_5 \
  --target-tags=$FRW_TAG_5

gcloud compute firewall-rules create \
  $FRW_RLE_6 \
  --network=$VPC_NME \
  --allow $FRW_PRT_6 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$FRW_TAG_6

gcloud compute firewall-rules create \
  $FRW_RLE_7 \
  --network=$VPC_NME \
  --allow $FRW_PRT_7 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$FRW_TAG_7

echo ""
echo "******************************************** PKS COMPLETED **********************************************"
echo "******************************* GCP Infrastructure for PKS has completed. *******************************"
echo -n "********************************* Continue configuration for PAS (Y/n)? *********************************"
read UINPUT

if [ -z "$UINPUT" ]; then
    ./install-pas.sh
fi

echo ""
echo "********************************************** COMPLETED ************************************************"
echo "*********************************************************************************************************"
echo ""
echo ""

exit 0

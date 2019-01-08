#!/bin/bash
#******************************************************************************
#    GCP PCF Installation Script
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

# Health Check
HLT_CHK_NME="bpark-pcf-cf-public"

#==============================================================================
#   Deletion script below. Do not modify.
#==============================================================================

echo "*********************************************************************************************************"
echo "*** THIS SCRIPT WILL CONFIGURE AND USE YOUR GCP CLI. BEFORE YOU BEGIN MAKE SURE THIS SCRIPT IS SECURE ***"
echo "*********************************** REQUIRES gcloud and gsutil ******************************************"
echo "*********************************************************************************************************"
echo ""
echo ""

echo "***************************** PAS or PKS infrastructure may be cleaned up. ******************************"
echo -n "************************************ Continue cleanup for PAS (Y/n)? ************************************"
read UINPUT

if [ -z "$UINPUT" ]; then
    ./cleanup-pas.sh
fi
# Delete Firewall Rules
echo ""
echo "************************************** Deleting Firewall Rules ******************************************"
echo ""

yes | gcloud compute health-checks delete \
  $HLT_CHK_NME

# Delete Firewall Rules
echo ""
echo "************************************** Deleting Firewall Rules ******************************************"
echo ""

yes | gcloud compute firewall-rules delete \
  $FRW_RLE_1 $FRW_RLE_2 $FRW_RLE_3 $FRW_RLE_4 $FRW_RLE_5 $FRW_RLE_6 $FRW_RLE_7

# Delete Routes
echo ""
echo "**************************************** Deleting NAT Routes ********************************************"
echo ""

yes | gcloud compute routes delete \
  $NAT_RTE_1 $NAT_RTE_2 $NAT_RTE_3

# Delete Compute Instances
echo ""
echo "************************************* Deleting Compute Instances ****************************************"
echo ""

yes | gcloud compute instances delete \
  $NAT_NME_1 \
  --zone=$ZNE_1 \
  --delete-disks=all

yes | gcloud compute instances delete \
  $NAT_NME_2 \
  --zone=$ZNE_2 \
  --delete-disks=all

yes | gcloud compute instances delete \
  $NAT_NME_3 \
  --zone=$ZNE_3 \
  --delete-disks=all

# Delete VPC
echo ""
echo "******************************************** Deleting VPC ***********************************************"
echo ""

yes | gcloud compute networks subnets delete \
  $SBN_NME_1 $SBN_NME_2 $SBN_NME_3 \
  --region=$REG

yes | gcloud compute networks delete \
  $VPC_NME

# Delete Service Accounts
echo ""
echo "************************************ Deleting IAM Service Account ***************************************"
echo ""
yes | gcloud iam service-accounts delete \
  $GCP_USR@$GCP_PRJ.iam.gserviceaccount.com

echo ""
echo "********************************************** COMPLETED ************************************************"
echo "*********************************************************************************************************"
echo ""
echo ""

exit 0

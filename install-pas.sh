#!/bin/bash
#******************************************************************************
#    GCP PAS (Continued) Installation Script
#******************************************************************************i
#
# DESCRIPTION
#    Automates PCF Installation on GCP using the GCP CLI.
#    -- DO NOT RUN THIS AS A STANDALONE SCRIPT --
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
GCP_PRJ="pa-bpark"

#==============================================================================
#   Resources names. Modify to match your convention.
#==============================================================================

# SQL
# SQL_NME="bpark-pcf-pas-sql"
SQL_NME="test004"

# Database
DB_NME_1="account"
DB_NME_2="app_usage_service"
DB_NME_3="autoscale"
DB_NME_4="ccdb"
DB_NME_5="console"
DB_NME_6="diego"
DB_NME_7="locket"
DB_NME_8="networkpolicyserver"
DB_NME_9="nfsvolume"
DB_NME_10="notifications"
DB_NME_11="routing"
DB_NME_12="silk"
DB_NME_13="uaa"
DB_NME_14="credhub"

# Storage
BKT_NME_1="bpark-pcf-buildpacks"
BKT_NME_2="bpark-pcf-droplets"
BKT_NME_3="bpark-pcf-packages"
BKT_NME_4="bpark-pcf-resources"

# Load Balancers
# LB_NME="bpark-pcf-http-lb"

# Health Check
HLT_CHK_NME="bpark-pcf-cf-public"

#==============================================================================
#   Configuration details. No need to modify.
#==============================================================================

# SQL
SQL_VRS="MYSQL_5_7"
SQL_TYP="db-n1-standard-2"
SQL_PWD="bparkPassword@2"

# Database
DB_USR_1="$DB_NME_1-user"
DB_PWD_1="$DB_USR_1-Password@2"

DB_USR_2="${DB_NME_2:0:10}-user"
DB_PWD_2="$DB_USR_2-Password@2"

DB_USR_3="$DB_NME_3-user"
DB_PWD_3="$DB_USR_3-Password@2"

DB_USR_4="$DB_NME_4-user"
DB_PWD_4="$DB_USR_4-Password@2"

DB_USR_5="$DB_NME_5-user"
DB_PWD_5="$DB_USR_5-Password@2"

DB_USR_6="$DB_NME_6-user"
DB_PWD_6="$DB_USR_6-Password@2"

DB_USR_7="$DB_NME_7-user"
DB_PWD_7="$DB_USR_7-Password@2"

DB_USR_8="${DB_NME_8:0:10}-user"
DB_PWD_8="$DB_USR_8-Password@2"

DB_USR_9="$DB_NME_9-user"
DB_PWD_9="$DB_USR_9-Password@2"

DB_USR_10="${DB_NME_10:0:10}-user"
DB_PWD_10="$DB_USR_10-Password@2"

DB_USR_11="$DB_NME_11-user"
DB_PWD_11="$DB_USR_11-Password@2"

DB_USR_12="$DB_NME_12-user"
DB_PWD_12="$DB_USR_12-Password@2"

DB_USR_13="$DB_NME_13-user"
DB_PWD_13="$DB_USR_13-Password@2"

DB_USR_14="$DB_NME_14-user"
DB_PWD_14="$DB_USR_14-Password@2"


#==============================================================================
#   Installation script below. Do not modify.
#==============================================================================

# Create SQL Instance
echo ""
echo "*************************************** Creating SQL Instance *******************************************"
echo ""

gcloud sql instances create \
  $SQL_NME \
  --database-version=$SQL_VRS \
  --region=$REG \
  --gce-zone=$ZNE_1 \
  --tier=$SQL_TYP \
  --enable-bin-log \
  --authorized-networks=0.0.0.0/0

gcloud sql instances create \
  $SQL_NME \
  --database-version=$SQL_VRS \
  --region=$REG \
  --gce-zone=$ZNE_1 \
  --tier=$SQL_TYP \
  --enable-bin-log \
  --authorized-networks=0.0.0.0/0

SQL_HST=$(gcloud sql instances describe $SQL_NME | sed -n 's/.*ipAddress://p' | tr -d '[:space:]')

gcloud sql users set-password \
  root \
  --instance=$SQL_NME \
  --host=$SQL_HST \
  --password=$SQL_PWD

# Create Databases
echo ""
echo "**************************************** Creating Databases *********************************************"
echo ""

gcloud sql databases create \
   $DB_NME_1 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_1 \
  --instance=$SQL_NME \
  --password=$DB_PWD_1

gcloud sql databases create \
   $DB_NME_2 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_2 \
  --instance=$SQL_NME \
  --password=$DB_PWD_2

gcloud sql databases create \
   $DB_NME_3 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_3 \
  --instance=$SQL_NME \
  --password=$DB_PWD_3

gcloud sql databases create \
   $DB_NME_4 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_4 \
  --instance=$SQL_NME \
  --password=$DB_PWD_4

gcloud sql databases create \
   $DB_NME_5 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_5 \
  --instance=$SQL_NME \
  --password=$DB_PWD_5

gcloud sql databases create \
   $DB_NME_6 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_6 \
  --instance=$SQL_NME \
  --password=$DB_PWD_6

gcloud sql databases create \
   $DB_NME_7 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_7 \
  --instance=$SQL_NME \
  --password=$DB_PWD_7

gcloud sql databases create \
   $DB_NME_8 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_8 \
  --instance=$SQL_NME \
  --password=$DB_PWD_8

gcloud sql databases create \
   $DB_NME_9 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_9 \
  --instance=$SQL_NME \
  --password=$DB_PWD_9

gcloud sql databases create \
   $DB_NME_10 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_10 \
  --instance=$SQL_NME \
  --password=$DB_PWD_10

gcloud sql databases create \
   $DB_NME_11 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_11 \
  --instance=$SQL_NME \
  --password=$DB_PWD_11

gcloud sql databases create \
   $DB_NME_12 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_12 \
  --instance=$SQL_NME \
  --password=$DB_PWD_12

gcloud sql databases create \
   $DB_NME_13 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_13 \
  --instance=$SQL_NME \
  --password=$DB_PWD_13

gcloud sql databases create \
   $DB_NME_14 \
   --instance=$SQL_NME

gcloud sql users create \
  $DB_USR_14 \
  --instance=$SQL_NME \
  --password=$DB_PWD_14

# Create Buckets
echo ""
echo "***************************************** Creating Buckets **********************************************"
echo ""

gsutil mb \
  -p $GCP_PRJ \
  -c multi_regional \
  -l $REG \
  gs://$BKT_NME_1/

gsutil mb \
  -p $GCP_PRJ \
  -c multi_regional \
  -l $REG \
  gs://$BKT_NME_2/

gsutil mb \
  -p $GCP_PRJ \
  -c multi_regional \
  -l $REG \
  gs://$BKT_NME_3/

gsutil mb \
  -p $GCP_PRJ \
  -c multi_regional \
  -l $REG \
  gs://$BKT_NME_4/

# Create Load Balancers
echo ""
echo "************************************* Creating Load Balancers *******************************************"
echo ""

#gcloud compute instance-groups unmanaged create \
#  $LB_NME \
#  --zone=$ZNE_1

#gcloud compute instance-groups unmanaged create \
#  $LB_NME \
#  --zone=$ZNE_2

#gcloud compute instance-groups unmanaged create \
#  $LB_NME \
#  --zone=$ZNE_3

# Create Health Checks
echo ""
echo "************************************** Creating Health Checks *******************************************"
echo ""

gcloud compute http-health-checks create \
  $HLT_CHK_NME \
  --port=8080 \
  --request-path=/health \
  --check-interval=30 \
  --timeout=5 \
  --healthy-threshold=10 \
  --unhealthy-threshold=2 \

# TODO: CREATE LOAD BALANCERS

exit 0

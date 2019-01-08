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

#==============================================================================
#   Resources names. Modify to match your convention.
#==============================================================================
# SQL
# SQL_NME="bpark-pcf-pas-sql"
SQL_NME="test004"

# Database
DB_NME_1="account"
DB_NME_2="app-usage-service"
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

DB_USR_1="$DB_NME_1-user"
DB_USR_2="$DB_NME_2-user"
DB_USR_3="$DB_NME_3-user"
DB_USR_4="$DB_NME_4-user"
DB_USR_5="$DB_NME_5-user"
DB_USR_6="$DB_NME_6-user"
DB_USR_7="$DB_NME_7-user"
DB_USR_8="$DB_NME_8-user"
DB_USR_9="$DB_NME_9-user"
DB_USR_10="$DB_NME_10-user"
DB_USR_11="$DB_NME_11-user"
DB_USR_12="$DB_NME_12-user"
DB_USR_13="$DB_NME_13-user"
DB_USR_14="$DB_NME_14-user"

# Storage
BKT_NME_1="bpark-pcf-buildpacks"
BKT_NME_2="bpark-pcf-droplets"
BKT_NME_3="bpark-pcf-packages"
BKT_NME_4="bpark-pcf-resources"

# Load Balancers
LB_NME="bpark-pcf-http-lb"

# Health Check
HLT_CHK_NME="bpark-pcf-cf-public"

#==============================================================================
#   Deletion script below. Do not modify.
#==============================================================================

# Delete Health Check
echo ""
echo "****************************************** Deleting Health Check ******************************************"
echo ""

gcloud compute health-checks delete \
  $HLT_CHK_NME

# Delete Load Balancers
echo ""
echo "**************************************** Deleting Load Balancers *****************************************"
echo ""

gcloud compute instance-groups unmanaged delete \
  $LB_NME \
  --zone=$ZNE_1

gcloud compute instance-groups unmanaged delete \
  $LB_NME \
  --zone=$ZNE_2

gcloud compute instance-groups unmanaged delete \
  $LB_NME \
  --zone=$ZNE_3

# Delete Buckets
echo ""
echo "****************************************** Deleting Buckets *********************************************"
echo ""

gsutil rm -r gs://$BKT_NME_1
gsutil rm -r gs://$BKT_NME_2
gsutil rm -r gs://$BKT_NME_3
gsutil rm -r gs://$BKT_NME_4

# Delete SQL Instance
echo ""
echo "************************************ Deleting Databases and Users ***************************************"
echo ""

SQL_HST=$(gcloud sql instances describe $SQL_NME | sed -n 's/.*ipAddress://p' | tr -d '[:space:]')

yes | gcloud sql users delete \
  $DB_USR_2 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_3 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_4 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_5 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_6 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_7 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_8 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_9 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_10 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_11 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_12 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_13 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql users delete \
  $DB_USR_14 \
  --instance=$SQL_NME \
  --host=$SQL_HST

yes | gcloud sql databases delete \
  $DB_NME_1 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_2 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_3 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_4 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_5 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_6 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_7 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_8 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_9 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_10 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_11 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_12 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_13 \
  --instance=$SQL_NME

yes | gcloud sql databases delete \
  $DB_NME_14 \
  --instance=$SQL_NME

# Delete SQL Instance
echo ""
echo "*************************************** Deleting SQL Instance *******************************************"
echo ""

yes | gcloud sql instances delete \
  $SQL_NME

exit 0

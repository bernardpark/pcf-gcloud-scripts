# Setting up PCF Reference Architecture on GCP using CLI

This repository contains a rudimentary shell script to implement PCF on GCP Reference Architecture, as well as tearing it down. It is not meant for production use, but rather a learning experience.

## Getting Started

Clone this repository to an environment of your choice.

```bash
git clone https://github.com/bernardpark/pcf-gcloud-scripts.git
```

## Prerequisites

### Authenticate GCP Account

Prepare your environment by authorizing your GCP Account

```bash
gcloud auth login
```

### Enable APIs

Navigate to the [GCP API](https://console.cloud.google.com/apis/library) page in your GCP project and enable the following APIs

1. Identity Access and Management (IAM) API
1. IAM Service Account Credentials API
1. Google Compute Engine API
1. Google Cloud Resource Manager API

## Resources

* [Installing PKS on GCP](https://docs.pivotal.io/runtimes/pks/1-2/installing-pks-gcp.html) - Pivotal's official guide


## Authors

* **Bernard Park** - [Github](https://github.com/bernardpark)


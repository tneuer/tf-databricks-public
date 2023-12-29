#!/usr/bin/env bash
source ./sh_scripts/variables.sh $1
terraform apply -var-file="./variables/$1.tfvars" -auto-approve;

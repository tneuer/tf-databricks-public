#!/usr/bin/env bash
terraform apply -var-file="./variables/$1.tfvars" -auto-approve;

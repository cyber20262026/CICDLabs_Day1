#!/bin/bash
# Ansible Deployment Script

set -e

ENV="development"
PLAYBOOK="playbooks/deploy-app.yml"
CHECK_ONLY=false

while getopts e:p:c flag
do
  case "${flag}" in
    e) ENV=${OPTARG};;
    p) PLAYBOOK=${OPTARG};;
    c) CHECK_ONLY=true;;
  esac
done

echo "[`date +"%Y-%m-%d %H:%M:%S"`] Ansible Deployment Plan"
echo "================================="
echo "Environment: $ENV"
echo "Inventory: $(pwd)/inventories/$ENV.yml"
echo "Playbook: $(pwd)/$PLAYBOOK"
echo "Command: ansible-playbook -i $(pwd)/inventories/$ENV.yml $(pwd)/$PLAYBOOK"
echo "================================="

echo "[`date +"%Y-%m-%d %H:%M:%S"`] Running pre-flight checks..."
echo "[`date +"%Y-%m-%d %H:%M:%S"`] Testing inventory connectivity..."
ansible -i inventories/$ENV.yml all -m ping

echo "[`date +"%Y-%m-%d %H:%M:%S"`] Checking playbook syntax..."
ansible-playbook -i inventories/$ENV.yml $PLAYBOOK --syntax-check

echo "[SUCCESS] Pre-flight checks completed"

if [ "$CHECK_ONLY" = true ]; then
  echo "[`date +"%Y-%m-%d %H:%M:%S"`] Running in check mode (dry-run)..."
  ansible-playbook -i inventories/$ENV.yml $PLAYBOOK --check
  exit 0
fi

echo "[`date +"%Y-%m-%d %H:%M:%S"`] Starting Ansible execution..."
ansible-playbook -i inventories/$ENV.yml $PLAYBOOK

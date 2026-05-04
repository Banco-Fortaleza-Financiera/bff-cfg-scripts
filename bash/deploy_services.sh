#!/bin/bash

CURRENT_DIR=$(pwd)/bff-cfg-scripts/docker/java
CURRENT_DIR_ANGULAR=$(pwd)/bff-cfg-scripts/docker/angular
echo "Current directory: $CURRENT_DIR"
echo "Current directory Angular: $CURRENT_DIR_ANGULAR"

echo "Deploying Docker images for BFF services..."

echo "Starting BFF Authentication service..."
docker compose -f $CURRENT_DIR/bff-authentication/bff-authentication-server.yml up -d

echo "Starting BFF Users, Accounts, and Transactions services..."
docker compose -f $CURRENT_DIR/bff-users/bff-users-server.yml up -d

echo "Starting BFF Accounts and Transactions services..."
docker compose -f $CURRENT_DIR/bff-accounts/bff-accounts-server.yml up -d

echo "Starting BFF Transactions service..."
docker compose -f $CURRENT_DIR/bff-transactions/bff-transactions-server.yml up -d

echo "Starting BFF shell and mfa services..."
docker compose -f $CURRENT_DIR_ANGULAR/docker-compose.yml up -d
echo "All BFF services have been deployed successfully."


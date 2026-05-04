#!/bin/bash

CURRENT_DIR=$(pwd)
echo "Current directory: $CURRENT_DIR"

echo "Building Docker images for BFF services..."

echo "Cleaning up previous build artifacts..."
rm -rf $CURRENT_DIR/bff-sp-accounts/build
rm -rf $CURRENT_DIR/bff-ux-accounts/build
rm -rf $CURRENT_DIR/bff-sp-authentication/build
rm -rf $CURRENT_DIR/bff-ux-authentication/build
rm -rf $CURRENT_DIR/bff-sp-transactions/build
rm -rf $CURRENT_DIR/bff-ux-transactions/build
rm -rf $CURRENT_DIR/bff-sp-users/build
rm -rf $CURRENT_DIR/bff-ux-users/build

rm -rf $CURRENT_DIR/bff-sp-accounts/bin
rm -rf $CURRENT_DIR/bff-ux-accounts/bin
rm -rf $CURRENT_DIR/bff-sp-authentication/bin
rm -rf $CURRENT_DIR/bff-ux-authentication/bin
rm -rf $CURRENT_DIR/bff-sp-transactions/bin
rm -rf $CURRENT_DIR/bff-ux-transactions/bin
rm -rf $CURRENT_DIR/bff-sp-users/bin
rm -rf $CURRENT_DIR/bff-ux-users/bin

echo "Building BFF Accounts images..."
cd $CURRENT_DIR/bff-sp-accounts
docker build -t bff-sp-accounts:local .
rm -rf $CURRENT_DIR/bff-sp-accounts/build
rm -rf $CURRENT_DIR/bff-sp-accounts/bin
cd $CURRENT_DIR/bff-ux-accounts
docker build -t bff-ux-accounts:local .
rm -rf $CURRENT_DIR/bff-ux-accounts/build
rm -rf $CURRENT_DIR/bff-ux-accounts/bin

echo "Building BFF Authentication images..."
cd $CURRENT_DIR/bff-sp-authentication
docker build -t bff-sp-authentication:local .
rm -rf $CURRENT_DIR/bff-sp-authentication/build
rm -rf $CURRENT_DIR/bff-sp-authentication/bin
cd $CURRENT_DIR/bff-ux-authentication
docker build -t bff-ux-authentication:local .
rm -rf $CURRENT_DIR/bff-ux-authentication/build
rm -rf $CURRENT_DIR/bff-ux-authentication/bin

echo "Building BFF Transactions images..."
cd $CURRENT_DIR/bff-sp-transactions
docker build -t bff-sp-transactions:local .
rm -rf $CURRENT_DIR/bff-sp-transactions/build
rm -rf $CURRENT_DIR/bff-sp-transactions/bin
cd $CURRENT_DIR/bff-ux-transactions
docker build -t bff-ux-transactions:local .
rm -rf $CURRENT_DIR/bff-ux-transactions/build
rm -rf $CURRENT_DIR/bff-ux-transactions/bin

echo "Building BFF Users images..."
cd $CURRENT_DIR/bff-sp-users
docker build -t bff-sp-users:local .
rm -rf $CURRENT_DIR/bff-sp-users/build
rm -rf $CURRENT_DIR/bff-sp-users/bin
cd $CURRENT_DIR/bff-ux-users
docker build -t bff-ux-users:local .
rm -rf $CURRENT_DIR/bff-ux-users/build
rm -rf $CURRENT_DIR/bff-ux-users/bin

echo "Building BFF Shell Center Page and MFA Users images..."

echo "Building BFF Shell Center Page image..."
cd $CURRENT_DIR/bff-shell-center-page
docker build -t bff-shell-center-page:local .

echo "Building BFF MFA Users image..."
cd $CURRENT_DIR/bff-mfa-users
docker build -t bff-mfa-users:local .

echo "Building BFF MFA Accounts image..."
cd $CURRENT_DIR/bff-mfa-accounts
docker build -t bff-mfa-accounts:local .

echo "Building BFF MFA Transactions image..."
cd $CURRENT_DIR/bff-mfa-transactions
docker build -t bff-mfa-transactions:local .

echo "Docker images for BFF services built successfully!"
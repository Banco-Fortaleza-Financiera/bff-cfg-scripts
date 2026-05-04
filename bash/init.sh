#!/bin/bash
echo "Initializing BFF services deployment..."

echo "Creating Images in Docker 'bff'..."
sh generate_images.sh

echo "Deploying database and redis using Docker Compose..."
sh deploy_database.sh

echo "Deploying BFF services shell and msa using Docker Compose..."
sh deploy_services.sh


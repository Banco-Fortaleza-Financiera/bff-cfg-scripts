echo "Deploying Docker images for BDD and Redis services..."

CURRENT_DIR_BDD=$(pwd)/bff-cfg-scripts/docker/bdd
CURRENT_DIR_REDIS=$(pwd)/bff-cfg-scripts/docker/redis
echo "Current directory BDD: $CURRENT_DIR_BDD"
echo "Current directory BDD: $CURRENT_DIR_REDIS"

echo "Deploying Docker images for BDD services..."

docker compose --env-file $CURRENT_DIR_BDD/.env -f $CURRENT_DIR_BDD/bdd-sql-server.yml up -d

echo "Deploying Docker images for Redis services..."

docker compose --env-file $CURRENT_DIR_REDIS/.env -f $CURRENT_DIR_REDIS/redis-server.yml up -d

echo "All BDD and Redis services have been deployed successfully."

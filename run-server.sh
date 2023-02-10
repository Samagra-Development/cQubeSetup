#!/usr/bin/env bash
mkdir CQUBE
cd CQUBE 
git clone "https://github.com/ChakshuGautam/cQube-POCs.git" ./
cd cQube-POCs
touch .env 
TIMESCALEDB_PORT=3001
PGPOOL_SERV_PORT=3002
IS_YARN=true
while getopts p:q: flag
do
    case "${flag}" in
        p) TIMESCALEDB_PORT=${OPTARG};;
        q) PGPOOL_SERV_PORT=${OPTARG};;
        n) IS_YARN=false;;
    esac
done
echo "TIMESCALEDB_PORT: $TIMESCALEDB_PORT";
echo "PGPOOL_SERV_PORT: $PGPOOL_SERV_PORT";
echo "TIMESCALEDB_PORT="$TIMESCALEDB_PORT"" > .env && echo "PGPOOL_SERV_PORT="$PGPOOL_SERV_PORT"" >> .env
docker-compose up -d
cd impl/c-qube
touch .env && echo "DATABASE_URL="postgres://timescaledb:postgrespassword@localhost:$TIMESCALEDB_PORT/postgres?sslmode=disable"" > .env
if [ $IS_YARN  -eq  true ]
then
  yarn install
  npx prisma migrate dev
  yarn test
else
  npm install
  npx prisma migrate dev
  npm run test
fi
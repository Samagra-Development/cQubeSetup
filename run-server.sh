#!/usr/bin/env bash
mkdir CQUBE
cd CQUBE 
git clone "https://github.com/ChakshuGautam/cQube-POCs.git" ./
cd cQube-POCs
docker-compose up -d
cd impl/c-qube
touch .env && echo "DATABASE_URL="postgres://timescaledb:postgrespassword@localhost:3002/postgres?sslmode=disable"" > .env
yarn install
npx prisma migrate dev
yarn test
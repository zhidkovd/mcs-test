#!/bin/bash

./terraform -chdir=./cloud1 apply -auto-approve
./terraform -chdir=./cloud1 output private_key1 | sed '1d' | sed '$d' >> ./private_key1.pem

./terraform -chdir=./cloud2 apply -auto-approve
./terraform -chdir=./cloud2 output private_key2 | sed '1d' | sed '$d' >> ./private_key2.pem

chmod 400 ./private_key1.pem
chmod 400 ./private_key2.pem


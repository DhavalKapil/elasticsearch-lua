#!/bin/bash

curl -L -o elasticsearch-latest-SNAPSHOT.zip https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.1.zip

unzip "elasticsearch-latest-SNAPSHOT.zip"

./elasticsearch-*/bin/elasticsearch -d

sleep 3

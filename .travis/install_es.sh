#!/bin/bash

curl -L -o elasticsearch-latest-SNAPSHOT.zip https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.3.3/elasticsearch-2.3.3.zip

unzip "elasticsearch-latest-SNAPSHOT.zip"

./elasticsearch-*/bin/elasticsearch -d

sleep 3

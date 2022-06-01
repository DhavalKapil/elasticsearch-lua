#!/bin/bash

echo 'elasticsearch version ' && curl ${CACERT_PATH} ${ELASTIC_CREDS} ${ES_TEST_PROTOCOL}://localhost:${ES_TEST_PORT}/
echo 'Ensure elasticsearch has enough fields configured'
curl -XPUT ${CACERT_PATH} ${ELASTIC_CREDS} "${ES_TEST_PROTOCOL}://localhost:${ES_TEST_PORT}/elasticsearch-lua-reindex-index-2"
curl -XPUT ${CACERT_PATH} ${ELASTIC_CREDS} "${ES_TEST_PROTOCOL}://localhost:${ES_TEST_PORT}/elasticsearch-lua-reindex-index-1"
curl -XPUT ${CACERT_PATH} ${ELASTIC_CREDS} "${ES_TEST_PROTOCOL}://localhost:${ES_TEST_PORT}/elasticsearch-lua-test-index"
curl -XPUT ${CACERT_PATH} ${ELASTIC_CREDS} ${ES_TEST_PROTOCOL}://localhost:${ES_TEST_PORT}/elasticsearch-lua-reindex-index-2/_settings -d '{ "index.mapping.total_fields.limit": 10000 }' -H 'Content-Type:application/json'
curl -XPUT ${CACERT_PATH} ${ELASTIC_CREDS} ${ES_TEST_PROTOCOL}://localhost:${ES_TEST_PORT}/elasticsearch-lua-reindex-index-1/_settings -d '{ "index.mapping.total_fields.limit": 10000 }' -H 'Content-Type:application/json'
curl -XPUT ${CACERT_PATH} ${ELASTIC_CREDS} ${ES_TEST_PROTOCOL}://localhost:${ES_TEST_PORT}/elasticsearch-lua-test-index/_settings -d '{ "index.mapping.total_fields.limit": 10000 }' -H 'Content-Type:application/json'
echo "Finished before_script.sh"

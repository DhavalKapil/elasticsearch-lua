-- A collection of individual operations that will be tested with other components

-- Importing modules
local elasticsearch = require "elasticsearch"
local util = require "lib.util"

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.operations"

-- Declaring module
local operations = {}

local protocol = os.getenv("ES_TEST_PROTOCOL")
if protocol == nil then protocol = "http" end
local port = os.getenv("ES_TEST_PORT")
if port == nil then port = 9200 end
local username = os.getenv("ES_USERNAME")
local password = os.getenv("ES_PASSWORD")

local client  = elasticsearch.client{
   hosts = {
      { -- Ignoring any of the following hosts parameters is allowed.
        -- The default shall be set
        protocol = protocol,
        host = localhost,
        port = port,
        username = username,
        password = password
      }
   }
}

-- Defining test index and type
local TEST_INDEX = "elasticsearch-lua-test-index"
local TEST_TYPE = "_doc"

-- Function to refresh the index
local function refresh(index)
index = index or TEST_INDEX
local res, status = client.indices:refresh()
assert_table(res)
assert_equal(200, status)
end

function operations.info()
-- Testing info
local res, status = client:info()
assert_not_nil(res)
assert_equal(200, status)
end

function operations.index(data)
   -- Indexing all data in elasticsearch
   for _, v in ipairs(data) do
      local res, status = client:index{
         index = TEST_INDEX,
         type = TEST_TYPE,
         id = v["id"],
         body = v
      }
      assert_not_nil(res)
      assert_equal("created", res.result)
      assert_true(status == 200 or status == 201)
   end
end

function operations.createExistingDocuments(data)
   -- Trying to create documents
   for _, v in ipairs(data) do
      local res, err = client:create{
         index = TEST_INDEX,
         type = TEST_TYPE,
         id = v["id"],
         body = v
      }
      assert_nil(res)
      assert_equal("ClientError: Invalid response code: 409", err)
   end
end

function operations.createNonExistingDocuments(data)
   -- Creating new documents
   for _, v in ipairs(data) do
      local res, status = client:create{
         index = TEST_INDEX,
         type = TEST_TYPE,
         id = v["id"],
         body = v
      }
      assert_not_nil(res)
      assert_equal("created", res.result)
      assert_equal(201, status)
   end
end

function operations.deleteExistingDocuments(data, index)
   index = index or TEST_INDEX
   -- Deleting documents
   for _, v in ipairs(data) do
      local res, status = client:delete{
         index = index,
         type = TEST_TYPE,
         id = v["id"]
      }
      assert_not_nil(res)
      assert_equal(200, status)
   end
end

function operations.deleteNonExistingDocuments(data)
   for _, v in ipairs(data) do
      local res, err = client:delete{
         index = TEST_INDEX,
         type = TEST_TYPE,
         id = v["id"]
      }
      assert_nil(res)
      assert_equal("ClientError: Invalid response code: 404", err)
   end
end

function operations.existsExistingDocuments(data)
   for _, v in ipairs(data) do
      local res, status = client:exists{
         index = TEST_INDEX,
         type = TEST_TYPE,
         id = v["id"]
      }
      assert_true(res)
      assert_equal(200, status)
   end
end

function operations.existsNonExistingDocuments(data)
   for _, v in ipairs(data) do
      local res, err = client:exists{
         index = TEST_INDEX,
         type = TEST_TYPE,
         id = v["id"]
      }
      assert_false(res)
      assert_nil(err)
   end
end

function operations.getExistingDocuments(data, index)
   index = index or TEST_INDEX
   for _, v in ipairs(data) do
      local res, status = client:get{
         index = index,
         type = TEST_TYPE,
         id = v["id"]
      }
      assert_not_nil(res)
      assert_equal(200, status)
      util.check(v, res._source)
   end
end

function operations.getNonExistingDocuments(data, index)
   index = index or TEST_INDEX
   for _, v in ipairs(data) do
      local res, err = client:get{
         index = index,
         type = TEST_TYPE,
         id = v["id"]
      }
      assert_nil(res)
      assert_equal("ClientError: Invalid response code: 404", err)
   end
end

function operations.mgetExistingDocuments(data)
   local docs = {}
   for _, v in ipairs(data) do
      table.insert(docs, {
                      ["_index"] = TEST_INDEX,
                      ["_type"] = TEST_TYPE,
                      ["_id"] = v["id"]
      })
   end
   local res, status = client:mget{
      body = {
         docs = docs
      }
   }
   assert_not_nil(res)
   assert_equal(200, status)
   local result_data = {}
   for _, v in ipairs(res.docs) do
      table.insert(result_data, v._source)
   end
   util.check(data, result_data)
end

function operations.mgetNonExistingDocuments(data)
   local docs = {}
   for _, v in ipairs(data) do
      table.insert(docs, {
                      ["_index"] = TEST_INDEX,
                      ["_type"] = TEST_TYPE,
                      ["_id"] = v["id"]
      })
   end
   local res, status = client:mget{
      body = {
         docs = docs
      }
   }
   
   for _, v in ipairs(res.docs) do
      assert_false(v.found)
   end
   assert_equal(200, status)
end

function operations.bulkIndex(data, index)
   index = index or TEST_INDEX
   -- Creating bulk body
   local bulkBody = {}
   for _, v in ipairs(data) do
      -- Specifing that it is an index operation
      bulkBody[#bulkBody + 1] = {
         index = {
            ["_index"] = index,
            ["_type"] = TEST_TYPE,
            ["_id"] = v["id"]
         }
      }
      -- Actual body
      bulkBody[#bulkBody + 1] = v
   end
   
   -- Indexing all data in a single bulk operation
   local res, status = client:bulk{
      body = bulkBody
   }
   assert_not_nil(res)
   assert_equal(200, status)
end

function operations.bulkDeleteExistingDocuments(data, index)
   index = index or TEST_INDEX
   -- Creating bulk body
   local bulkBody = {}
   for _, v in ipairs(data) do
      -- Specifying that it is a delete operation
      bulkBody[#bulkBody + 1] = {
         delete = {
            ["_index"] = index,
            ["_type"] = TEST_TYPE,
            ["_id"] = v["id"]
         }
      }
   end
   
   -- Deleting all data in a single bulk operation
   local res, status = client:bulk{
      body = bulkBody
   }
   assert_not_nil(res)
   assert_equal(200, status)
end

function operations.bulkDeleteNonExistingDocuments(data)
   -- Creating bulk body
   local bulkBody = {}
   for _, v in ipairs(data) do
      -- Specifying that it is a delete operation
      bulkBody[#bulkBody + 1] = {
         delete = {
            ["_index"] = index,
            ["_type"] = TEST_TYPE,
            ["_id"] = v["id"]
         }
      }
   end
   
   -- Trying to delete all data in a single bulk operation
   local res, err = client:bulk{
      body = bulkBody
   }
   assert_nil(res)
   assert_equal("ClientError: Invalid response code: 400", err)
end

function operations.searchQuery(query, index)
   index = index or TEST_INDEX
   refresh()
   local res, status = client:search{
      index = index,
      type = TEST_TYPE,
      q = query
   }
   assert_not_nil(res)
   assert_equal(200, status)
   return res
end

function operations.searchBody(body, index)
   index = index or TEST_INDEX
   refresh()
   local res, status = client:search{
      index = index,
      type = TEST_TYPE,
      body = body
   }
   if res == nil then
      print(status)
   end
   assert_not_nil(res)
   assert_equal(200, status)
   return res
end

function operations.searchTemplate(body)
   refresh()
   local res, status = client:searchTemplate{
      index = TEST_INDEX,
      type = TEST_TYPE,
      body = body
   }
   assert_not_nil(res)
   assert_equal(200, status)
   return res
end

function operations.searchScan(body)
   refresh()
   local res, status = client:search{
      index = TEST_INDEX,
      type = TEST_TYPE,
      scroll = "1m",
      body = body
   }
   assert_not_nil(res)
   assert_equal(200, status)
   return res
end

function operations.scroll(scroll_id)
   local res, status = client:scroll{
      scroll = "2m",
      scroll_id = scroll_id
   }
   assert_not_nil(res)
   assert_equal(200, status)
   return res
end

function operations.reindex(source_index, target_index, query)
   refresh()
   local res, err = elasticsearch.helpers.reindex(client,
                                                  source_index,
                                                  target_index,
                                                  query)
   assert_true(res)
   assert_nil(err)
end

return operations;

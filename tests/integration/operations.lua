-- A collection of individual operations that will be tested with other components

-- Importing modules
local elasticsearch = require "elasticsearch"

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.operations"

-- Declaring module
local operations = {}

local client  = elasticsearch.client()

-- Defining test index and type
local TEST_INDEX = "elasticsearch-lua-test-index"
local TEST_TYPE = "elasticsearch-lua-test-type"

function operations.info()
  -- Testing info
  local res, status = client:info()
  assert_not_nil(res)
  assert_equal(200, status)
end

function operations.index(data)
  -- Indexing all data in elasticsearch
  for i = 1, #data do
    local res, status = client:index{
      index = TEST_INDEX,
      type = TEST_TYPE,
      id = data[i]["id"],
      body = data[i]
    }
    assert_not_nil(res)
    assert_true(status == 200 or status == 201)
  end
end

function operations.getExistingDocuments(data)
  for i = 1, #data do
    local res, status = client:get{
      index = TEST_INDEX,
      type = TEST_TYPE,
      id = data[i]["id"]
    }
    assert_not_nil(res)
    assert_equal(200, status)
    util.check(data[i], res._source)
  end
end

function operations.delete(data)
  -- Deleting documents
  for i = 1, #data do
    local res, status = client:delete{
      index = TEST_INDEX,
      type = TEST_TYPE,
      id = data[i]["id"],
    }
    assert_not_nil(res)
    assert_equal(200, status)
  end
end

function operations.getNonExistingDocuments(data)
  for i = 1, #data do
    local res, err = client:get{
      index = TEST_INDEX,
      type = TEST_TYPE,
      id = data[i]["id"]
    }
    assert_nil(res)
    assert_equal("ClientError: Invalid response code: 404", err)
  end
end

function operations.bulkIndex(data)
  -- Creating bulk body
  local bulkBody = {}
  for i = 1, #data do
    -- Specifing that it is an index operation
    bulkBody[#bulkBody + 1] = {
      index = {
        ["_index"] = TEST_INDEX,
        ["_type"] = TEST_TYPE,
        ["_id"] = data[i]["id"]
      }
    }
    -- Actual body
    bulkBody[#bulkBody + 1] = data[i]
  end

  -- Indexing all data in a single bulk operation
  local res, status = client:bulk{
    body = bulkBody
  }
  -- Wait for some time to index
  local ntime = os.time() + 1
  repeat until os.time() > ntime
  assert_not_nil(res)
  assert_equal(200, status)
end

function operations.bulkDelete(data)
  -- Creating bulk body
  local bulkBody = {}
  for i = 1, #data do
    -- Specifying that it is a delete operation
    bulkBody[#bulkBody + 1] = {
      delete = {
        ["_index"] = TEST_INDEX,
        ["_type"] = TEST_TYPE,
        ["_id"] = data[i]["id"]
      }
    }
  end

  -- Deleting all data in a single bulk operation
  local res, status = client:bulk{
    body = bulkBody
  }
  -- Wait for some time to index
  local ntime = os.time() + 1
  repeat until os.time() > ntime
  assert_not_nil(res)
  assert_equal(200, status)
end

function operations.searchQuery(query)
  local res, status = client:search{
    index = TEST_INDEX,
    type = TEST_TYPE,
    q = query
  }
  assert_not_nil(res)
  assert_equal(200, status)
  return res
end

function operations.searchBody(body)
  local res, status = client:search{
    index = TEST_INDEX,
    type = TEST_TYPE,
    body = body
  }
  assert_not_nil(res)
  assert_equal(200, status)
  return res
end

return operations;

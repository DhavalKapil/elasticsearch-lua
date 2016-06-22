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
  for _, v in ipairs(data) do
    local res, status = client:index{
      index = TEST_INDEX,
      type = TEST_TYPE,
      id = v["id"],
      body = v
    }
    assert_not_nil(res)
    assert_true(status == 200 or status == 201)
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

function operations.delete(data, index)
  index = index or TEST_INDEX
  -- Deleting documents
  for _, v in ipairs(data) do
    local res, status = client:delete{
      index = index,
      type = TEST_TYPE,
      id = v["id"],
    }
    assert_not_nil(res)
    assert_equal(200, status)
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

function operations.bulkDelete(data, index)
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

function operations.searchQuery(query, index)
  index = index or TEST_INDEX
  -- Wait for some time for the index operation to take place
  local ntime = os.time() + 5
  repeat until os.time() > ntime
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
  -- Wait for some time for the index operation to take place
  local ntime = os.time() + 5
  repeat until os.time() > ntime
  local res, status = client:search{
    index = index,
    type = TEST_TYPE,
    body = body
  }
  assert_not_nil(res)
  assert_equal(200, status)
  return res
end

function operations.searchScan(body)
  -- Wait for some time for the index operation to take place
  local ntime = os.time() + 5
  repeat until os.time() > ntime
  local res, status = client:search{
    index = TEST_INDEX,
    type = TEST_TYPE,
    search_type = "scan",
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
  -- Wait for some time for the index operation to take place
  local ntime = os.time() + 5
  repeat until os.time() > ntime
  local res, err = elasticsearch.helpers.reindex(client,
                                                 source_index,
                                                 target_index,
                                                 query)
  assert_true(res)
  assert_nil(err)
end

return operations;

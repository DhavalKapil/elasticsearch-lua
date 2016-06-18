-- Tests:
--   info()
--   index()
--   get()
--   delete()

-- Importing modules
local elasticsearch = require "elasticsearch"
local util = require "lib.util"

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.BasicTest"

local client  = elasticsearch.client()


function info()
  -- Testing info
  local res, status = client:info()
  assert_not_nil(res)
  --assert_equal(200, status)
end

function index(data)
  -- Indexing all data in elasticsearch
  for i = 1, #data do
    local res, status = client:index{
      index = "test_index",
      type = "my_type",
      id = data[i]["id"],
      body = data[i]
    }
    assert_not_nil(res)
    assert_true(status == 200 or status == 201)
  end
end

function getExistingDocuments(data)
  -- Testing whether data is in elasticsearch by choosing random points 50 times
  math.randomseed(os.time())
  for i = 1, 50 do
    local ii = math.random(1, #data)
    local res, status = client:get{
      index = "test_index",
      type = "my_type",
      id = data[i]["id"]
    }
    assert_not_nil(res)
    assert_equal(200, status)
    util.check(data[i], res._source)
  end
end

function delete(data)
  -- Deleting documents
  for i = 1, #data do
    local res, status = client:delete{
      index = "test_index",
      type = "my_type",
      id = data[i]["id"],
    }
    assert_not_nil(res)
    assert_equal(200, status)
  end
end

function getNonExistingDocuments(data)
  -- Testing whether data is in elasticsearch by choosing random points 50 times
  math.randomseed(os.time())
  for i = 1, 50 do
    local i = math.random(1, #data)
    local res, err = client:get{
      index = "test_index",
      type = "my_type",
      id = data[i]["id"]
    }
    assert_nil(res)
    assert_equal("ClientError: Invalid response code: 404", err)
  end
end

function test()
  local dataset = require "integration.dataset.dataset"
  local dataset_1 = util.slice(dataset, 1, #dataset/2)
  local dataset_2 = util.slice(dataset, #dataset/2 + 1, #dataset)
  info()
  index(dataset_1)
  getNonExistingDocuments(dataset_2)
  getExistingDocuments(dataset_1)
  index(dataset_2)
  delete(dataset_1)
  getNonExistingDocuments(dataset_1)
  getExistingDocuments(dataset_2)
  delete(dataset_2)
  getNonExistingDocuments(dataset_2)
end

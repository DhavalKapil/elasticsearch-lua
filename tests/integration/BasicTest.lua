-- Importing modules
local elasticsearch = require "elasticsearch"
local dataset = require "integration.dataset"
local util = require "lib.util"

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.BasicTest"

local client  = elasticsearch.client()

function info()
  -- Testing info
  local res, err = client:info()
  assert_not_nil(res)
end

function index()
  -- Indexing all data in elasticsearch
  for i = 1, #dataset do
    res, err = client:index{
      index = "test_index",
      type = "my_type",
      id = i,
      body = dataset[i]
    }
    assert_not_nil(res)
  end
end

function get()
  -- Testing whether data is in elasticsearch by choosing random points 50 times
  math.randomseed(os.time())
  for i = 1, 50 do
    local id = math.random(1, #dataset)
    res, err = client:get{
      index = "test_index",
      type = "my_type",
      id = id
    }
    assert_not_nil(res)
    util.check(dataset[id], res._source)
  end
end

function test()
  info()
  index()
  get()
end

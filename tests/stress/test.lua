local elasticsearch = require "elasticsearch"
local dataset = require "dataset.dataset"

local client = elasticsearch.client()

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.stress.test"

function test()
  local res, status = client:index{
    index = "my_index",
    type = "my_type",
    id = "my_id",
    body = dataset[1]
  }

  assert_not_nil(res)
  assert_true(res.created)
  assert_true(status == 200 or status == 201)
end

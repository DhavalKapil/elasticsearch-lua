--  Tests:
--    search()
--

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.SearchTest"

function test()
  operations.bulkIndex(dataset)
  local res = operations.searchQuery("type:PushEvent")
  assert_equal(103, res.hits.total)
  local res = operations.searchBody{
    query = {
      match = {
        type = "PushEvent"
      }
    }
  }
  assert_equal(103, res.hits.total)
  operations.bulkDelete(dataset)
end

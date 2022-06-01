--  Tests:
--    search()
--

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.SearchTest"

function test()
  operations.bulkIndex(dataset)

  -- Simple query search
  local res = operations.searchQuery("type:PushEvent")
  if type(res.hits.total) == "table"
  then
     assert_equal(103, res.hits.total.value) -- EL7+ returns hits as a table
  else
     assert_equal(103, res.hits.total)
  end

  -- Simple body search
  local res = operations.searchBody{
    query = {
      match = {
        type = "PushEvent"
      }
    }
  }
  if type(res.hits.total) == "table"
  then
     assert_equal(103, res.hits.total.value)
  else
     assert_equal(103, res.hits.total)
  end

  -- Aggregation search
  local res = operations.searchBody{
    aggs = {
      maxActorId = {
        max = {
          field = "actor.id"
        }
      }
    }
  }
  assert_equal(10364741.0, res.aggregations.maxActorId.value)

  -- Regex Search
  local res = operations.searchBody{
    query = {
      regexp = {
        type = {
          value = "pusheven."
        }
      }
    }
  }
  if type(res.hits.total) == "table"
  then
     assert_equal(103, res.hits.total.value)
  else
     assert_equal(103, res.hits.total)
  end

  -- Search template
  local res = operations.searchTemplate{
    inline = {
      query = {
        match = {
          type = "{{query_string}}"
        }
      }
    },
    params = {
      query_string = "PushEvent"
    }
  }
  if type(res.hits.total) == "table"
  then
     assert_equal(103, res.hits.total.value)
  else
     assert_equal(103, res.hits.total)
  end

  operations.bulkDeleteExistingDocuments(dataset)
end

--  Tests:
--    search()
--

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.SearchTest"

function test()
  operations.bulkIndex(dataset)

  -- Simple query search
  local res = operations.searchQuery("type:PushEvent")
  assert_equal(103, res.hits.total)

  -- Simple body search
  local res = operations.searchBody{
    query = {
      match = {
        type = "PushEvent"
      }
    }
  }
  assert_equal(103, res.hits.total)

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
  assert_equal(103, res.hits.total)

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
  assert_equal(103, res.hits.total)

  operations.bulkDelete(dataset)
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))    
    else
      print(formatting .. tostring(v))
    end
  end
end
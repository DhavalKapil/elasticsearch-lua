--  Tests:
--    reindex()
--

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.ReindexTest"

local index1 = "elasticsearch-lua-reindex-index-1"
local index2 = "elasticsearch-lua-reindex-index-2"

function test()
  local dataset_1 = util.subarr(dataset, 1, math.floor(#dataset/2))
  local dataset_2 = util.subarr(dataset, math.floor(#dataset/2) + 1, #dataset)
  local searchBody = {
    query = {
      match = {
        type = "PushEvent"
      }
    }
  }
  
  operations.bulkDeleteExistingDocuments(dataset, index1)
  operations.bulkDeleteExistingDocuments(dataset, index2)
  operations.bulkIndex(dataset_1, index1)
  operations.getNonExistingDocuments(dataset_1, index2)
  operations.reindex(index1, index2)
  operations.getExistingDocuments(dataset_1, index2)
  operations.bulkIndex(dataset_2, index1)
  operations.getNonExistingDocuments(dataset_2, index2)
  operations.reindex(index1, index2, searchBody)
  local res = operations.searchBody(searchBody, index2)
  if type(res.hits.total) == "table"
  then
     assert_equal(103, res.hits.total.value)
  else
     assert_equal(103, res.hits.total)
  end
  operations.reindex(index1, index2)
  operations.getExistingDocuments(dataset, index2)
  operations.bulkDeleteExistingDocuments(dataset, index1)
  operations.bulkDeleteExistingDocuments(dataset, index2)
end

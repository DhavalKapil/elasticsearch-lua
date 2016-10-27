--  Tests:
--    bulk()
--

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.BulkTest"

function test()
  local dataset_1 = util.subarr(dataset, 1, math.floor(#dataset/2))
  local dataset_2 = util.subarr(dataset, math.floor(#dataset/2) + 1, #dataset)
  operations.bulkIndex(dataset_1)
  operations.bulkIndex(dataset_2)
  operations.getExistingDocuments(dataset_1)
  operations.getExistingDocuments(dataset_2)
  operations.bulkDeleteExistingDocuments(dataset_1)
  operations.getNonExistingDocuments(dataset_1)
  operations.bulkDeleteNonExistingDocuments(dataset_1)
  operations.getExistingDocuments(dataset_2)
  operations.bulkDeleteExistingDocuments(dataset_2)
  operations.getNonExistingDocuments(dataset_2)
  operations.bulkDeleteNonExistingDocuments(dataset_2)
end

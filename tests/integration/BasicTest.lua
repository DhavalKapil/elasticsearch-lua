--  Tests:
--    info()
--    exists()
--    index()
--    get()
--    delete()
--    mget()
-- 

-- Importing modules
local util = require "lib.util"

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.BasicTest"

function test()
  local dataset_1 = util.subarr(dataset, 1, math.floor(#dataset/2))
  local dataset_2 = util.subarr(dataset, math.floor(#dataset/2) + 1, #dataset)
  operations.info()

  operations.index(dataset_1)
  operations.createExistingDocuments(dataset_1)

  operations.existsNonExistingDocuments(dataset_2)
  operations.getNonExistingDocuments(dataset_2)
  operations.mgetNonExistingDocuments(dataset_2)
  operations.deleteNonExistingDocuments(dataset_2)

  operations.existsExistingDocuments(dataset_1)
  operations.getExistingDocuments(dataset_1)
  operations.mgetExistingDocuments(dataset_1)

  operations.index(dataset_2)
  operations.createExistingDocuments(dataset_2)
  operations.deleteExistingDocuments(dataset_1)

  operations.existsNonExistingDocuments(dataset_1)
  operations.getNonExistingDocuments(dataset_1)
  operations.mgetNonExistingDocuments(dataset_1)
  operations.deleteNonExistingDocuments(dataset_1)

  operations.existsExistingDocuments(dataset_2)
  operations.getExistingDocuments(dataset_2)
  operations.mgetExistingDocuments(dataset_2)

  operations.deleteExistingDocuments(dataset_2)

  operations.createNonExistingDocuments(dataset_2)
  operations.getExistingDocuments(dataset_2)
  operations.mgetExistingDocuments(dataset_2)

  operations.deleteExistingDocuments(dataset_2)

  operations.existsNonExistingDocuments(dataset_2)
  operations.getNonExistingDocuments(dataset_2)
  operations.mgetNonExistingDocuments(dataset_2)
  operations.deleteNonExistingDocuments(dataset_2)
end

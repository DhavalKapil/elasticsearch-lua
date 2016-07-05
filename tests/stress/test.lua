local dataset = require "dataset.dataset"

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.stress.test"

-- The number of simultaneous clients
local CLIENTS_COUNT = 10
-- The number of times to iterate and get
local N = 3

local operationsList = {}

function setup()
  for i = 1, CLIENTS_COUNT do
    local operations = dofile "lib/operations.lua"
    table.insert(operationsList, operations)
  end
  operationsList[1].bulkDeleteExistingDocuments(dataset)
end

-- Tests repeated index, get, delete
function test()
  for i = 1, N do
    print("Iteration no: " .. i)
    for _, operations in ipairs(operationsList) do
      operations.index(dataset)
      operations.getExistingDocuments(dataset)
      operations.deleteExistingDocuments(dataset)
      operations.getNonExistingDocuments(dataset)
      os.execute("sleep 1")
    end
  end
end

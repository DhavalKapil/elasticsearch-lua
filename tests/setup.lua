-- Importing modules
local elasticsearch = require "elasticsearch"

local _ENV = lunit.TEST_CASE "tests.setup"

-- Declaring module
local setup = {}

local protocol = os.getenv("ES_TEST_PROTOCOL")
if protocol == nil then protocol = "http" end
local port = os.getenv("ES_TEST_PORT")
if port == nil then port = 9200 end
local username = os.getenv("ES_USERNAME")
local password = os.getenv("ES_PASSWORD")

local client  = elasticsearch.client{
   hosts = {
      { -- Ignoring any of the following hosts parameters is allowed.
        -- The default shall be set
        protocol = protocol,
        host = localhost,
        port = port,
        username = username,
        password = password
      }
   }
}

-- Defining test index and type
local TEST_INDEX = "elasticsearch-lua-test-index"
local REINDEX_INDEX1 = "elasticsearch-lua-reindex-index-1"
local REINDEX_INDEX2 = "elasticsearch-lua-reindex-index-2"

function setup.init()
   local res, err = client.indices:create{
      index = TEST_INDEX
   }
      
   res, status = client.indices:create{
      index = REINDEX_INDEX1
   }

   res, status = client.indices:create{
      index = REINDEX_INDEX2
   }

   res, status = client.indices:putSettings{
      index = _all,
      body = {
         index = {
            mapping = {
               total_fields = {
                  limit = 10000
               }
            }
         }
      }
   }
end

return setup;

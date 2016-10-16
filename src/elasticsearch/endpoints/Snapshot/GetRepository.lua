-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local CreateRepository = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
CreateRepository.allowedParams = {
  ["master_timeout"] = true,
  ["local"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function CreateRepository:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function CreateRepository:getUri()
  local uri = "/_snapshot"
  if self.repository ~= nil then
    uri = uri .. "/" .. self.repository
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of CreateRepository class
-------------------------------------------------------------------------------
function CreateRepository:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return CreateRepository

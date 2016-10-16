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
  ["timeout"] = true,
  ["verify"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function CreateRepository:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function CreateRepository:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Create Repository"
  end
  local uri = "/_snapshot/" .. self.repository
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

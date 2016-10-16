-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local DeleteRepository = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
DeleteRepository.allowedParams = {
  ["master_timeout"] = true,
  ["timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function DeleteRepository:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function DeleteRepository:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Delete Repository"
  end
  local uri = "/_snapshot/" .. self.repository
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of DeleteRepository class
-------------------------------------------------------------------------------
function DeleteRepository:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return DeleteRepository

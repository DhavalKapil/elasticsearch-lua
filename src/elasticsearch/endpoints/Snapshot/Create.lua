-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Create = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Create.allowedParams = {
  ["master_timeout"] = true,
  ["wait_for_completion"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Create:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Create:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Create"
  elseif self.snapshot == nil then
    return nil, "snapshot not specified for Create"
  end
  local uri = "/_snapshot/" .. self.repository .. "/" .. self.snapshot
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Create class
-------------------------------------------------------------------------------
function Create:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Create

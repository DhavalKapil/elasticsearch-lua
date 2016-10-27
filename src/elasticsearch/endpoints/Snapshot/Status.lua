-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Status = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Status.allowedParams = {
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Status:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Status:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Status"
  end

  local uri = "/_snapshot/" .. self.repository
  if self.snapshot ~= nil then
    uri = uri .. "/" .. self.snapshot
  end
  uri = uri .. "/_status"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Status class
-------------------------------------------------------------------------------
function Status:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Status

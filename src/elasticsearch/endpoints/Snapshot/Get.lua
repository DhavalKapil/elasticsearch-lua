-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Get = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Get.allowedParams = {
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Get:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Get:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Get"
  elseif self.snapshot == nil then
    return nil, "snapshot not specified for Get"
  end
  local uri = "/_snapshot/" .. self.repository .. "/" .. self.snapshot
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Get class
-------------------------------------------------------------------------------
function Get:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Get

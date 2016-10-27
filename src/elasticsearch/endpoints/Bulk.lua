-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Bulk = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- Bulk body is present for Bulk
Bulk.bulkBody = true

-- The parameters that are allowed to be used in params
Bulk.allowedParams = {
  ["consistency"] = true,
  ["refresh"] = true,
  ["replication"] = true,
  ["type"] = true,
  ["fields"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Bulk:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Bulk:getUri()
  local uri = "/_bulk"
  if self.index ~= nil and self.type ~= nil then
    uri = "/" .. self.index .. "/" .. self.type .. uri
  elseif self.index ~= nil then
    uri = "/" .. self.index .. uri
  elseif self.type ~= nil then
    uri = "/_all/" .. self.type .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Bulk class
-------------------------------------------------------------------------------
function Bulk:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Bulk

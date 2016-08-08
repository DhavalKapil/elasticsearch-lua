-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local MTermVectors = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
MTermVectors.allowedParams = {
  ["ids"] = true,
  ["term_statistics"] = true,
  ["field_statistics"] = true,
  ["fields"] = true,
  ["offsets"] = true,
  ["positions"] = true,
  ["payloads"] = true,
  ["preference"] = true,
  ["routing"] = true,
  ["parent"] = true,
  ["realtime"] = true,
  ["version"] = true,
  ["version_type"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function MTermVectors:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function MTermVectors:getUri()
  local uri = "/_mtermvectors"
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
-- Returns an instance of MTermVectors class
-------------------------------------------------------------------------------
function MTermVectors:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return MTermVectors

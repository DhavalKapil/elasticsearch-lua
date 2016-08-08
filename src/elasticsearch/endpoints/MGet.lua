-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local MGet = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
MGet.allowedParams = {
  ["fields"] = true,
  ["preference"] = true,
  ["realtime"] = true,
  ["refresh"] = true,
  ["routing"] = true,
  ["_source"] = true,
  ["_source_exclude"] = true,
  ["_source_include"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function MGet:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function MGet:getUri()
  local uri = "/_mget"
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
-- Returns an instance of MGet class
-------------------------------------------------------------------------------
function MGet:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return MGet

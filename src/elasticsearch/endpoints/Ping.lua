-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Ping = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Ping.allowedParams = {
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Ping:getMethod()
  return "HEAD"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Ping:getUri()
  return "/"
end

-------------------------------------------------------------------------------
-- Returns an instance of Ping class
-------------------------------------------------------------------------------
function Ping:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Ping

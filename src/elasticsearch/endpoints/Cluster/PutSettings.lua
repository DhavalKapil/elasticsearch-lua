-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PutSettings = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PutSettings.allowedParams = {
  ["flat_settings"] = true,
  ["master_timeout"] = true,
  ["timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PutSettings:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PutSettings:getUri()
  return "/_cluster/settings"
end

-------------------------------------------------------------------------------
-- Returns an instance of PutSettings class
-------------------------------------------------------------------------------
function PutSettings:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PutSettings

-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetSettings = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetSettings.allowedParams = {
  ["flat_settings"] = true,
  ["master_timeout"] = true,
  ["timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function GetSettings:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function GetSettings:getUri()
  return "/_cluster/settings"
end

-------------------------------------------------------------------------------
-- Returns an instance of GetSettings class
-------------------------------------------------------------------------------
function GetSettings:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return GetSettings

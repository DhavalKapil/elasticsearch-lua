-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Reroute = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Reroute.allowedParams = {
  ["dry_run"] = true,
  ["filter_metadata"] = true,
  ["master_timeout"] = true,
  ["timeout"] = true,
  ["explain"] = true,
  ["metric"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Reroute:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Reroute:getUri()
  return "/_cluster/reroute"
end

-------------------------------------------------------------------------------
-- Returns an instance of Reroute class
-------------------------------------------------------------------------------
function Reroute:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Reroute

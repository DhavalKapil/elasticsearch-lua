-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ReIndex = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
ReIndex.allowedParams = {
  ["refresh"] = true,
  ["timeout"] = true,
  ["consistency"] = true,
  ["wait_for_completion"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function ReIndex:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function ReIndex:getUri()
  local uri = "/_reindex"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of ReIndex class
-------------------------------------------------------------------------------
function ReIndex:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ReIndex

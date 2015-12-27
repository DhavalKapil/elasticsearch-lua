-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Status = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Status.allowedParams = {
  "ignore_unavailable",
  "allow_no_indices",
  "expand_wildcards",
  "human",
  "operation_threading",
  "recovery",
  "snapshot"
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
  local uri = "/_status"
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
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

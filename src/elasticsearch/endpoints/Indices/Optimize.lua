-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Optimize = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Optimize.allowedParams = {
  "flush",
  "ignore_unavailable",
  "allow_no_indices",
  "expand_wildcards",
  "max_num_segments",
  "only_expunge_deletes",
  "operation_threading",
  "wait_for_merge"
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Optimize:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Optimize:getUri()
  local uri = "/_optimize"
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Optimize class
-------------------------------------------------------------------------------
function Optimize:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Optimize

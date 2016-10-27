-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local CountPercolate = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
CountPercolate.allowedParams = {
  ["routing"]= true,
  ["preference"]= true,
  ["ignore_unavailable"]= true,
  ["allow_no_indices"]= true,
  ["expand_wildcards"]= true,
  ["percolate_index"]= true,
  ["percolate_type"]= true,
  ["version"]= true,
  ["version_type"]= true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function CountPercolate:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function CountPercolate:getUri()
  if self.index == nil then
    return nil, "index not specified for CountPercolate"
  end
  if self.type == nil then
    return nil, "type not specified for CountPercolate"
  end
  local uri = "/" .. self.index .. "/" .. self.type
  if self.id ~= nil then
    uri = uri .. "/" .. self.id
  end
  uri = uri .. "/_percolate/count"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of CountPercolate class
-------------------------------------------------------------------------------
function CountPercolate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return CountPercolate

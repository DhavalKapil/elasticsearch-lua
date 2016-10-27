-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local DeleteByQuery = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
DeleteByQuery.allowedParams = {
  ["q"] = true,
  ["consistency"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["replication"] = true,
  ["size"] = true,
  ["source"] = true,
  ["timeout"] = true,
  ["routing"] = true,
  ["df"] = true,
  ["analyzer"] = true,
  ["default_operator"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function DeleteByQuery:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function DeleteByQuery:getUri()
  if self.index == nil then
    return nil, "index not specified for CountPercolate"
  end
  local uri = "/" .. self.index
  if self.type ~= nil then
    uri = uri .. "/" .. self.type
  end
  uri = uri .. "/_query"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of DeleteByQuery class
-------------------------------------------------------------------------------
function DeleteByQuery:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return DeleteByQuery

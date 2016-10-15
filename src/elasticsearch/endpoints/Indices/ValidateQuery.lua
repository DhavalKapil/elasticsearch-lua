-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ValidateQuery = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
ValidateQuery.allowedParams = {
  ["explain"] = true,
  ["ignore_unavailable"] = true,
  ["ignore_indices"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["operation_threading"] = true,
  ["source"] = true,
  ["q"] = true,
  ["analyzer"] = true,
  ["analyze_wildcard"] = true,
  ["default_operator"] = true,
  ["df"] = true,
  ["lenient"] = true,
  ["lowercase_expanded_terms"] = true,
  ["rewrite"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function ValidateQuery:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function ValidateQuery:getUri()
  local uri = "/_validate/query"

  if self.type ~= nil then
    uri = "/" .. self.type .. uri
  end
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of ValidateQuery class
-------------------------------------------------------------------------------
function ValidateQuery:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ValidateQuery

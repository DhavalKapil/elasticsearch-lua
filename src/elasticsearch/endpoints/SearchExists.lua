-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local SearchExists = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
SearchExists.allowedParams = {
  ["analyzer"] = true,
  ["analyze_wildcard"] = true,
  ["default_operator"] = true,
  ["df"] = true,
  ["explain"] = true,
  ["fields"] = true,
  ["from"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["indices_boost"] = true,
  ["lenient"] = true,
  ["lowercase_expanded_terms"] = true,
  ["preference"] = true,
  ["q"] = true,
  ["routing"] = true,
  ["scroll"] = true,
  ["search_type"] = true,
  ["size"] = true,
  ["sort"] = true,
  ["source"] = true,
  ["_source"] = true,
  ["_source_exclude"] = true,
  ["_source_include"] = true,
  ["stats"] = true,
  ["suggest_field"] = true,
  ["suggest_mode"] = true,
  ["suggest_size"] = true,
  ["suggest_text"] = true,
  ["timeout"] = true,
  ["version"] = true,
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function SearchExists:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function SearchExists:getUri()
  if self.index ~= nil and self.type ~= nil then
    return "/" .. self.index .. "/" .. self.type .. "/_search/exists"
  elseif self.index ~= nil and self.type == nil then
    return "/" .. self.index .. "/_search/exists"
  elseif self.index == nil and self.type ~= nil then
    return "/_all/" .. self.type .. "/_search/exists"
  end
  -- Both are nil
  return "/_search/exists"
end

-------------------------------------------------------------------------------
-- Returns an instance of SearchExists class
-------------------------------------------------------------------------------
function SearchExists:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return SearchExists

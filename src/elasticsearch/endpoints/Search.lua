-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Search = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Search.allowedParams = {
  "analyzer",
  "analyze_wildcard",
  "default_operator",
  "df",
  "explain",
  "fields",
  "from",
  "ignore_unavailable",
  "allow_no_indices",
  "expand_wildcards",
  "indices_boost",
  "lenient",
  "lowercase_expanded_terms",
  "preference",
  "q",
  "routing",
  "scroll",
  "search_type",
  "size",
  "sort",
  "source",
  "_source",
  "_source_exclude",
  "_source_include",
  "stats",
  "suggest_field",
  "suggest_mode",
  "suggest_size",
  "suggest_text",
  "timeout",
  "version",
  "request_cache"
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Search:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Search:getUri()
  if self.index ~= nil and self.type ~= nil then
    return "/" .. self.index .. "/" .. self.type .. "/_search"
  elseif self.index ~= nil and self.type == nil then
    return "/" .. self.index .. "/_search"
  elseif self.index == nil and self.type ~= nil then
    return "/_all/" .. self.type .. "/_search"
  end
  -- Both are nil
  return "/_search"
end

-------------------------------------------------------------------------------
-- Returns an instance of Search class
-------------------------------------------------------------------------------
function Search:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Search

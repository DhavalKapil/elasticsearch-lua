-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local SearchTemplate = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
SearchTemplate.allowedParams = {
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["preference"] = true,
  ["routing"] = true,
  ["scroll"] = true,
  ["search_type"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function SearchTemplate:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function SearchTemplate:getUri()
  if self.index ~= nil and self.type ~= nil then
    return "/" .. self.index .. "/" .. self.type .. "/_search/template"
  elseif self.index ~= nil and self.type == nil then
    return "/" .. self.index .. "/_search/template"
  elseif self.index == nil and self.type ~= nil then
    return "/_all/" .. self.type .. "/_search/template"
  end
  -- Both are nil
  return "/_search/template"
end

-------------------------------------------------------------------------------
-- Returns an instance of SearchTemplate class
-------------------------------------------------------------------------------
function SearchTemplate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return SearchTemplate

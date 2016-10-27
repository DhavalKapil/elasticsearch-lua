-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local UpdateByQuery = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
UpdateByQuery.allowedParams = {
  ["analyzer"] = true,
  ["analyze_wildcard"] = true,
  ["default_operator"] = true,
  ["df"] = true,
  ["explain"] = true,
  ["fields"] = true,
  ["fielddata_fields"] = true,
  ["from"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["conflicts"] = true,
  ["expand_wildcards"] = true,
  ["lenient"] = true,
  ["lowercase_expanded_terms"] = true,
  ["preference"] = true,
  ["q"] = true,
  ["routing"] = true,
  ["scroll"] = true,
  ["search_type"] = true,
  ["search_timeout"] = true,
  ["size"] = true,
  ["sort"] = true,
  ["_source"] = true,
  ["_source_exclude"] = true,
  ["_source_include"] = true,
  ["terminate_after"] = true,
  ["stats"] = true,
  ["suggest_field"] = true,
  ["suggest_mode"] = true,
  ["suggest_size"] = true,
  ["suggest_text"] = true,
  ["timeout"] = true,
  ["track_scores"] = true,
  ["version"] = true,
  ["request_cache"] = true,
  ["refresh"] = true,
  ["consistency"] = true,
  ["scroll_size"] = true,
  ["wait_for_completion"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function UpdateByQuery:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function UpdateByQuery:getUri()
  local uri = "/_update_by_query"
  if self.index == nil then
    return nil, "index not specified for UpdateByQuery"
  end
  if self.type ~= nil then
    uri = "/" .. self.type .. uri
  end
  uri = "/" .. self.index .. uri 
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of UpdateByQuery class
-------------------------------------------------------------------------------
function UpdateByQuery:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return UpdateByQuery

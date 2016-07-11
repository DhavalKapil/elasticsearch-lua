-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Explain = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Explain.allowedParams = {
  ["analyze_wildcard"] = true,
  ["analyzer"] = true,
  ["default_operator"] = true,
  ["df"] = true,
  ["fields"] = true,
  ["lenient"] = true,
  ["lowercase_expanded_terms"] = true,
  ["parent"] = true,
  ["preference"] = true,
  ["q"] = true,
  ["routing"] = true,
  ["source"] = true,
  ["_source"] = true,
  ["_source_exclude"] = true,
  ["_source_include"] = true,
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Explain:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Explain:getUri()
  if self.id == nil then
    return nil, "id not specified for Explain"
  end
  if self.index == nil then
    return nil, "index not specified for Explain"
  end
  if self.type == nil then
    return nil, "type not specified for Explain"
  end
  return "/" .. self.index .. "/" .. self.type .. "/" .. self.id .. "/_explain"
end

-------------------------------------------------------------------------------
-- Returns an instance of Explain class
-------------------------------------------------------------------------------
function Explain:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Explain

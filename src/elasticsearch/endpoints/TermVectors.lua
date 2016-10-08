-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local TermVectors = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
TermVectors.allowedParams = {
  ["term_statistics"] = true,
  ["field_statistics"] = true,
  ["dfs"] = true,
  ["fields"] = true,
  ["offsets"] = true,
  ["positions"] = true,
  ["payloads"] = true,
  ["preference"] = true,
  ["routing"] = true,
  ["parent"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function TermVectors:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function TermVectors:getUri()
  if self.id == nil then
    return nil, "id not specified for TermVectors"
  end
  if self.index == nil then
    return nil, "index not specified for TermVectors"
  end
  if self.type == nil then
    return nil, "type not specified for TermVectors"
  end
  local uri = "/" .. self.index .. "/" .. self.type .. "/" .. self.id
    .. "/_termvectors"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of TermVectors class
-------------------------------------------------------------------------------
function TermVectors:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return TermVectors

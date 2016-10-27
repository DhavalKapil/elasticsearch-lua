-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Analyze = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Analyze.allowedParams = {
  ["analyzer"] = true,
  ["field"] = true,
  ["filters"] = true,
  ["index"] = true,
  ["prefer_local"] = true,
  ["text"] = true,
  ["tokenizer"] = true,
  ["format"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Analyze:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Analyze:getUri()
  local uri = "/_analyze"
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Analyze class
-------------------------------------------------------------------------------
function Analyze:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Analyze

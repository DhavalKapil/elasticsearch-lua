-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Analyze = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Analyze.allowedParams = {
  "analyzer",
  "field",
  "filters",
  "index",
  "prefer_local",
  "text",
  "tokenizer",
  "format"
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

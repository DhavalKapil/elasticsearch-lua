-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Suggest = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Suggest.allowedParams = {
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["preference"] = true,
  ["routing"] = true,
  ["source"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Suggest:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Suggest:getUri()
  local uri = ""
  if self.index ~= nil then
    uri = uri .. "/" .. self.index
  end
  uri = uri .. "/_suggest"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Suggest class
-------------------------------------------------------------------------------
function Suggest:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Suggest

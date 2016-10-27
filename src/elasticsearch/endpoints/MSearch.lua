-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local MSearch = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- Bulk body is present for Msearch
MSearch.bulkBody = true

-- The parameters that are allowed to be used in params
MSearch.allowedParams = {
  ["search_type"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function MSearch:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function MSearch:getUri()
  local uri = "/_msearch"
  if self.index ~= nil and self.type ~= nil then
    uri = "/" .. self.index .. "/" .. self.type .. uri
  elseif self.index ~= nil then
    uri = "/" .. self.index .. uri
  elseif self.type ~= nil then
    uri = "/_all/" .. self.type .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of MSearch class
-------------------------------------------------------------------------------
function MSearch:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return MSearch

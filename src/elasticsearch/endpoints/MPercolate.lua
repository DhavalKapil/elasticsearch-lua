-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local MPercolate = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- bulk body is present for MPercolate
MPercolate.bulkBody = true

-- The parameters that are allowed to be used in params
MPercolate.allowedParams = {
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function MPercolate:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function MPercolate:getUri()
  local uri = "/_mpercolate"
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
-- Returns an instance of MPercolate class
-------------------------------------------------------------------------------
function MPercolate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return MPercolate

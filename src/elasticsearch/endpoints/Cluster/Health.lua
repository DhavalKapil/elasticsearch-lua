-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Health = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Health.allowedParams = {
  ["level"] = true,
  ["local"] = true,
  ["master_timeout"] = true,
  ["timeout"] = true,
  ["wait_for_active_shards"] = true,
  ["wait_for_nodes"] = true,
  ["wait_for_relocating_shards"] = true,
  ["wait_for_status"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Health:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Health:getUri()
  local uri = "/_cluster/health"
  if self.index ~= nil then
    uri = uri .. "/" .. self.index
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Health class
-------------------------------------------------------------------------------
function Health:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Health

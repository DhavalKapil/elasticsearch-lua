-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local DeleteMapping = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
DeleteMapping.allowedParams = {
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function DeleteMapping:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function DeleteMapping:getUri()
  if self.index == nil then
    return nil, "index not specified for Delete Mapping"
  end
  if self.type == nil then
    return nil, "type not specified for Delete Mapping"
  end
  return "/" .. self.index .. "/" .. self.type .. "/_mapping"
end

-------------------------------------------------------------------------------
-- Returns an instance of DeleteMapping class
-------------------------------------------------------------------------------
function DeleteMapping:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return DeleteMapping

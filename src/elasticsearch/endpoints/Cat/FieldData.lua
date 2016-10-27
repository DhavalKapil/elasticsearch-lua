-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local FieldData = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
FieldData.allowedParams = {
  ["bytes"] = true,
  ["local"] = true,
  ["master_timeout"] = true,
  ["h"] = true,
  ["help"] = true,
  ["v"] = true,
  ["fields"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function FieldData:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function FieldData:getUri()
  local uri = "/_cat/fielddata"

  if self.fields ~= nil then
    uri = uri .. "/" .. self.fields
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of FieldData class
-------------------------------------------------------------------------------
function FieldData:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return FieldData

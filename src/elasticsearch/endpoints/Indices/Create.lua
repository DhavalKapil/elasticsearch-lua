-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Create = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Create.allowedParams = {
  "timeout",
  "master_timeout"
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Create:getMethod()
  if type(self.body) == "table" and self.body["mappings"] ~= nil then
    return "POST"
  else
    return "PUT"
  end
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Create:getUri()
  local uri = ""
  if self.index == nil then
    return nil, "index not specified for Create"
  else
    uri = uri .. "/" .. self.index
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Create class
-------------------------------------------------------------------------------
function Create:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Create

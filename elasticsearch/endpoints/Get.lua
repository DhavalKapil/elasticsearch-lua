-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Get = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Get.allowedParams = {
  "fields",
  "parent",
  "preference",
  "realtime",
  "refresh",
  "routing",
  "_source",
  "_source_exclude",
  "_source_include",
  "version",
  "version_type"
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Get:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Get:getUri()
  if self.id == nil then
    return nil, "id not specified for Get"
  end
  if self.index == nil then
    return nil, "index not specified for Get"
  end
  if self.type == nil then
    return nil, "type not specified for Get"
  end
  return "/" .. self.index .. "/" .. self.type .. "/" .. self.id .. "/"
end

-------------------------------------------------------------------------------
-- Returns an instance of Get class
-------------------------------------------------------------------------------
function Get:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Get

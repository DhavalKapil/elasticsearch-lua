-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Delete = Endpoint:new()

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Delete:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Delete:getUri()
  if self.id == nil then
    error("id not specified for Delete")
  end
  if self.index == nil then
    error("index not specified for Delete")
  end
  if self.type == nil then
    error("type not specified for Delete")
  end
  return "/" .. self.index .. "/" .. self.type .. "/" .. self.id .. "/"
end

-------------------------------------------------------------------------------
-- Returns an instance of Delete class
-------------------------------------------------------------------------------
function Delete:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Delete

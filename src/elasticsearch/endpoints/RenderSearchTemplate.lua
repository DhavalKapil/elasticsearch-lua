-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local RenderSearchTemplate = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
RenderSearchTemplate.allowedParams = {
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function RenderSearchTemplate:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function RenderSearchTemplate:getUri()
  local uri = "/_render/template"

  if self.id ~= nil then
    uri = uri .. "/" .. self.id
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of RenderSearchTemplate class
-------------------------------------------------------------------------------
function RenderSearchTemplate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return RenderSearchTemplate

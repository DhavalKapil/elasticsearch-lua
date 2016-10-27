-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Scroll = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The scroll ID
Scroll.scrollId = nil

-- Whether the request is a clear or not
Scroll.endpointParams.clear = false

-- The parameters that are allowed to be used in params
Scroll.allowedParams = {
  ["scroll"] = true,
  ["scroll_id"] = true
}

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
-- Overwrites Endpoint:setParams(params)
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function Scroll:setParams(params)
  self.scroll_id = nil
  self.params = {}
  self.body = nil
  for i, v in pairs(params) do
    if i == "scroll_id" then
      self.scrollId = v
    elseif i == "body" then
      self:setBody(v)
    else
      local err = self:setAllowedParam(i, v)
      if err ~= nil then
        return err
      end
    end
  end
end

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Scroll:getMethod()
  if self.endpointParams.clear == true then
    return "DELETE"
  else
    return "GET"
  end
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Scroll:getUri()
  local uri = "/_search/scroll"
  if self.scrollId ~= nil then
    uri = uri .. "/" .. self.scrollId
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Scroll class
-------------------------------------------------------------------------------
function Scroll:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Scroll

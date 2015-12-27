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
  "scroll",
  "scroll_id"
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
  for i, v in pairs(params) do
    if i == "scroll_id" then
      self.scrollId = v
    elseif i == "body" then
      self:setBody(v)
    else
      -- Checking whether i is in allowed parameters or not
      -- Current algorithm is n*m, but n and m are very small
      local flag = 0;
      for _, allowedParam in pairs(self.allowedParams) do
        if allowedParam == i then
          flag = 1;
          break;
        end
      end
      if flag == 0 then
        return i .. " is not an allowed parameter"
      end
      self.params[i] = v
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

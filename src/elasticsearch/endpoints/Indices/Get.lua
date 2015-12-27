-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Get = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Get.allowedParams = {
  "local",
  "ignore_unavailable",
  "allow_no_indices",
  "expand_wildcards",
  "human"
}

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function Get:setParams(params)
  for i, v in pairs(params) do
    if i == "index" then
      self.index = v
    elseif i == "feature" then
      self.feature = v
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
function Get:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Get:getUri()
  local uri = ""
  if self.index == nil then
    return nil, "index not specified for Get"
  else
    uri = uri .. "/" .. self.index
  end
  if self.feature ~= nil then
    uri = uri .. "/" .. self.feature
  end
  return uri
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

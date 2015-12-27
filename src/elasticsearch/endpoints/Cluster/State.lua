-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local State = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The metric
State.metric = nil

-- The parameters that are allowed to be used in params
State.allowedParams = {
  "local",
  "master_timeout",
  "flat_settings",
  "index_templates",
  "expand_wildcards",
  "ignore_unavailable",
  "allow_no_indices"
}

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
-- Overwrites Endpoint:setParams(params)
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function State:setParams(params)
  for i, v in pairs(params) do
    if i == "index" then
      self.index = v
    elseif i == "metric" then
      self.metric = v
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
function State:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function State:getUri()
  local uri = "/_cluster/state"
  if self.metric ~= nil then
    uri = uri .. "/" .. self.metric
    if self.index ~= nil then
      uri = uri .. "/" .. self.index
    end
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of State class
-------------------------------------------------------------------------------
function State:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return State

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
  ["local"] = true,
  ["master_timeout"] = true,
  ["flat_settings"] = true,
  ["index_templates"] = true,
  ["expand_wildcards"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true
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

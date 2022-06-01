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
  ["fields"] = true,
  ["parent"] = true,
  ["preference"] = true,
  ["realtime"] = true,
  ["refresh"] = true,
  ["routing"] = true,
  ["_source"] = true,
  ["_source_exclude"] = true,
  ["_source_include"] = true,
  ["version"] = true,
  ["version_type"] = true
}

-- Whether only existence needs to be checked
Get.endpointParams.checkOnlyExistance = false

-- Whether to return only source
Get.endpointParams.sourceOnly = false

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Get:getMethod()
  if self.endpointParams.checkOnlyExistance == true then
    return "HEAD"
  else
    return "GET"
  end
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
  local uri = "/" .. self.index .. "/_doc/" .. self.id
  if self.endpointParams.sourceOnly == true then
    uri = uri .. "/_source"
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

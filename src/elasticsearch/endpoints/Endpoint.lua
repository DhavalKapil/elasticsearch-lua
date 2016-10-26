-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local parser = require "elasticsearch.parser"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Endpoint = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The index
Endpoint.index = nil
-- The type
Endpoint.type = nil
-- The id
Endpoint.id = nil
-- The request params to be sent as GET parameters
Endpoint.params = {}
-- The body of the request
Endpoint.body = nil
-- Whether there is a bulk body or not
Endpoint.bulkBody = false
-- The transport instance
Endpoint.transport = nil
-- The endpoint specific parameters
Endpoint.endpointParams = {}

-------------------------------------------------------------------------------
-- Function to set the body parameter
--
-- @param   body    The body to be set
-------------------------------------------------------------------------------
function Endpoint:setBody(body)
  if self.bulkBody == false then
    self.body = parser.jsonEncode(body)
    return
  end
  -- Bulk body is present
  local jsonEncodedBody = {}
  for _id, item in pairs(body) do
    table.insert(jsonEncodedBody, parser.jsonEncode(item))
  end
  self.body = table.concat(jsonEncodedBody, "\n") .. "\n"
end

-------------------------------------------------------------------------------
-- Function used to set the allowed param to be sent as GET parameters
--
-- @param   param   The param provided by the user
-- @param   value   The value of the parameter
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function Endpoint:setAllowedParam(param, value)
  -- Checking whether i is in allowed parameters or not
  if self.allowedParams[param] ~= true then
    return param .. " is not an allowed parameter"
  end
  self.params[param] = value
end

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function Endpoint:setParams(params)
  -- Clearing existing parameters
  self.index = nil
  self.type = nil
  self.id = nil
  self.params = {}
  self.body = nil
  -- Setting new parameters
  for i, v in pairs(params) do
    if i == "index" then
      self.index = v
    elseif i == "type" then
      self.type = v
    elseif i == "id" then
      self.id = v
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
-- Makes a request using the instance of transport class
--
-- @return  table   The reponse returned
-------------------------------------------------------------------------------
function Endpoint:request()
  local uri, err = self:getUri()
  if uri == nil then
    return nil, err
  end
  local response, err = self.transport:request(self:getMethod(), uri
    , self.params, self.body)

  -- parsing body
  if response ~= nil and response.body ~= nil and response.body ~= "" then
    local json = parser.jsonDecode(response.body)
    -- If response is not in json, pass it as it is, otherwise update the json
    if json ~= nil then
      response.body = json
    end
  end

  return response, err
end

-------------------------------------------------------------------------------
-- Returns an instance of Endpoint class
-------------------------------------------------------------------------------
function Endpoint:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Endpoint

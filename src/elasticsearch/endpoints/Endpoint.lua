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
  self.body = ""
  for _id, item in pairs(body) do
    self.body = self.body .. parser.jsonEncode(item) .. "\n"
  end
end

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function Endpoint:setParams(params)
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
    response.body = parser.jsonDecode(response.body)
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

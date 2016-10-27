-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"
local parser = require "elasticsearch.parser"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Create = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Create.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true
}

-- Whether mappings is present in body or not
Create.mappings = false

-------------------------------------------------------------------------------
-- Function to set the body parameter
--
-- @param   body    The body to be set
-------------------------------------------------------------------------------
function Create:setBody(body)
  if type(body) == "table" and body["mappings"] ~= nil then
    self.mappings = true;
  end

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
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Create:getMethod()
  if self.mappings then
    return "POST"
  else
    return "PUT"
  end
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Create:getUri()
  local uri = ""
  if self.index == nil then
    return nil, "index not specified for Create"
  else
    uri = uri .. "/" .. self.index
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Create class
-------------------------------------------------------------------------------
function Create:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Create

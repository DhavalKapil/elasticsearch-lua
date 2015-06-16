-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local http = require "socket.http"
local url = require "socket.url"
local table = require "table"
local ltn12 = require "ltn12"
local parser = require "parser"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Connection = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The protocol of the connection
Connection.protocol = "http"
-- The host where the connection should be made
Connection.host = "localhost"
-- The port at which the connection should be made
Connection.port = 9200
-- Whether the client is alive or not
Connection.alive = false


-------------------------------------------------------------------------------
-- Makes a request to target server
--
-- @param   method  The HTTP method to be used
-- @param   uri     The HTTP URI for the request
-- @param   params  The optional URI parameters to be passed
-- @param   body    The body to passed if any
-- @param   timeout The timeout(if any) in seconds
--
-- @return  table   The response returned
-------------------------------------------------------------------------------
function Connection:request(method, uri, params, body, timeout)
  -- Building URI
  local uri = self:buildURI(uri, params)
  -- The responseBody table
  local responseBody = {}
  -- The response table
  local response = {}
  -- The request table
  local request = {
    method = method,
    url = uri,
    sink = ltn12.sink.table(responseBody)
  }
  if method == "POST" then
    -- Adding body to request
    request.headers = {
      ["Content-Length"] = body:len()
    }
    request.source = ltn12.source.string(body)
  end
  if timeout ~= nil then
    -- Setting timeout for request
    http.TIMEOUT = timeout
  end

  -- Making the actual request
  response.code, response.statusCode, response.headers, response.statusLine
    = http.request(request)
  http.TIMEOUT = nil
  if responseBody ~= nil then
    response.body = parser.jsonDecode(responseBody[1])
  end

  return response
end

-------------------------------------------------------------------------------
-- Pings the target server and sets alive variable appropriately
--
-- @return  boolean   The status whether the Node is alive or not
-------------------------------------------------------------------------------
function Connection:ping()
  local response = self:request('HEAD', '', nil, nil, 1)
  if response.code ~= nil and response.statusCode == 200 then
    -- TODO check for status code also
    self.alive = true
    return true
  else
    self.alive = false
    return false
  end
end

-------------------------------------------------------------------------------
-- Sniffs the network to collect information about other nodes in the cluster
--
-- @return  table   The details about other nodes
-------------------------------------------------------------------------------
function Connection:sniff()
  return self:request('GET', '/_nodes/_all/clear', nil, nil, 1)
end

-------------------------------------------------------------------------------
-- Builds the query string from the query table
--
-- @param   params  The query as a table
--
-- @return  string  The query as a string
-------------------------------------------------------------------------------
function Connection:buildQuery(params)
  local query = ''
  for k, v in pairs(params) do
    query = query .. k .. '=' .. v .. '&'
  end
  return query:sub(1, query:len()-1)
end

-------------------------------------------------------------------------------
-- Builds the URL according to protocol, host, port, uri and params
--
-- @param   uri     The HTTP URI for the request
-- @param   params  The optional URI parameters to be passed
--
-- @return  string  The final built URI
-------------------------------------------------------------------------------
function Connection:buildURI(uri, params)
  local urlComponents = {
    scheme = self.protocol,
    host = self.host,
    port = self.port,
    path = uri
  }
  if params ~= nil then
    urlComponents.query = self:buildQuery(params)
  end
  return url.build(urlComponents)
end

-------------------------------------------------------------------------------
-- Returns an instance of Connection class
-------------------------------------------------------------------------------
function Connection:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  -- Checking options
  if type(o.protocol) ~= "string" then
    error("protocol should be of string type")
  elseif type(o.host) ~= "string" then
    error("host should be of string type")
  elseif type(o.port) ~= "number" then
    error("port should be of number type")
  elseif type(o.alive) ~= "boolean" then
    error("alive should be of boolean type")
  end

  return o
end

return Connection
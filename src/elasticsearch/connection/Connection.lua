-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local http = require "socket.http"
local url = require "socket.url"
local table = require "table"
local ltn12 = require "ltn12"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Connection = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The protocol of the connection
Connection.protocol = nil
-- The host where the connection should be made
Connection.host = nil
-- The port at which the connection should be made
Connection.port = nil
-- The timeout for a ping/sniff request
Connection.pingTimeout = nil
-- The last timestamp where it was marked alive
Connection.lastPing = 0
-- The number of times it was marked dead continuously
Connection.failedPings = 0
-- Whether the client is alive or not
Connection.alive = false
-- The logger instance
Connection.logger = nil


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
  local response, err = self:engine(method, uri, params, body, timeout)
  return response
end

function Connection:engine(method, uri, params, body, timeout)
  local uri = self:buildURI(uri, params)
  if self.preferred_engine == "default" then
--    The responseBody table
    local responseBody = {}
    -- The response table
    local response = {}
    -- The request table
    local request = {
      method = method,
      url = uri,
      sink = ltn12.sink.table(responseBody)
    }
    if body ~= nil then
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
    self.logger:debug("Got HTTP " .. response.statusCode)
    http.TIMEOUT = nil
    response.body = table.concat(responseBody)
    return response
  end

  return self.preferred_engine(method, uri, params, body, timeout)
end

-------------------------------------------------------------------------------
-- Pings the target server and sets alive variable appropriately
--
-- @return  boolean   The status whether the Node is alive or not
-------------------------------------------------------------------------------
function Connection:ping()
  local response = self:request('HEAD', '', nil, nil, self.pingTimeout)
  if response.code ~= nil and response.statusCode == 200 then
    self:markAlive()
    return true
  else
    self:markDead()
    return false
  end
end

-------------------------------------------------------------------------------
-- Sniffs the network to collect information about other nodes in the cluster
--
-- @return  table   The details about other nodes
-------------------------------------------------------------------------------
function Connection:sniff()
  return self:request('GET', '/_nodes/_all/clear', nil, nil, self.pingTimeout)
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
-- Marks the connection alive
-------------------------------------------------------------------------------
function Connection:markAlive()
  self.alive = true
  self.failedPings = 0
  self.lastPing = os.time()
  self.logger:debug(self:toString() .. " marked alive")
end

-------------------------------------------------------------------------------
-- Marks the connection alive
-------------------------------------------------------------------------------
function Connection:markDead()
  self.alive = false
  self.failedPings = self.failedPings + 1
  self.lastPing = os.time()
  self.logger:debug(self:toString() .. " marked dead")
end

-------------------------------------------------------------------------------
-- Returns the connection description as a string
--
-- @return    string    The details about the connection as a string
-------------------------------------------------------------------------------
function Connection:toString()
  return(self.protocol .. "://" .. self.host .. ":" .. self.port)
end

-------------------------------------------------------------------------------
-- Returns an instance of Connection class
-------------------------------------------------------------------------------
function Connection:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Connection
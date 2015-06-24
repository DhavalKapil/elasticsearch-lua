-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Connection = require "connection.Connection"
local Transport = require "Transport"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Settings = {}

-------------------------------------------------------------------------------
-- Default parameters
-------------------------------------------------------------------------------

-- Initial seed of hosts
Settings.hosts = {
  {
    protocol = "http",
    host = "localhost",
    port = 9200,
  }
}

Settings.params = {}

-- The ping timeout
Settings.params.pingTimeout = 1

-- The selector type
Settings.params.selector = "RoundRobinSelector"

-- The connectionPool type
Settings.params.connectionPool = "StaticConnectionPool"

-- The connection pool settings
Settings.params.connectionPoolSettings = {
  pingTimeout = 60,
  maxPingTimeout = 3600
}

-- The number of allowed retries if a connection fails
Settings.maxRetryCount = 5

-------------------------------------------------------------------------------
-- Instance variables
-------------------------------------------------------------------------------

-- The list of all connections
Settings.connections = {}

-- The selector instance
Settings.selector = nil

-- The connection pool instance
Settings.connectionPool = nil

-- The transport instance
Settings.transport = nil

-------------------------------------------------------------------------------
-- Function to recursivly check a table `user` with parameters of `default`
-- And flag an error if any
--
-- @param   default   The correct table that is to be used as default
-- @param   user      The table that is to be checked
-------------------------------------------------------------------------------
function Settings:checkTable(default, user)
  for i, v in pairs(user) do
    if default[i] == nil then
      error("No such parameter allowed: " .. i)
    end
    if type(default[i]) ~= type(user[i]) then
      error("TypeError: " .. i .. " should be of type " .. type(default[i]))
    end
    if type(default[i]) == "table" then
      checkTable(default[i], user[i])
    else
      -- Load user defined value in default
      default[i] = user[i]
    end
  end
end

-------------------------------------------------------------------------------
-- Check parameters validity
-- If a particular property is not set, set it to default
-- If some unkown property is set, flag an error
-------------------------------------------------------------------------------
function Settings:setParameters()
  -- Checking hosts
  if self.user_hosts ~= nil then
    local default_host = self.hosts[1]
    for i, v in pairs(self.user_hosts) do
      self.hosts[i] = default_host
      self:checkTable(self.hosts[i], v)
    end
  end
  -- Checking other parameters
  if self.user_hosts == nil then
    print "NIL!"
  end
  self:checkTable(self.params, self.user_params)
end

-------------------------------------------------------------------------------
-- Initializes the connection settings
-------------------------------------------------------------------------------
function Settings:setConnectionSettings()
  for key, host in pairs(self.hosts) do
    table.insert(self.connections, Connection:new{
      protocol = host.protocol,
      host = host.host,
      port = host.port,
      pingTimeout = self.params.pingTimeout
    })
  end
end

-------------------------------------------------------------------------------
-- Initialize the selector settings
-------------------------------------------------------------------------------
function Settings:setSelectorSettings()
  local Selector = require("selector." .. self.params.selector)
  self.selector = Selector:new()
end

-------------------------------------------------------------------------------
-- Initialize the Connection Pool settings
-------------------------------------------------------------------------------
function Settings:setConnectionPoolSettings()
  local ConnectionPool = require("connectionpool." ..
   self.params.connectionPool)
  o = {
    connections = self.connections,
    selector = self.selector
  }
  for i, v in pairs(self.params.connectionPoolSettings) do
    o[i] = v
  end
  self.connectionPool = ConnectionPool:new(o)
end

-------------------------------------------------------------------------------
-- Initializes the Transport settings
-------------------------------------------------------------------------------
function Settings:setTransportSettings()
  self.transport = Transport:new({
    connectionPool = self.connectionPool,
    maxRetryCount = self.maxRetryCount
  })
end

-------------------------------------------------------------------------------
-- Initializes the settings
-------------------------------------------------------------------------------
function Settings:initializeSettings()
  self:setParameters()
  self:setConnectionSettings()
  self:setSelectorSettings()
  self:setConnectionPoolSettings()
  self:setTransportSettings()
end

-------------------------------------------------------------------------------
-- Returns an instance of Settings class
-------------------------------------------------------------------------------
function Settings:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o:initializeSettings()
  return o
end

return Settings
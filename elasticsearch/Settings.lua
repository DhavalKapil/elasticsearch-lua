-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Connection = require "connection.Connection"

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

-- The ping timeout
Settings.params.pingTimeout = 1

-- The selector type
Settings.params.selector = "RoundRobinSelector"

-- The connectionPool type
Settings.params.connectionPool = "StaticConnectionPool"

-- The connection pool settings
Settings.params.connectionPoolSettings = {
  pingTimeout = 60
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
Settings.selector

-- The connection pool instance
Settings.connectionPool

-- The transport instance
Settings.transport

-------------------------------------------------------------------------------
-- Initializes the connection settings
-------------------------------------------------------------------------------
function Settings:setConnectionSettings()
  for host in hosts:
    table.insert(self.connections, Connection:new({
      protocol = host.protocol,
      host = host.host,
      port = host.port,
      pingTimeout = self.params.pingTimeout
    }))
  end
end

-------------------------------------------------------------------------------
-- Initialize the selector settings
-------------------------------------------------------------------------------
function Settings:setSelectorSettings()
  local Selector = require("selector" .. self.params.selector)
  self.selector = Selector:new()
end

-------------------------------------------------------------------------------
-- Initialize the Connection Pool settings
-------------------------------------------------------------------------------
function Settings:setConnectionPoolSettings()
  local ConnectionPool = require("connectionpool" ..
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
  self:initializeSettings()
  return o
end

return Settings
--- The Settings class
-- @classmod Settings
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Connection = require "elasticsearch.connection.Connection"
local Transport = require "elasticsearch.Transport"
local Logger = require "elasticsearch.Logger"
local Cat = require "elasticsearch.Cat"
local Cluster = require "elasticsearch.Cluster"
local Nodes = require "elasticsearch.Nodes"
local Indices = require "elasticsearch.Indices"
local Snapshot = require "elasticsearch.Snapshot"
local Tasks = require "elasticsearch.Tasks"

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
    username = nil,
    password = nil
  }
}

Settings.params = {}

-- The ping timeout
Settings.params.pingTimeout = 1

-- The standard requester
Settings.params.requestEngine = "LuaSocket"

-- The selector type
Settings.params.selector = "RoundRobinSelector"

-- The connectionPool type
Settings.params.connectionPool = "StaticConnectionPool"

-- The connection pool settings
Settings.params.connectionPoolSettings = {
  pingTimeout = 60,
  maxPingTimeout = 3600,
  sniffingInterval = 1
}

-- The number of allowed retries if a connection fails
Settings.params.maxRetryCount = 5

-- The logLevel
Settings.params.logLevel = "warn"

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

-- The logger instance
Settings.logger = nil

-- The cat instance
Settings.cat = nil

-- The cluster instance
Settings.cluster = nil

-- The nodes instance
Settings.nodes = nil

-- The indices instance
Settings.indices = nil

-- The snapshot instance
Settings.snapshot = nil

-- The tasks instance
Settings.tasks = nil

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
    if type(default[i]) == "table" then
      self:checkTable(default[i], user[i])
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
    local default_host = {
      protocol = self.hosts[1].protocol,
      host = self.hosts[1].host,
      port = self.hosts[1].port,
      username = self.hosts[1].username,
      password = self.hosts[1].password
    }
    self.hosts = {}
    for i, v in pairs(self.user_hosts) do
      self.hosts[i] = {
        protocol = default_host.protocol,
        host = default_host.host,
        port = default_host.port,
        username = default_host.username,
        password = default_host.password
      }
      self:checkTable(self.hosts[i], v)
    end
  end
  -- Checking other parameters
  self:checkTable(self.params, self.user_params)
end

-------------------------------------------------------------------------------
-- Initializes the Logger settings
-------------------------------------------------------------------------------
function Settings:setLoggerSettings()
  self.logger = Logger:new()
  self.logger:setLogLevel(self.params.logLevel)
end

-------------------------------------------------------------------------------
-- Initializes the connection settings
-------------------------------------------------------------------------------
function Settings:setConnectionSettings()
  self.connections = {}
  for key, host in pairs(self.hosts) do
    table.insert(self.connections, Connection:new{
      protocol = host.protocol,
      host = host.host,
      port = host.port,
      username = host.username,
      password = host.password,
      pingTimeout = self.params.pingTimeout,
      logger = self.logger,
      requestEngine = self.params.requestEngine
    })
  end
end

-------------------------------------------------------------------------------
-- Initialize the selector settings
-------------------------------------------------------------------------------
function Settings:setSelectorSettings()
  if type(self.params.selector) == "string" then 
    local Selector = require("elasticsearch.selector." .. self.params.selector)
    self.selector = Selector:new()
  else
    self.selector = self.params.selector:new()
  end
end

-------------------------------------------------------------------------------
-- Initialize the Connection Pool settings
-------------------------------------------------------------------------------
function Settings:setConnectionPoolSettings()
  local ConnectionPool = {}
  if type(self.params.connectionPool) == "string" then
    ConnectionPool = require("elasticsearch.connectionpool." ..
      self.params.connectionPool)
  else
    ConnectionPool = self.params.connectionPool
  end
  o = {
    connections = self.connections,
    selector = self.selector,
    logger = self.logger
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
    maxRetryCount = self.params.maxRetryCount
  })
end

-------------------------------------------------------------------------------
-- Initializes the Cat settings
-------------------------------------------------------------------------------
function Settings:setCatSettings()
  self.cat = Cat:new{
    transport = self.transport
  }
end

-------------------------------------------------------------------------------
-- Initializes the Cluster settings
-------------------------------------------------------------------------------
function Settings:setClusterSettings()
  self.cluster = Cluster:new{
    transport = self.transport
  }
end

-------------------------------------------------------------------------------
-- Initializes Nodes settings
-------------------------------------------------------------------------------
function Settings:setNodesSettings()
  self.nodes = Nodes:new{
    transport = self.transport
  }
end

-------------------------------------------------------------------------------
-- Initializes Indices settings
-------------------------------------------------------------------------------
function Settings:setIndicesSettings()
  self.indices = Indices:new{
    transport = self.transport
  }
end

-------------------------------------------------------------------------------
-- Initializes Snapshot settings
-------------------------------------------------------------------------------
function Settings:setSnapshotSettings()
  self.snapshot = Snapshot:new{
    transport = self.transport
  }
end

-------------------------------------------------------------------------------
-- Initializes Tasks settings
-------------------------------------------------------------------------------
function Settings:setTasksSettings()
  self.tasks = Tasks:new{
    transport = self.transport
  }
end

-------------------------------------------------------------------------------
-- Initializes the settings
-------------------------------------------------------------------------------
function Settings:initializeSettings()
  self:setParameters()
  self:setLoggerSettings()
  self:setConnectionSettings()
  self:setSelectorSettings()
  self:setConnectionPoolSettings()
  self:setTransportSettings()
  self:setCatSettings()
  self:setClusterSettings()
  self:setNodesSettings()
  self:setIndicesSettings()
  self:setSnapshotSettings()
  self:setTasksSettings()
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
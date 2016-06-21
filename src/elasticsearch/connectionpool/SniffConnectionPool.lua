-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Connection = require "elasticsearch.connection.Connection"
local ConnectionPool = require "elasticsearch.connectionpool.ConnectionPool"
local parser = require "elasticsearch.parser"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local SniffConnectionPool = ConnectionPool:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The interval after which to sniff
SniffConnectionPool.sniffingInterval = nil

-- The timestamp when next sniff is scheduled
SniffConnectionPool.nextSniff = -1

-------------------------------------------------------------------------------
-- Returns the next connection from the connections table
-- Sniffs first depending upon nextSniff
--
-- @return  table   An instance of Connection
-------------------------------------------------------------------------------
function SniffConnectionPool:nextConnection()
  -- Check to see if sniffing is required
  if self.nextSniff <= os.time() then
    self.logger:debug("Sniffing for connections")
    self:sniff()
  end
  -- Checking all connection if they are alive or not
  for i = 1, #self.connections do
    local connection = self.selector:selectNext(self.connections)
    if connection.alive or connection:ping() then
      self.logger:debug("Found alive connection")
      return connection
    end
  end
  return nil
end

-------------------------------------------------------------------------------
-- Sniffs every connections to discover new nodes in the cluster
-------------------------------------------------------------------------------
function SniffConnectionPool:sniff()
  for _, v in ipairs(self.connections)
    self:sniffConnection(v)
  end
  -- Updating sniff time
  self.nextSniff = os.time() + self.sniffingInterval
end

-------------------------------------------------------------------------------
-- Sniffs a particular connection and adds newly found connections
--
-- @param   connection    The connection to sniff
-------------------------------------------------------------------------------
function SniffConnectionPool:sniffConnection(connection)
  local response = connection:sniff()
  if response.code == nil then
    connection:markDead()
  end
  connection:markAlive()
  if response.statusCode ~= 200 then
    return
  end
  response.body = parser.jsonDecode(response.body)
  local schemaAddress = connection.protocol .. "_address"
  -- Iterating over every node
  for _, node in pairs(response.body.nodes) do
    -- Checking if <protocol>_address field exists
    if node[schemaAddress] ~= nil then
      -- Parse node parameters
      local temp1, temp2, host, port = 
        node[schemaAddress]:find("/([^:]*):([0-9]+)]")
      if self:connectionExists(host, port) == false then
        -- Adding node to hosts
        self.logger:debug("Adding connection: " .. node[schemaAddress])
        local discoveredConnection = Connection:new{
          protocol = connection.protocol,
          host = host,
          port = port,
          pingTimeout = connection.pingTimeout,
          logger = connection.logger
        }
        table.insert(self.connections, discoveredConnection)
      end
    end
  end
end

-------------------------------------------------------------------------------
-- Checks whether a connection with same host/port exists or not
--
-- @param   host    The host of the connection
-- @param   port    The port of the connection
--
-- @return  boolean Whether the connection exists or not
-------------------------------------------------------------------------------
function SniffConnectionPool:connectionExists(host, port)
  for _, connection in pairs(self.connections) do
    if connection.host == host and connection.port == port then
      return true
    end
  end
  return false
end

-------------------------------------------------------------------------------
-- Returns an instance of SniffConnectionPool class
-------------------------------------------------------------------------------
function SniffConnectionPool:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return SniffConnectionPool

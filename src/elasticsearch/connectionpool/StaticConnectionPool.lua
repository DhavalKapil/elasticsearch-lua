-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local ConnectionPool = require "elasticsearch.connectionpool.ConnectionPool"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local StaticConnectionPool = ConnectionPool:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The timeout in seconds
StaticConnectionPool.pingTimeout = nil
-- The max timeout after which to revive the connection
StaticConnectionPool.maxPingTimeout = nil

-------------------------------------------------------------------------------
-- Returns the next connection from the connections table
-- Selection process:
-- 1. Connection is alive
-- 2. Connection was dead earlier but sufficient time has elapsed to test it
--    again for ping
--
-- If no above condition matches, a ping is performed over all available
-- connections to check for valid connection
--
-- @return  table   An instance of Connection
-------------------------------------------------------------------------------
function StaticConnectionPool:nextConnection()
  local deadConnections = {}
  for i = 1, #self.connections do
    local connection = self.selector:selectNext(self.connections)
    if connection.alive then
      -- Connection is alive
      self.logger:debug("Directly got alive connection: " .. connection:toString())
      return connection
    end
    if self:connectionReady(connection) then
      -- Connection is ready to be revived
      if connection:ping() then
        self.logger:debug("Revived connection: " .. connection:toString())
        return connection
      end
    else        
      self.logger:debug("Dead connection detected: " .. connection:toString())
      -- schedule connection to perform ping
      table.insert(deadConnections, connection)
    end
  end
  -- Pinging all dead connections
  for _, v in ipairs(deadConnections) do
    if v:ping() then
      -- Ping successfull
      self.logger:debug("Dead connection now alive: " .. v:toString())
      return v
    end
  end
  -- All pings have failed
  return nil
end

-------------------------------------------------------------------------------
-- Checks whether a connection is ready to be revived or not
-- A connection is ready to be revived if any of the two match:
-- 1. time since last ping > maxPingTimeout
-- 2. time since last ping > pingTimeout * (2 ^ connection's failedPings)
--
-- @param   connection  The connection to be tested
--
-- @return  boolean     Whether the connection is ready to be revived or not
-------------------------------------------------------------------------------
function StaticConnectionPool:connectionReady(connection)
  local timeout = self.pingTimeout * (2 ^ connection.failedPings)
  if timeout > self.maxPingTimeout then
    timeout = self.maxPingTimeout
  end
  if (timeout + connection.lastPing) < os.time() then
    return true
  else
    return false
  end
end

-------------------------------------------------------------------------------
-- Returns an instance of StaticConnectionPool class
-------------------------------------------------------------------------------
function StaticConnectionPool:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return StaticConnectionPool
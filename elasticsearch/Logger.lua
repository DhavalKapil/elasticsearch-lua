--- The Logger class
-- @classmod Logger
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Logger = {}

-------------------------------------------------------------------------------
-- Declaring private constant variables
-------------------------------------------------------------------------------

-- The different log levels
local LOG_LEVEL = {
  OFF = 0,
  FATAL = 100,
  ERROR = 200,
  WARN = 300,
  INFO = 400,
  DEBUG = 500,
  TRACE = 600,
}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The log level set for this instance
Logger.logLevel = LOG_LEVEL.WARNING

-------------------------------------------------------------------------------
-- Set's log level depending on string
--
-- @param   logLevel   The string describing the log level
-------------------------------------------------------------------------------
function Logger:setLogLevel(logLevel)
  logLevel = string.lower(logLevel)
  if logLevel == "off" then
    self.logLevel = LOG_LEVEL.OFF
  elseif logLevel == "fatal" then
    self.logLevel = LOG_LEVEL.FATAL
  elseif logLevel == "error" then
    self.logLevel = LOG_LEVEL.ERROR
  elseif logLevel == "warn" then
    self.logLevel = LOG_LEVEL.WARN
  elseif logLevel == "info" then
    self.logLevel = LOG_LEVEL.INFO
  elseif logLevel == "debug" then
    self.logLevel = LOG_LEVEL.DEBUG
  elseif logLevel == "trace" then
    self.logLevel = LOG_LEVEL.TRACE
  else
    error("Invalid log level specified")
  end
end

-------------------------------------------------------------------------------
-- For logging fatal messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:fatal(message)
  self:log(LOG_LEVEL.FATAL, message)
end

-------------------------------------------------------------------------------
-- For logging error messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:error(message)
  self:log(LOG_LEVEL.ERROR, message)
end

-------------------------------------------------------------------------------
-- For logging warning messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:warning(message)
  self:log(LOG_LEVEL.WARN, message)
end

-------------------------------------------------------------------------------
-- For logging informative messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:info(message)
  self:log(LOG_LEVEL.INFO, message)
end

-------------------------------------------------------------------------------
-- For logging debugging messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:debug(message)
  self:log(LOG_LEVEL.DEBUG, message)
end

-------------------------------------------------------------------------------
-- For logging trace messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:trace(message)
  self:log(LOG_LEVEL.TRACE, message)
end

-------------------------------------------------------------------------------
-- For logging every message
--
-- @param   logLevel   The level of logging
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:log(logLevel, message)
  if self.logLevel >= logLevel then
    -- Log message
    print(message)
  end
end

-------------------------------------------------------------------------------
-- Returns an instance of Logger class
-------------------------------------------------------------------------------
function Logger:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Logger

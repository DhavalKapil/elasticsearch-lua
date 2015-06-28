-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Logger = {}

-------------------------------------------------------------------------------
-- Declaring private constant variables
-------------------------------------------------------------------------------

-- The different log levels
local LOG_LEVEL = {
  INFO = 0,
  DEBUG = 1,
  WARNING = 2,
  ERROR = 3,
  CRITICAL = 4
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
  if logLevel == "info" then
    self.logLevel = LOG_LEVEL.INFO
  elseif logLevel == "debug" then
    self.logLevel = LOG_LEVEL.DEBUG
  elseif logLevel == "warning" then
    self.logLevel = LOG_LEVEL.WARNING
  elseif logLevel == "error" then
    self.logLevel = LOG_LEVEL.ERROR
  elseif logLevel == "critical" then
    self.logLevel = LOG_LEVEL.CRITICAL
  else
    error("Invalid log level specified")
  end
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
-- For logging warning messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:warning(message)
  self:log(LOG_LEVEL.WARNING, message)
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
-- For logging critical messages
-- 
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:critical(message)
  self:log(LOG_LEVEL.CRITICAL, message)
end

-------------------------------------------------------------------------------
-- For logging every message
--
-- @param   logLevel   The level of logging
-- @param   message    The message to be logged
-------------------------------------------------------------------------------
function Logger:log(logLevel, message)
  if self.logLevel <= logLevel then
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

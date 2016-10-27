-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PendingTasks = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PendingTasks.allowedParams = {
  ["local"] = true,
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PendingTasks:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PendingTasks:getUri()
  return "/_cluster/pending_tasks"
end

-------------------------------------------------------------------------------
-- Returns an instance of PendingTasks class
-------------------------------------------------------------------------------
function PendingTasks:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PendingTasks

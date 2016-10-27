-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PendingTasks = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PendingTasks.allowedParams = {
  ["local"] = true,
  ["master_timeout"] = true,
  ["h"] = true,
  ["help"] = true,
  ["v"] = true
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
  local uri = "/_cat/pending_tasks"  
  return uri
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

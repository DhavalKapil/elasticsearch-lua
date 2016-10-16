-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local TasksEndpoint = require "elasticsearch.endpoints.Tasks.TasksEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Get = TasksEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Get.allowedParams = {
  ["node_id"] = true,
  ["actions"] = true,
  ["detailed"] = true,
  ["parent_node"] = true,
  ["parent_task"] = true,
  ["wait_for_completion"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Get:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Get:getUri()
  local uri = "/_tasks"
  if self.taskId ~= nil then
    uri = uri .. "/" .. self.taskId
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Get class
-------------------------------------------------------------------------------
function Get:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Get

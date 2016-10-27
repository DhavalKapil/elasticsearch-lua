-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local TasksEndpoint = require "elasticsearch.endpoints.Tasks.TasksEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Cancel = TasksEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Cancel.allowedParams = {
  ["node_id"] = true,
  ["actions"] = true,
  ["parent_node"] = true,
  ["parent_task"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Cancel:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Cancel:getUri()
  local uri = "/_tasks"
  if self.taskId ~= nil then
    uri = uri .. "/" .. self.taskId
  end
  uri = uri .. "/_cancel"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Cancel class
-------------------------------------------------------------------------------
function Cancel:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Cancel

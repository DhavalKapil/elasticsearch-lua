--- The Tasks class
-- @classmod Tasks
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Tasks = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The transport module
Tasks.transport = nil

-------------------------------------------------------------------------------
-- @local
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint        The string denoting the endpoint
-- @param   params          The parameters to be passed
-- @param   endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Tasks:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints.Tasks." .. endpoint)
  local endpoint = Endpoint:new{
    transport = self.transport,
    endpointParams = endpointParams or {}
  }
  if params ~= nil then
    -- Parameters need to be set
    local err = endpoint:setParams(params);
    if err ~= nil then
      -- Some error in setting parameters, return to user
      return nil, err
    end
  end
  -- Making request
  local response, err = endpoint:request()
  if response == nil then
    -- Some error in response, return to user
    return nil, err
  end
  -- Request successful, return body
  return response.body, response.statusCode
end

-------------------------------------------------------------------------------
-- Cancel function
--
-- @usage
-- params["task_id"]     = (string) Cancel the task with specified task id (node_id:task_number)
--       ["node_id"]     = (list) A comma-separated list of node IDs or names to limit the returned information;
--       use '_local' to return information from the node you"re connecting to, leave empty to get information from all
--       nodes
--       ["actions"]     = (list) A comma-separated list of actions that should be cancelled. Leave empty to
--       cancel all.
--       ["parent_node"] = (string) Cancel tasks with specified parent node.
--       ["parent_task"] = (string) Cancel tasks with specified parent task id (node_id:task_number). Set to -1 to
--       cancel all.
--
-- @param    params    The cancel Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Tasks:cancel(params)
  return self:requestEndpoint("Cancel", params)
end

-------------------------------------------------------------------------------
-- Get function
--
-- @usage
-- params["task_id"]             = (string) Return the task with specified id (node_id:task_number)
--       ["node_id"]             = (list) A comma-separated list of node IDs or names to limit the returned
--       information; use '_local' to return information from the node you"re connecting to, leave empty to get
--       information from all nodes
--       ["actions"]             = (list) A comma-separated list of actions that should be returned. Leave empty
--       to return all.
--       ["detailed"]            = (boolean) Return detailed task information (default: false)
--       ["parent_node"]         = (string) Return tasks with specified parent node.
--       ["parent_task"]         = (string) Return tasks with specified parent task id (node_id:task_number). Set
--       to -1 to return all.
--       ["wait_for_completion"] = (boolean) Wait for the matching tasks to complete (default: false)
--
-- @param    params    The get Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Tasks:get(params)
  return self:requestEndpoint("Get", params)
end

-------------------------------------------------------------------------------
-- @local
-- Returns an instance of Tasks class
-------------------------------------------------------------------------------
function Tasks:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Tasks

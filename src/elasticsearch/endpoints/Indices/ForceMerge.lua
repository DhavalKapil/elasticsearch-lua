-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ForceMerge = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
ForceMerge.allowedParams = {
  ["flush"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["max_num_segments"] = true,
  ["only_expunge_deletes"] = true,
  ["operation_threading"] = true,
  ["wait_for_merge"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function ForceMerge:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function ForceMerge:getUri()
  local uri = "/_forcemerge"
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of ForceMerge class
-------------------------------------------------------------------------------
function ForceMerge:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ForceMerge

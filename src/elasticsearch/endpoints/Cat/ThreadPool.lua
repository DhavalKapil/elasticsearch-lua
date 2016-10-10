-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ThreadPool = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
ThreadPool.allowedParams = {
  ["local"] = true,
  ["master_timeout"] = true,
  ["h"] = true,
  ["help"] = true,
  ["v"] = true,
  ["full_id"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function ThreadPool:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function ThreadPool:getUri()
  local uri = "/_cat/thread_pool"  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of ThreadPool class
-------------------------------------------------------------------------------
function ThreadPool:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ThreadPool

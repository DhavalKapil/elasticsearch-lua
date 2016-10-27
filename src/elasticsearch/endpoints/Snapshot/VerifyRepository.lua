-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local VerifyRepository = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
VerifyRepository.allowedParams = {
  ["master_timeout"] = true,
  ["timeout"] = true,
  ["local"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function VerifyRepository:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function VerifyRepository:getUri()
  if self.repository == nil then
    return nil, "repository not specified for VerifyRepository"
  end
  local uri = "/_snapshot/" .. self.repository .. "/_verify"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of VerifyRepository class
-------------------------------------------------------------------------------
function VerifyRepository:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return VerifyRepository

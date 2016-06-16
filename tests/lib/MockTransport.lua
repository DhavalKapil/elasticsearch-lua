-------------------------------------------------------------------------------
-- Importing external module
-------------------------------------------------------------------------------
local util = require "lib.util"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local MockTransport = {}

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.lib.MockTransport"

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The expected values provided by tester
MockTransport.method = nil
MockTransport.uri = nil
MockTransport.params = nil
MockTransport.body = nil

-- The extra checks function provided by tester
MockTransport.extraChecks = nil

-------------------------------------------------------------------------------
-- Function to mock request
--
-- @param   method  The HTTP method to be used
-- @param   uri     The HTTP URI for the request
-- @param   params  The optional URI parameters to be passed
-- @param   body    The body to passed if any
-------------------------------------------------------------------------------
function MockTransport:request(method, uri, params, body)
  util.check(self.method, method)
  util.check(self.uri, uri)
  util.check(self.params, params)
  util.check(self.body, body)

  if self.extraChecks ~= nil and type(self.extraChecks) == "function" then
    extraChecks(method, uri, params, body)
  end
end

-------------------------------------------------------------------------------
-- Returns an instance of MockTransport class
-------------------------------------------------------------------------------
function MockTransport:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return MockTransport

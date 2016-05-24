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
-- Function to check two variables for equality
--
-- @param   expectedVar   The expected variable
-- @param   actualVar     The actual variable
-------------------------------------------------------------------------------
function MockTransport:check(expectedVar, actualVar)
  if expectedVar == nil then
    assert_nil(actualVar)
    return
  end
  assert_not_nil(actualVar)
  if expectedVar == true then
    assert_true(actualVar)
    return
  elseif expectedVar == false then
    assert_false(actualVar)
    return
  elseif type(expectedVar) == "number" then
    assert_number(actualVar)
  elseif type(expectedVar) == "string" then
    assert_string(actualVar)
  elseif type(expectedVar) == "table" then
    -- Recursively checking table
    local keys = {}
    for i, v in pairs(expectedVar) do
      self:check(v, actualVar[i])
      keys[i] = true
    end
    for i, v in pairs(actualVar) do
      if not keys[i] then
        fail("Unexpected key: " .. i)
      end
    end
    return
  end
  assert_equal(expectedVar, actualVar)
end

-------------------------------------------------------------------------------
-- Function to mock request
--
-- @param   method  The HTTP method to be used
-- @param   uri     The HTTP URI for the request
-- @param   params  The optional URI parameters to be passed
-- @param   body    The body to passed if any
-------------------------------------------------------------------------------
function MockTransport:request(method, uri, params, body)
  self:check(self.method, method)
  self:check(self.uri, uri)
  self:check(self.params, params)
  self:check(self.body, body)

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

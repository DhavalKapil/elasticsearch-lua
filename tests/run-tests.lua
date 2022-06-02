lunit = require "lunit"

package.path = package.path .. ";../src/?.lua"

function runUnitTests()
  -- Requiring all test files
  require "connection.init"
  require "selector.init"
  require "connectionpool.init"
  require "endpoints.init"
  require "TransportTest"
end

function runIntegrationTests()
  -- Require Integration tests
  require "integration.init"
end

function runSetupElastic()
   local setup = require "setup"
   setup.init()
end

-- Running all tests for now
runSetupElastic()
runUnitTests()
runIntegrationTests()

local _, emsg = xpcall(function()
	lunit.main(arg)
end, debug.traceback)
if emsg then
	print(emsg)
	os.exit(1)
end
if lunit.stats.failed > 0 or lunit.stats.errors > 0 then
	os.exit(1)
end

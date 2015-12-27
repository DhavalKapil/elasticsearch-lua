lunit = require "lunit"

package.path = package.path .. ";../src/?.lua"

-- Requiring all test files
require "connection.ConnectionTest"
require "selector.RandomSelectorTest"
require "selector.RoundRobinSelectorTest"
require "selector.StickyRoundRobinSelectorTest"
require "connectionpool.StaticConnectionPoolTest"
require "TransportTest"


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

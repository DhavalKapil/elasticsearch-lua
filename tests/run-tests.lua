local lunit = require "lunit"

package.path = package.path .. ";../elasticsearch/?.lua"

-- Requiring all test files
require "connection.ConnectionTest"
require "selector.RandomSelectorTest"
require "selector.RoundRobinSelectorTest"
require "selector.StickyRoundRobinSelectorTest"

lunit.loadrunner("lunit-console")
lunit.run()

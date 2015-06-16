local lunit = require "lunit"

package.path = package.path .. ";../elasticsearch/?.lua"

-- Requiring all test files
require "connection.ConnectionTest"

lunit.loadrunner("lunit-console")
lunit.run()
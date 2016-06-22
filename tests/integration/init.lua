util = require "lib.util"
dataset = require "integration.dataset.dataset"
operations = require "integration.operations"

-- Integration tests
require "integration.BasicTest"
require "integration.BulkTest"
require "integration.ScanAndScrollTest"
require "integration.SearchTest"
require "integration.ReindexTest"

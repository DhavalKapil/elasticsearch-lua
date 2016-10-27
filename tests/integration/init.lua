util = require "lib.util"
operations = require "lib.operations"
dataset = require "dataset.dataset"

-- Integration tests
require "integration.BasicTest"
require "integration.BulkTest"
require "integration.ScanAndScrollTest"
require "integration.SearchTest"
require "integration.ReindexTest"

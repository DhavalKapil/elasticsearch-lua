--  Tests:
--    scan()
--    scroll()
--

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.integration.ScanAndScrollTest"

function test()
   operations.bulkIndex(dataset)
   local res = operations.searchScan{
      query = {
         match = {
            type = "PushEvent"
         }
      },
      sort = { "_doc" }
   }
   local scroll_id = res["_scroll_id"]
   assert_not_nil(scroll_id)
   local total_hits = #res["hits"]["hits"]
   while true do
      res = operations.scroll(scroll_id)
      total_hits = total_hits + #res["hits"]["hits"]
      if #res["hits"]["hits"] == 0 then
         break
      end
      scroll_id = res["_scroll_id"]
      assert_not_nil(scroll_id)
   end
   assert_equal(103, total_hits)
   operations.bulkDeleteExistingDocuments(dataset)
end

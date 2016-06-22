--- The helper module
-- @module helper
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local helpers = {}

-------------------------------------------------------------------------------
-- Reindex all documents from one index to another index that satisfy
-- a given query
--
-- @param    sourceClient    The source client
-- @param    sourceIndex     The source index
-- @param    targetIndex     The target index
-- @param    query           Search query to filter data to be reindexed
--                           query is for request body search
-- @param    targetClient    The target client
-- @param    scroll          Specify how long a consistent view of the index
--                           should be maintained for scrolled search
-- @param    scanParams      Additional params passed to scan
-- @param    bulkParams      Additional params passed to bulk
--
-- @return   boolean         true if success, otherwise false
-------------------------------------------------------------------------------
function helpers.reindex(sourceClient, sourceIndex, targetIndex, query,
  targetClient, scroll, scanParams, bulkParams)

  -- Setting up default parameters
  query = query or {}
  targetClient = targetClient or sourceClient
  scroll = scroll or "1m"
  scanParams = scanParams or {}
  bulkParams = bulkParams or {}

  -- Performing a search query
  scanParams.index = sourceIndex
  scanParams.search_type = "scan"
  scanParams.scroll = scroll
  scanParams.body = query
  local data, err = sourceClient:search(scanParams)

  -- Checking for error in search query
  if data == nil then
    return false, err
  end

  local scrollId = data["_scroll_id"]
  -- Performing a repetitive scroll queries
  while true do
    data, err = sourceClient:scroll{
      scroll_id = scrollId,
      scroll = scroll
    }

    -- Checking for error in scroll query
    if data == nil then
      return false, err
    end

    -- If no more hits then break
    if #data["hits"]["hits"] == 0 then
      break
    end

    scrollId = data["_scroll_id"]

    -- Bulk indexing the documents
    local bulkBody = {}
    for _, item in pairs(data["hits"]["hits"]) do
      table.insert(bulkBody, {
        index = {
          _index = targetIndex,
          _type = item["_type"],
          _id = item["_id"]
        }
      })
      table.insert(bulkBody, item["_source"])
    end

    bulkParams.body = bulkBody

    data, err = targetClient:bulk(bulkParams)

    -- Checking for error in bulk request
    if data == nil then
      return false, err
    end
  end
  return true
end

return helpers

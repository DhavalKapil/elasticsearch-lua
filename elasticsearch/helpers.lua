--- The helper module
-- @module helper
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local helpers = {}

-------------------------------------------------------------------------------
-- Function to reindex
--
-- @param    sourceClient    The source client
-- @param    sourceIndex     The source index
-- @param    targetIndex     The target index
-- @param    query           Search query to filter data to be reindexed
-- @param    targetClient    The target client
-- @param    scroll          Specify how long a consistent view of the index
--                           should be maintained for scrolled search
-------------------------------------------------------------------------------
function helpers.reindex(sourceClient, sourceIndex, targetIndex, query,
  targetClient, scroll)

  -- Setting up query, target_client and scroll
  query = query or {}
  targetClient = targetClient or sourceClient
  scroll = scroll or "1m"

  -- Performing a search query
  local data, err = sourceClient:search{
    index = sourceIndex,
    search_type = "scan",
    scroll = scroll,
    body = query
  }

  -- Checking for error in search query
  if data == nil then
    return nil, err
  end

  -- Performing a repetitive scroll queries
  while true do
    local scrollId = data["_scroll_id"]
    data, err = sourceClient:scroll{
      scroll_id = scrollId,
      scroll = scroll
    }

    -- Checking for error in scroll query
    if data == nil then
      print(err)
      return nil, err
    end

    -- If no more hits then break
    if #data["hits"]["hits"] == 0 then
      break
    end

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

    data, err = targetClient:bulk{
      index = targetIndex,
      body = bulkBody
    }

    -- Checking for error in bulk request
    if data == nil then
      return nil, err
    end
  end
end

return helpers
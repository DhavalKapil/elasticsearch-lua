-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Mlt = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Mlt.allowedParams = {
  ["boost_terms"] = true,
  ["max_doc_freq"] = true,
  ["max_query_terms"] = true,
  ["max_word_length"] = true,
  ["min_doc_freq"] = true,
  ["min_term_freq"] = true,
  ["min_word_length"] = true,
  ["mlt_fields"] = true,
  ["percent_terms_to_match"] = true,
  ["routing"] = true,
  ["search_from"] = true,
  ["search_indices"] = true,
  ["search_query_hint"] = true,
  ["search_scroll"] = true,
  ["search_size"] = true,
  ["search_source"] = true,
  ["search_type"] = true,
  ["search_types"] = true,
  ["stop_words"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Mlt:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Mlt:getUri()
  if self.index == nil then
    return nil, "index not specified for Mlt"
  end
  if self.type == nil then
    return nil, "type not specified for Mlt"
  end
  if self.id == nil then
    return nil, "id not specified for Mlt"
  end
  local uri = "/" .. self.index .. "/" .. self.type .. "/" .. self.id .. "/_mlt"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Mlt class
-------------------------------------------------------------------------------
function Mlt:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Mlt

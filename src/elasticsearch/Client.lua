--- The Client class
-- @classmod Client
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Settings = require "elasticsearch.Settings"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Client = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The Settings instance
Client.settings = nil

--- The cat instance
Client.cat = nil

--- The cluster instance
Client.cluster = nil

--- The indices instance
Client.indices = nil

--- The nodes instance
Client.nodes = nil

--- The snapshot instance
Client.snapshot = nil

--- The tasks instance
Client.tasks = nil

-------------------------------------------------------------------------------
-- @local
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint        The string denoting the endpoint
-- @param   params          The parameters to be passed
-- @param   endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints." .. endpoint)
  local endpoint = Endpoint:new{
    transport = self.settings.transport,
    endpointParams = endpointParams or {}
  }
  if params ~= nil then
    -- Parameters need to be set
    local err = endpoint:setParams(params)
    if err ~= nil then
      -- Some error in setting parameters, return to user
      return nil, err
    end
  end
  -- Making request
  local response, err = endpoint:request()
  if response == nil then
    -- Some error in response, return to user
    return nil, err
  end
  -- Request successful, return body
  return response.body, response.statusCode
end

-------------------------------------------------------------------------------
-- Function to get information regarding the Elasticsearch server
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:info()
  return self:requestEndpoint("Info")
end

-------------------------------------------------------------------------------
-- Function to ping to check whether there exists any alive connection to
-- elasticsearch server or not
--
-- @return  boolean   Whether we have any alive connection or not
-------------------------------------------------------------------------------
function Client:ping()
  local data, err, statusCode = self:requestEndpoint("Ping")
  return err == nil
end

-------------------------------------------------------------------------------
-- Function to get a particular document
--
-- @usage
-- params["id"]              = (string) The document ID (Required)
--       ["index"]           = (string) The name of the index (Required)
--       ["type"]            = (string) The type of the document (use '_all' to fetch the first document matching the ID across all types) (Required)
--       ["ignore_missing"]  = ??
--       ["fields"]          = (list) A comma-separated list of fields to return in the response
--       ["parent"]          = (string) The ID of the parent document
--       ["preference"]      = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["realtime"]        = (boolean) Specify whether to perform the operation in realtime or search mode
--       ["refresh"]         = (boolean) Refresh the shard containing the document before performing the operation
--       ["routing"]         = (string) Specific routing value
--       ["_source"]         = (list) True or false to return the _source field or not, or a list of fields to return
--       ["_source_exclude"] = (list) A list of fields to exclude from the returned _source field
--       ["_source_include"] = (list) A list of fields to extract and return from the _source field
--
-- @param    params    The get Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:get(params)
  return self:requestEndpoint("Get", params)
end

-------------------------------------------------------------------------------
-- Function to check whether a document exists or not
--
-- @usage
-- params["id"]         = (string) The document ID (Required)
--       ["index"]      = (string) The name of the index (Required)
--       ["type"]       = (string) The type of the document (use '_all' to fetch the first document matching the ID across all types) (Required)
--       ["parent"]     = (string) The ID of the parent document
--       ["preference"] = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["realtime"]   = (boolean) Specify whether to perform the operation in realtime or search mode
--       ["refresh"]    = (boolean) Refresh the shard containing the document before performing the operation
--       ["routing"]    = (string) Specific routing value
--
-- @param    params    The exists Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:exists(params)
  local temp, status = self:requestEndpoint("Get", params, {
    checkOnlyExistance = true
  })
  if temp ~= nil then
    -- Successfull request
    return true, status
  elseif status:match("Invalid response code") then
    -- Wrong response code
    return false
  else
    -- Some other error, notify user
    return nil, status
  end
end

-------------------------------------------------------------------------------
-- Function to get only the _source of a particular document
--
-- @usage
-- params["id"]             = (string) The document ID (Required)
--       ["index"]          = (string) The name of the index (Required)
--       ["type"]           = (string) The type of the document (use '_all' to fetch the first document matching the ID across all types) (Required)
--       ["ignore_missing"] = ??
--       ["parent"]         = (string) The ID of the parent document
--       ["preference"]     = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["realtime"]       = (boolean) Specify whether to perform the operation in realtime or search mode
--       ["refresh"]        = (boolean) Refresh the shard containing the document before performing the operation
--       ["routing"]        = (string) Specific routing value
--
-- @param    params    The getSource Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:getSource(params)
  return self:requestEndpoint("Get", params, {
    sourceOnly = true
  })
end

-------------------------------------------------------------------------------
-- Function to get multiple document
--
-- @usage
-- params["index"]           = (string) The name of the index
--       ["type"]            = (string) The type of the document
--       ["fields"]          = (list) A comma-separated list of fields to return in the response
--       ["parent"]          = (string) The ID of the parent document
--       ["preference"]      = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["realtime"]        = (boolean) Specify whether to perform the operation in realtime or search mode
--       ["refresh"]         = (boolean) Refresh the shard containing the document before performing the operation
--       ["routing"]         = (string) Specific routing value
--       ["body"]            = (array) Document identifiers; can be either 'docs' (containing full document information) or 'ids' (when index and type is provided in the URL.
--       ["_source"]         = (list) True or false to return the _source field or not, or a list of fields to return
--       ["_source_exclude"] = (list) A list of fields to exclude from the returned _source field
--       ["_source_include"] = (list) A list of fields to extract and return from the _source field
--
-- @param    params    The mget Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:mget(params)
  return self:requestEndpoint("MGet", params)
end


-------------------------------------------------------------------------------
-- Function to index a particular document
--
-- @usage
-- params["index"]        = (string) The name of the index (Required)
--       ["type"]         = (string) The type of the document (Required)
--       ["id"]           = (string) Specific document ID (when the POST method is used)
--       ["consistency"]  = (enum) Explicit write consistency setting for the operation
--       ["op_type"]      = (enum) Explicit operation type
--       ["parent"]       = (string) ID of the parent document
--       ["refresh"]      = (boolean) Refresh the index after performing the operation
--       ["routing"]      = (string) Specific routing value
--       ["timeout"]      = (time) Explicit operation timeout
--       ["timestamp"]    = (time) Explicit timestamp for the document
--       ["ttl"]          = (duration) Expiration time for the document
--       ["version"]      = (number) Explicit version number for concurrency control
--       ["version_type"] = (enum) Specific version type
--       ["body"]         = (array) The document
--
-- @param    params    The index Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:index(params)
  return self:requestEndpoint("Index", params)
end

-------------------------------------------------------------------------------
-- Function to delete a particular document
--
-- @usage
-- params["id"]           = (string) The document ID (Required)
--       ["index"]        = (string) The name of the index (Required)
--       ["type"]         = (string) The type of the document (Required)
--       ["consistency"]  = (enum) Specific write consistency setting for the operation
--       ["parent"]       = (string) ID of parent document
--       ["refresh"]      = (boolean) Refresh the index after performing the operation
--       ["replication"]  = (enum) Specific replication type
--       ["routing"]      = (string) Specific routing value
--       ["timeout"]      = (time) Explicit operation timeout
--       ["version_type"] = (enum) Specific version type
--
-- @param    params    The delete Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:delete(params)
  return self:requestEndpoint("Delete", params)
end

-------------------------------------------------------------------------------
-- Function to delete documents by query
--
-- @usage
-- params["q"]                  = (string) Query in the Lucene query string syntax
--       ["consistency"]        = (enum) Explicit write consistency setting for the operation
--       ["ignore_unavailable"] = (bool) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (bool) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both.
--
-- @param    params    The deleteByQuery Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:deleteByQuery(params)
  return self:requestEndpoint("DeleteByQuery", params)
end

-------------------------------------------------------------------------------
-- Function to get the count
--
-- @usage
-- params["index"]                    = (list) A comma-separated list of indices to restrict the results
--       ["type"]                     = (list) A comma-separated list of types to restrict the results
--       ["ignore_unavailable"]       = (boolean) Whether specified concrete indices should be ignored when
--       unavailable (missing or closed)
--       ["allow_no_indices"]         = (boolean) Whether to ignore if a wildcard indices expression resolves into
--       no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]         = (enum) Whether to expand wildcard expression to concrete indices that are
--       ["min_score"]                = (number) Include only documents with a specific '_score' value in the
--       result
--       ["preference"]               = (string) Specify the node or shard the operation should be performed on
--       ["routing"]                  = (string) Specific routing value
--       ["source"]                   = (string) The URL-encoded query definition (instead of using the request body)
--       ["q"]                        = (string) Query in the Lucene query string syntax
--       ["analyzer"]                 = (string) The analyzer to use for the query string
--       ["analyze_wildcard"]         = (boolean) Specify whether wildcard and prefix queries should be analyzed
--       ["default_operator"]         = (enum) The default operator for query string query (AND or OR) (AND,OR)
--       ["df"]                       = (string) The field to use as default where no field prefix is given in the
--       query string
--       ["lenient"]                  = (boolean) Specify whether format-based query failures (such as providing
--       text to a numeric field) should be ignored
--       ["lowercase_expanded_terms"] = (boolean) Specify whether query terms should be lowercased
--       ["body"]                     = A query to restrict the results specified with the Query DSL (optional)
--
-- @param    params    The count Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:count(params)
  return self:requestEndpoint("Count", params)
end

-------------------------------------------------------------------------------
-- Count Percolator
--
-- @usage
-- params["index"]              = (string) The index of the document being count percolated. (Required)
--       ["type"]               = (string) The type of the document being count percolated. (Required)
--       ["id"]                 = (string) Substitute the document in the request body with a document that is
--       known by the specified id. On top of the id, the index and type parameter will be used to retrieve the document
--       from within the cluster. (Required)
--       ["routing"]            = (list) A comma-separated list of specific routing values
--       ["preference"]         = (string) Specify the node or shard the operation should be performed on
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       ["percolate_index"]    = (string) The index to count percolate the document into. Defaults to index.
--       ["percolate_type"]     = (string) The type to count percolate document into. Defaults to type.
--       ["version"]            = (number) Explicit version number for concurrency control
--       ["version_type"]       = (enum) Specific version type (internal,external,external_gte,force)
--       ["body"]               = The count percolator request definition using the percolate DSL
--
-- @param    params    The countPercolate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:countPercolate(params)
  return self:requestEndpoint("CountPercolate", params)
end

-------------------------------------------------------------------------------
-- Function to implement mpercolate
--
-- @usage
-- params["index"]              = (string) The index of the document being count percolated to use as default
--       ["type"]               = (string) The type of the document being percolated to use as default.
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       ["body"]               = The percolate request definitions (header & body pair), separated by newlines
--
-- @param    params    The mpercolate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:mpercolate(params)
  return self:requestEndpoint("MPercolate", params)
end

-------------------------------------------------------------------------------
-- Function to implement mtermvectors
--
-- @usage
-- params["index"]            = (string) The index in which the document resides.
--       ["type"]             = (string) The type of the document.
--       ["ids"]              = (list) A comma-separated list of documents ids. You must define ids as parameter
--       or set "ids" or "docs" in the request body
--       ["term_statistics"]  = (boolean) Specifies if total term frequency and document frequency should be
--       false)
--       ["field_statistics"] = (boolean) Specifies if document count, sum of document frequencies and sum of
--       total term frequencies should be returned. Applies to all returned documents unless otherwise specified in body
--       ["fields"]           = (list) A comma-separated list of fields to return. Applies to all returned
--       documents unless otherwise specified in body "params" or "docs".
--       ["offsets"]          = (boolean) Specifies if term offsets should be returned. Applies to all returned
--       ["positions"]        = (boolean) Specifies if term positions should be returned. Applies to all returned
--       ["payloads"]         = (boolean) Specifies if term payloads should be returned. Applies to all returned
--       random) .Applies to all returned documents unless otherwise specified in body "params" or "docs".
--       ["routing"]          = (string) Specific routing value. Applies to all returned documents unless
--       otherwise specified in body "params" or "docs".
--       ["parent"]           = (string) Parent id of documents. Applies to all returned documents unless
--       otherwise specified in body "params" or "docs".
--       ["realtime"]         = (boolean) Specifies if requests are real-time as opposed to near-real-time
--       ["version"]          = (number) Explicit version number for concurrency control
--       ["version_type"]     = (enum) Specific version type (internal,external,external_gte,force)
--       ["body"]             = Define ids, documents, parameters or a list of parameters per document here. You
--       must at least provide a list of document ids. See documentation.
--
-- @param    params    The mtermvectors Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:mtermvectors(params)
  return self:requestEndpoint("MTermVectors", params)
end

-------------------------------------------------------------------------------
-- Function to implement more like this query
--
-- @usage
-- params["id"]                     = (string) The document ID (Required)
--       ["index"]                  = (string) The name of the index (Required)
--       ["type"]                   = (string) The type of the document (use '_all' to fetch the first document matching the ID across all types) (Required)
--       ["boost_terms"]            = (number) The boost factor
--       ["max_doc_freq"]           = (number) The word occurrence frequency as count: words with higher occurrence in the corpus will be ignored
--       ["max_query_terms"]        = (number) The maximum query terms to be included in the generated query
--       ["max_word_len"]           = (number) The minimum length of the word: longer words will be ignored
--       ["min_doc_freq"]           = (number) The word occurrence frequency as count: words with lower occurrence in the corpus will be ignored
--       ["min_term_freq"]          = (number) The term frequency as percent: terms with lower occurrence in the source document will be ignored
--       ["min_word_len"]           = (number) The minimum length of the word: shorter words will be ignored
--       ["mlt_fields"]             = (list) Specific fields to perform the query against
--       ["percent_terms_to_match"] = (number) How many terms have to match in order to consider the document a match (default: 0.3)
--       ["routing"]                = (string) Specific routing value
--       ["search_from"]            = (number) The offset from which to return results
--       ["search_indices"]         = (list) A comma-separated list of indices to perform the query against (default: the index containing the document)
--       ["search_query_hint"]      = (string) The search query hint
--       ["search_scroll"]          = (string) A scroll search request definition
--       ["search_size"]            = (number) The number of documents to return (default: 10)
--       ["search_source"]          = (string) A specific search request definition (instead of using the request body)
--       ["search_type"]            = (string) Specific search type (eg. 'dfs_then_fetch', 'count', etc)
--       ["search_types"]           = (list) A comma-separated list of types to perform the query against (default: the same type as the document)
--       ["stop_words"]             = (list) A list of stop words to be ignored
--       ["body"]                   = (array) A specific search request definition
--
-- @param    params    The mlt Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:mlt(params)
  return self:requestEndpoint("Mlt", params)
end

-------------------------------------------------------------------------------
-- Function to implement percolate
--
-- @usage
-- params["index"]                = (string) The index of the document being percolated. (Required)
--       ["type"]                 = (string) The type of the document being percolated. (Required)
--       ["id"]                   = (string) Substitute the document in the request body with a document that is
--       known by the specified id. On top of the id, the index and type parameter will be used to retrieve the document
--       from within the cluster. (Required)
--       ["routing"]              = (list) A comma-separated list of specific routing values
--       ["preference"]           = (string) Specify the node or shard the operation should be performed on
--       ["ignore_unavailable"]   = (boolean) Whether specified concrete indices should be ignored when
--       unavailable (missing or closed)
--       ["allow_no_indices"]     = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]     = (enum) Whether to expand wildcard expression to concrete indices that are
--       ["percolate_index"]      = (string) The index to percolate the document into. Defaults to index.
--       ["percolate_type"]       = (string) The type to percolate document into. Defaults to type.
--       ["percolate_routing"]    = (string) The routing value to use when percolating the existing document.
--       ["percolate_preference"] = (string) Which shard to prefer when executing the percolate request.
--       ["percolate_format"]     = (enum) Return an array of matching query IDs instead of objects (ids)
--       ["version"]              = (number) Explicit version number for concurrency control
--       ["version_type"]         = (enum) Specific version type (internal,external,external_gte,force)
--       ["body"]                 = The percolator request definition using the percolate DSL
--
-- @param    params    The percolate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:percolate(params)
  return self:requestEndpoint("Percolate", params)
end

-------------------------------------------------------------------------------
-- Function to search a particular document
--
-- @usage
-- params["index"]                    = (list) A comma-separated list of index names to search; use '_all' or empty string to perform the operation on all indices
--       ["type"]                     = (list) A comma-separated list of document types to search; leave empty to perform the operation on all types
--       ["analyzer"]                 = (string) The analyzer to use for the query string
--       ["analyze_wildcard"]         = (boolean) Specify whether wildcard and prefix queries should be analyzed (default: false)
--       ["default_operator"]         = (enum) The default operator for query string query (AND or OR)
--       ["df"]                       = (string) The field to use as default where no field prefix is given in the query string
--       ["explain"]                  = (boolean) Specify whether to return detailed information about score computation as part of a hit
--       ["fields"]                   = (list) A comma-separated list of fields to return as part of a hit
--       ["from"]                     = (number) Starting offset (default: 0)
--       ["ignore_indices"]           = (enum) When performed on multiple indices, allows to ignore 'missing' ones
--       ["indices_boost"]            = (list) Comma-separated list of index boosts
--       ["lenient"]                  = (boolean) Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
--       ["lowercase_expanded_terms"] = (boolean) Specify whether query terms should be lowercased
--       ["preference"]               = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["q"]                        = (string) Query in the Lucene query string syntax
--       ["routing"]                  = (list) A comma-separated list of specific routing values
--       ["scroll"]                   = (duration) Specify how long a consistent view of the index should be maintained for scrolled search
--       ["search_type"]              = (enum) Search operation type
--       ["size"]                     = (number) Number of hits to return (default: 10)
--       ["sort"]                     = (list) A comma-separated list of <field>:<direction> pairs
--       ["source"]                   = (string) The URL-encoded request definition using the Query DSL (instead of using request body)
--       ["_source"]                  = (list) True or false to return the _source field or not, or a list of fields to return
--       ["_source_exclude"]          = (list) A list of fields to exclude from the returned _source field
--       ["_source_include"]          = (list) A list of fields to extract and return from the _source field
--       ["stats"]                    = (list) Specific "tag" of the request for logging and statistical purposes
--       ["suggest_field"]            = (string) Specify which field to use for suggestions
--       ["suggest_mode"]             = (enum) Specify suggest mode
--       ["suggest_size"]             = (number) How many suggestions to return in response
--       ["suggest_text"]             = (text) The source text for which the suggestions should be returned
--       ["timeout"]                  = (time) Explicit operation timeout
--       ["version"]                  = (boolean) Specify whether to return document version as part of a hit
--       ["body"]                     = (array|string) The search definition using the Query DSL
--
-- @param    params    The search Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:search(params)
  return self:requestEndpoint("Search", params)
end

-------------------------------------------------------------------------------
-- Function to implement the search exists functionality
--
-- @usage
-- params["index"]                    = (list) A comma-separated list of index names to search; use '_all' or empty string to perform the operation on all indices
--       ["type"]                     = (list) A comma-separated list of document types to search; leave empty to perform the operation on all types
--       ["analyzer"]                 = (string) The analyzer to use for the query string
--       ["analyze_wildcard"]         = (boolean) Specify whether wildcard and prefix queries should be analyzed (default: false)
--       ["default_operator"]         = (enum) The default operator for query string query (AND or OR)
--       ["df"]                       = (string) The field to use as default where no field prefix is given in the query string
--       ["explain"]                  = (boolean) Specify whether to return detailed information about score computation as part of a hit
--       ["fields"]                   = (list) A comma-separated list of fields to return as part of a hit
--       ["from"]                     = (number) Starting offset (default: 0)
--       ["ignore_indices"]           = (enum) When performed on multiple indices, allows to ignore 'missing' ones
--       ["indices_boost"]            = (list) Comma-separated list of index boosts
--       ["lenient"]                  = (boolean) Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
--       ["lowercase_expanded_terms"] = (boolean) Specify whether query terms should be lowercased
--       ["preference"]               = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["q"]                        = (string) Query in the Lucene query string syntax
--       ["routing"]                  = (list) A comma-separated list of specific routing values
--       ["scroll"]                   = (duration) Specify how long a consistent view of the index should be maintained for scrolled search
--       ["search_type"]              = (enum) Search operation type
--       ["size"]                     = (number) Number of hits to return (default: 10)
--       ["sort"]                     = (list) A comma-separated list of <field>:<direction> pairs
--       ["source"]                   = (string) The URL-encoded request definition using the Query DSL (instead of using request body)
--       ["_source"]                  = (list) True or false to return the _source field or not, or a list of fields to return
--       ["_source_exclude"]          = (list) A list of fields to exclude from the returned _source field
--       ["_source_include"]          = (list) A list of fields to extract and return from the _source field
--       ["stats"]                    = (list) Specific "tag" of the request for logging and statistical purposes
--       ["suggest_field"]            = (string) Specify which field to use for suggestions
--       ["suggest_mode"]             = (enum) Specify suggest mode
--       ["suggest_size"]             = (number) How many suggestions to return in response
--       ["suggest_text"]             = (text) The source text for which the suggestions should be returned
--       ["timeout"]                  = (time) Explicit operation timeout
--       ["version"]                  = (boolean) Specify whether to return document version as part of a hit
--       ["body"]                     = (array|string) The search definition using the Query DSL
--
-- @param    params    The searchExists Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:searchExists(params)
  return self:requestEndpoint("SearchExists", params)
end

-------------------------------------------------------------------------------
-- Function to search the shards
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names to search; use '_all' or empty string to perform the operation on all indices
--       ["type"]               = (list) A comma-separated list of document types to search; leave empty to perform the operation on all types
--       ["preference"]         = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["routing"]            = (string) Specific routing value
--       ["local"]              = (bool) Return local information, do not retrieve the state from master node (default: false)
--       ["ignore_unavailable"] = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]   = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--
-- @param    params    The searchShards Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:searchShards(params)
  return self:requestEndpoint("SearchShards", params)
end

-------------------------------------------------------------------------------
-- Delete Template function
--
-- @usage
-- params["id"]           = (string) Template ID (Required)
--       ["version"]      = (number) Explicit version number for concurrency control
--       ["version_type"] = (enum) Specific version type (internal,external,external_gte,force)
--
-- @param    params    The deleteTemplate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:deleteTemplate(params)
  return self:requestEndpoint("DeleteTemplate", params)
end

-------------------------------------------------------------------------------
-- Get Template function
--
-- @usage
-- params["id"]           = (string) Template ID (Required)
--       ["version"]      = (number) Explicit version number for concurrency control
--       ["version_type"] = (enum) Specific version type (internal,external,external_gte,force)
--
-- @param    params    The getTemplate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:getTemplate(params)
  return self:requestEndpoint("GetTemplate", params)
end

-------------------------------------------------------------------------------
-- Put Template function
--
-- @usage
-- params["id"]           = (string) Template ID (Required)
--       ["version"]      = (number) Explicit version number for concurrency control
--       ["version_type"] = (enum) Specific version type (internal,external,external_gte,force)
--       ["body"]         = The document
--
-- @param    params    The putTemplate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:putTemplate(params)
  return self:requestEndpoint("PutTemplate", params)
end

-------------------------------------------------------------------------------
-- Function to search the template
--
-- @usage
-- params["index"]                    = (list) A comma-separated list of index names to search; use '_all' or empty string to perform the operation on all indices
--       ["type"]                     = (list) A comma-separated list of document types to search; leave empty to perform the operation on all types
--
-- @param    params    The searchTemplate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:searchTemplate(params)
  return self:requestEndpoint("SearchTemplate", params)
end

-------------------------------------------------------------------------------
-- Function for scrolled searching
--
-- @usage
-- params["scroll_id"] = (string) The scroll ID for scrolled search
--       ["scroll"]    = (duration) Specify how long a consistent view of the index should be maintained for scrolled search
--       ["body"]      = (string) The scroll ID for scrolled search
--
-- @param    params    The scroll Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:scroll(params)
  return self:requestEndpoint("Scroll", params)
end

-------------------------------------------------------------------------------
-- Function to clear a scroll
--
-- @usage
-- params["scroll_id"] = (string) The scroll ID for scrolled search
--       ["scroll"]    = (duration) Specify how long a consistent view of the index should be maintained for scrolled search
--       ["body"]      = (string) The scroll ID for scrolled search
--
-- @param    params    The clearScroll Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:clearScroll(params)
  return self:requestEndpoint("Scroll", params, {
    clear = true;
  })
end

-- Function to search multiple document
--
-- @usage
-- params["index"]       = (list) A comma-separated list of index names to use as default
--       ["type"]        = (list) A comma-separated list of document types to use as default
--       ["search_type"] = (enum) Search operation type
--       ["body"]        = (array|string) The request definitions (metadata-search request definition pairs), separated by newlines
--
-- @param    params    The msearch Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:msearch(params)
  return self:requestEndpoint("MSearch", params)
end

-------------------------------------------------------------------------------
-- Function to create a new document
--
-- @usage
-- params["index"]        = (string) The name of the index (Required)
--       ["type"]         = (string) The type of the document (Required)
--       ["id"]           = (string) Specific document ID (when the POST method is used)
--       ["consistency"]  = (enum) Explicit write consistency setting for the operation
--       ["parent"]       = (string) ID of the parent document
--       ["percolate"]    = (string) Percolator queries to execute while indexing the document
--       ["refresh"]      = (boolean) Refresh the index after performing the operation
--       ["replication"]  = (enum) Specific replication type
--       ["routing"]      = (string) Specific routing value
--       ["timeout"]      = (time) Explicit operation timeout
--       ["timestamp"]    = (time) Explicit timestamp for the document
--       ["ttl"]          = (duration) Expiration time for the document
--       ["version"]      = (number) Explicit version number for concurrency control
--       ["version_type"] = (enum) Specific version type
--       ["body"]         = (array) The document
--
-- @param    params    The create Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:create(params)
  return self:requestEndpoint("Index", params, {
    createIfAbsent = true
  })
end

-------------------------------------------------------------------------------
-- Function to make bulk requests
--
-- @usage
-- params["index"]       = (string) Default index for items which don"t provide one
--       ["type"]        = (string) Default document type for items which don"t provide one
--       ["consistency"] = (enum) Explicit write consistency setting for the operation
--       ["refresh"]     = (boolean) Refresh the index after performing the operation
--       ["replication"] = (enum) Explicitly set the replication type
--       ["body"]        = (array) Array of requests
--
-- @param    params    The bulk Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:bulk(params)
  return self:requestEndpoint("Bulk", params)
end

-------------------------------------------------------------------------------
-- Function to suggest similar looking terms
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names to restrict the operation; use '_all' or empty string to perform the operation on all indices
--       ["ignore_indices"] = (enum) When performed on multiple indices, allows to ignore 'missing' ones
--       ["preference"]     = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["routing"]        = (string) Specific routing value
--       ["source"]         = (string) The URL-encoded request definition (instead of using request body)
--       ["body"]           = (array) The request definition
--
-- @param    params    The suggest Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:suggest(params)
  return self:requestEndpoint("Suggest", params)
end

-------------------------------------------------------------------------------
-- Function to compute a score explanation for a query and a specific document
--
-- @usage
-- params["id"]                       = (string) The document ID (Required)
--       ["index"]                    = (string) The name of the index (Required)
--       ["type"]                     = (string) The type of the document (Required)
--       ["analyze_wildcard"]         = (boolean) Specify whether wildcards and prefix queries in the query string query should be analyzed (default: false)
--       ["analyzer"]                 = (string) The analyzer for the query string query
--       ["default_operator"]         = (enum) The default operator for query string query (AND or OR)
--       ["df"]                       = (string) The default field for query string query (default: _all)
--       ["fields"]                   = (list) A comma-separated list of fields to return in the response
--       ["lenient"]                  = (boolean) Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
--       ["lowercase_expanded_terms"] = (boolean) Specify whether query terms should be lowercased
--       ["parent"]                   = (string) The ID of the parent document
--       ["preference"]               = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["q"]                        = (string) Query in the Lucene query string syntax
--       ["routing"]                  = (string) Specific routing value
--       ["source"]                   = (string) The URL-encoded query definition (instead of using the request body)
--       ["_source"]                  = (list) True or false to return the _source field or not, or a list of fields to return
--       ["_source_exclude"]          = (list) A list of fields to exclude from the returned _source field
--       ["_source_include"]          = (list) A list of fields to extract and return from the _source field
--       ["body"]                     = (string) The URL-encoded query definition (instead of using the request body)
--
-- @param    params    The explain Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:explain(params)
  return self:requestEndpoint("Explain", params)
end

-------------------------------------------------------------------------------
-- Function to update a particular document
--
-- @usage
-- params["id"]                = (string) Document ID (Required)
--       ["index"]             = (string) The name of the index (Required)
--       ["type"]              = (string) The type of the document (Required)
--       ["consistency"]       = (enum) Explicit write consistency setting for the operation
--       ["fields"]            = (list) A comma-separated list of fields to return in the response
--       ["lang"]              = (string) The script language (default: mvel)
--       ["parent"]            = (string) ID of the parent document
--       ["percolate"]         = (string) Perform percolation during the operation; use specific registered query name, attribute, or wildcard
--       ["refresh"]           = (boolean) Refresh the index after performing the operation
--       ["replication"]       = (enum) Specific replication type
--       ["retry_on_conflict"] = (number) Specify how many times should the operation be retried when a conflict occurs (default: 0)
--       ["routing"]           = (string) Specific routing value
--       ["script"]            = () The URL-encoded script definition (instead of using request body)
--       ["timeout"]           = (time) Explicit operation timeout
--       ["timestamp"]         = (time) Explicit timestamp for the document
--       ["ttl"]               = (duration) Expiration time for the document
--       ["version_type"]      = (number) Explicit version number for concurrency control
--       ["body"]              = (array) The request definition using either 'script' or partial 'doc'
--
-- @param    params    The update Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:update(params)
  return self:requestEndpoint("Update", params)
end

-------------------------------------------------------------------------------
-- Function to get the field stats
--
-- @usage
-- params["index"]              = (list) A comma-separated list of indices to restrict the results
--       ["fields"]             = (list) A comma-separated list of fields for to get field statistics for (min value, max value, and more)
--       ["level"]              = (enum) Defines if field stats should be returned on a per index level or on a cluster wide level
--       ["ignore_unavailable"] = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]   = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--
-- @param    params    The fieldStats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:fieldStats(params)
  return self:requestEndpoint("FieldStats", params)
end

-------------------------------------------------------------------------------
-- Function to reindex one index to another
--
-- @usage
-- params["refresh"]             = (boolean) Should the effected indexes be refreshed?
--       ["timeout"]             = (time) Time each individual bulk request should wait for shards that are
--       ["consistency"]         = (enum) Explicit write consistency setting for the operation (one,quorum,all)
--       ["wait_for_completion"] = (boolean) Should the request should block until the reindex is complete.
--       ["body"]                = The search definition using the Query DSL and the prototype for the index
--       request.
--
-- @param    params    The reIndex Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:reIndex(params)
  return self:requestEndpoint("ReIndex", params)
end

-------------------------------------------------------------------------------
-- Function to render a template
--
-- @usage
-- params["id"]   = (string) The id of the stored search template
--       ["body"] = The search definition template and its params
--
-- @param    params    The renderSearchTemplate Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:renderSearchTemplate(params)
  return self:requestEndpoint("RenderSearchTemplate", params)
end

-------------------------------------------------------------------------------
-- Function to return information and statistics on terms in the fields
--
-- @usage
-- params["index"]            = (string) The index in which the document resides. (Required)
--       ["type"]             = (string) The type of the document. (Required)
--       ["id"]               = (string) The id of the document, when not specified a doc param should be
--       supplied.
--       ["term_statistics"]  = (boolean) Specifies if total term frequency and document frequency should be
--       ["field_statistics"] = (boolean) Specifies if document count, sum of document frequencies and sum of
--       ["dfs"]              = (boolean) Specifies if distributed frequencies should be returned instead shard
--       ["fields"]           = (list) A comma-separated list of fields to return.
--       random).
--       ["routing"]          = (string) Specific routing value.
--       ["parent"]           = (string) Parent id of documents.
--       true).
--       ["version"]          = (number) Explicit version number for concurrency control
--       ["version_type"]     = (enum) Specific version type (internal,external,external_gte,force)
--       ["body"]             = Define parameters and or supply a document to get termvectors for. See
--       documentation.
--
-- @param    params    The termvectors Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:termvectors(params)
  return self:requestEndpoint("termvectors", params)
end

-------------------------------------------------------------------------------
-- Function to update documents in an index by specifying search query
--
-- @usage
-- params["index"]                    = (list) A comma-separated list of index names to search; use '_all' or
--       empty string to perform the operation on all indices (Required)
--       ["type"]                     = (list) A comma-separated list of document types to search; leave empty to
--       perform the operation on all types
--       ["analyzer"]                 = (string) The analyzer to use for the query string
--       ["analyze_wildcard"]         = (boolean) Specify whether wildcard and prefix queries should be analyzed
--       ["default_operator"]         = (enum) The default operator for query string query (AND or OR) (AND,OR)
--       ["df"]                       = (string) The field to use as default where no field prefix is given in the
--       query string
--       ["explain"]                  = (boolean) Specify whether to return detailed information about score
--       computation as part of a hit
--       ["fields"]                   = (list) A comma-separated list of fields to return as part of a hit
--       ["fielddata_fields"]         = (list) A comma-separated list of fields to return as the field data
--       representation of a field for each hit
--       ["ignore_unavailable"]       = (boolean) Whether specified concrete indices should be ignored when
--       unavailable (missing or closed)
--       ["allow_no_indices"]         = (boolean) Whether to ignore if a wildcard indices expression resolves into
--       no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["conflicts"]                = (enum) What to do when the reindex hits version conflicts? (abort,proceed)
--       ["expand_wildcards"]         = (enum) Whether to expand wildcard expression to concrete indices that are
--       ["lenient"]                  = (boolean) Specify whether format-based query failures (such as providing
--       text to a numeric field) should be ignored
--       ["lowercase_expanded_terms"] = (boolean) Specify whether query terms should be lowercased
--       ["preference"]               = (string) Specify the node or shard the operation should be performed on
--       ["q"]                        = (string) Query in the Lucene query string syntax
--       ["routing"]                  = (list) A comma-separated list of specific routing values
--       ["scroll"]                   = (duration) Specify how long a consistent view of the index should be
--       maintained for scrolled search
--       ["search_type"]              = (enum) Search operation type (query_then_fetch,dfs_query_then_fetch)
--       ["search_timeout"]           = (time) Explicit timeout for each search request. Defaults to no timeout.
--       ["sort"]                     = (list) A comma-separated list of <field>:<direction> pairs
--       ["_source"]                  = (list) True or false to return the _source field or not, or a list of
--       fields to return
--       ["_source_exclude"]          = (list) A list of fields to exclude from the returned _source field
--       ["_source_include"]          = (list) A list of fields to extract and return from the _source field
--       ["terminate_after"]          = (number) The maximum number of documents to collect for each shard, upon
--       reaching which the query execution will terminate early.
--       ["stats"]                    = (list) Specific "tag" of the request for logging and statistical purposes
--       ["suggest_field"]            = (string) Specify which field to use for suggestions
--       ["suggest_size"]             = (number) How many suggestions to return in response
--       ["suggest_text"]             = (text) The source text for which the suggestions should be returned
--       ["timeout"]                  = (time) Time each individual bulk request should wait for shards that are
--       ["track_scores"]             = (boolean) Whether to calculate and return scores even if they are not used
--       for sorting
--       ["version"]                  = (boolean) Specify whether to return document version as part of a hit
--       ["version_type"]             = (boolean) Should the document increment the version number (internal) on
--       hit or not (reindex)
--       ["request_cache"]            = (boolean) Specify if request cache should be used for this request or not,
--       defaults to index level setting
--       ["refresh"]                  = (boolean) Should the effected indexes be refreshed?
--       ["consistency"]              = (enum) Explicit write consistency setting for the operation
--       (one,quorum,all)
--       ["scroll_size"]              = (integer) Size on the scroll request powering the update_by_query
--       ["wait_for_completion"]      = (boolean) Should the request should block until the reindex is complete.
--       ["body"]                     = The search definition using the Query DSL
--
-- @param    params    The termvectors Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Client:updateByQuery(params)
  return self:requestEndpoint("UpdateByQuery", params)
end

-------------------------------------------------------------------------------
-- @local
-- Initializes the Client parameters
-------------------------------------------------------------------------------
function Client:setClientParameters()
  self.cat = self.settings.cat
  self.cluster = self.settings.cluster
  self.nodes = self.settings.nodes
  self.indices = self.settings.indices
  self.snapshot = self.settings.snapshot
  self.tasks = self.settings.tasks
end

-------------------------------------------------------------------------------
-- @local
-- Returns an instance of Client class
-------------------------------------------------------------------------------
function Client:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.hosts = o.hosts or {{}}
  o.params = o.params or {}
  if type(o.hosts) == "table" and o.hosts[1] == nil then
    local temp = o.hosts
    o.hosts = {}
    o.hosts[1] = temp
  end
  o.settings = Settings:new{
    user_hosts = o.hosts,
    user_params = o.params
  }
  o:setClientParameters()
  return o
end

return Client

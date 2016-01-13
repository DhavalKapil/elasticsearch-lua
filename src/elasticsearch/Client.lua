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

-- The cluster instance
Client.cluster = nil

-- The nodes instance
Client.nodes = nil

-- The indices instance
Client.indices = nil

-------------------------------------------------------------------------------
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint        The string denoting the endpoint
-- @param   params          The parameters to be passed
-- @param   endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:exists(params)
  local temp, err = self:requestEndpoint("Get", params, {
    checkOnlyExistance = true
  })
  if err == nil then
    -- Successfull request
    return true
  elseif err:match("Invalid response code") then
    -- Wrong response code
    return false
  else
    -- Some other error, notify user
    return nil, err
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:mget(params)
  return self:requestEndpoint("Mget", params)
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
-- @param    params    The index Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:delete(params)
  return self:requestEndpoint("Delete", params)
end

-------------------------------------------------------------------------------
-- Function to get the count
--
-- @usage
-- params["index"]              = (list) A comma-separated list of indices to restrict the results
--       ["type"]               = (list) A comma-separated list of types to restrict the results
--       ["min_score"]          = (number) Include only documents with a specific '_score' value in the result
--       ["preference"]         = (string) Specify the node or shard the operation should be performed on (default: random)
--       ["routing"]            = (string) Specific routing value
--       ["source"]             = (string) The URL-encoded query definition (instead of using the request body)
--       ["body"]               = (array) A query to restrict the results (optional)
--       ["ignore_unavailable"] = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]   = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--
-- @param    params    The count Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:count(params)
  return self:requestEndpoint("Count", params)
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:searchShards(params)
  return self:requestEndpoint("SearchShards", params)
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:msearch(params)
  return self:requestEndpoint("Msearch", params)
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:fieldStats(params)
  return self:requestEndpoint("FieldStats", params)
end

-------------------------------------------------------------------------------
-- Initializes the Client parameters
-------------------------------------------------------------------------------
function Client:setClientParameters()
  self.cluster = self.settings.cluster
  self.nodes = self.settings.nodes
  self.indices = self.settings.indices
end

-------------------------------------------------------------------------------
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

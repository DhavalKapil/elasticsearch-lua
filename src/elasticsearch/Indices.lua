--- The Indices class
-- @classmod Indices
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Indices = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The transport module
Indices.transport = nil

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
function Indices:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints.Indices." .. endpoint)
  local endpoint = Endpoint:new{
    transport = self.transport,
    endpointParams = endpointParams or {}
  }
  if params ~= nil then
    -- Parameters need to be set
    local err = endpoint:setParams(params);
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
-- Delete Alias function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names (supports wildcards); use '_all' for
--       all indices (Required)
--       ["name"]           = (list) A comma-separated list of aliases to delete (supports wildcards); use '_all'
--       to delete all aliases for the specified indices. (Required)
--       ["timeout"]        = (time) Explicit timestamp for the document
--       ["master_timeout"] = (time) Specify timeout for connection to master
--
-- @param    params    The delete alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:deleteAlias(params)
  return self:requestEndpoint("DeleteAlias", params)
end

-------------------------------------------------------------------------------
-- Exists Alias function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names to filter aliases
--       ["name"]               = (list) A comma-separated list of alias names to return
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       [open,closed])
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The exists alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:existsAlias(params)
  local temp, err = self:requestEndpoint("ExistsAlias", params)
  if err == 200 then
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
-- Get Alias function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names to filter aliases
--       ["name"]               = (list) A comma-separated list of alias names to return
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       [open,closed])
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The get alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getAlias(params)
  return self:requestEndpoint("GetAlias", params)
end

-------------------------------------------------------------------------------
-- Put Alias function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names the alias should point to (supports
--       wildcards); use '_all' to perform the operation on all indices. (Required)
--       ["name"]           = (string) The name of the alias to be created or updated (Required)
--       ["timeout"]        = (time) Explicit timestamp for the document
--       ["master_timeout"] = (time) Specify timeout for connection to master
--       ["body"]           = The settings for the alias, such as 'routing' or 'filter'
--
-- @param    params    The put alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:putAlias(params)
  return self:requestEndpoint("PutAlias", params)
end

-------------------------------------------------------------------------------
-- Get Aliases function
--
-- @usage
-- params["index"]   = (list) A comma-separated list of index names to filter aliases
--       ["name"]    = (list) A comma-separated list of alias names to filter
--       ["timeout"] = (time) Explicit operation timeout
--       ["local"]   = (boolean) Return local information, do not retrieve the state from master node (default:
--       false)
--
-- @param    params    The get aliases Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getAliases(params)
  return self:requestEndpoint("GetAliases", params)
end

-------------------------------------------------------------------------------
-- Update Aliases function
--
-- @usage
-- params["timeout"]        = (time) Request timeout
--       ["master_timeout"] = (time) Specify timeout for connection to master
--       ["body"]           = The definition of 'actions' to perform
--
-- @param    params    The update aliases Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:updateAliases(params)
  return self:requestEndpoint("UpdateAliases", params)
end

-------------------------------------------------------------------------------
-- Clear Cache function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index name to limit the operation
--       ["field_data"]         = (boolean) Clear field data
--       ["fielddata"]          = (boolean) Clear field data
--       ["fields"]             = (list) A comma-separated list of fields to clear when using the 'field_data'
--       parameter (default: all)
--       ["query"]              = (boolean) Clear query caches
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["recycler"]           = (boolean) Clear the recycler cache
--       ["request"]            = (boolean) Clear request cache
--
-- @param    params    The clear cache Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:clearCache(params)
  return self:requestEndpoint("ClearCache", params)
end

-------------------------------------------------------------------------------
-- Delete Mapping function
--
-- @usage
-- params["index"] = (list) A comma-separated list of index names; use '_all' for all indices (Required)
--       ["type"]  = (string) The name of the document type to delete (Required)
--
-- @param    params    The delete mapping Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:deleteMapping(params)
  return self:requestEndpoint("DeleteMapping", params)
end

-------------------------------------------------------------------------------
-- Get Mapping function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names
--       ["type"]               = (list) A comma-separated list of document types
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The get mapping Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getMapping(params)
  return self:requestEndpoint("GetMapping", params)
end

-------------------------------------------------------------------------------
-- Get Feild Mapping function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names
--       ["type"]               = (list) A comma-separated list of document types
--       ["fields"]             = (list) A comma-separated list of fields (Required)
--       ["include_defaults"]   = (boolean) Whether the default mapping values should be returned as well
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The get field mapping Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getFieldMapping(params)
  self:requestEndpoint("GetFieldMapping", params)
end

-------------------------------------------------------------------------------
-- Put Mapping function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names the mapping should be added to
--       (supports wildcards); use '_all' or omit to add the mapping on all indices.
--       ["type"]               = (string) The name of the document type (Required)
--       ["timeout"]            = (time) Explicit operation timeout
--       ["master_timeout"]     = (time) Specify timeout for connection to master
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["ignore_conflicts"]   = (boolean) Specify whether to ignore conflicts while updating the mapping
--       (default: false)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["update_all_types"]   = (boolean) Whether to update the mapping for all fields with the same name across
--       all types or not
--       ["body"]               = The mapping definition
--
-- @param    params    The put mapping Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:putMapping(params)
  self:requestEndpoint("PutMapping", params)
end

-------------------------------------------------------------------------------
-- Get Settings function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["name"]               = (list) The name of the settings that should be included
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       [open,closed])
--       ["flat_settings"]      = (boolean) Return settings in flat format (default: false)
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["human"]              = (boolean) Whether to return version and creation date values in human-readable
--       format. (default: false)
--
-- @param    params    The get settings Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getSettings(params)
  return self:requestEndpoint("GetSettings", params)
end

-------------------------------------------------------------------------------
-- Put Settings function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["master_timeout"]     = (time) Specify timeout for connection to master
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["flat_settings"]      = (boolean) Return settings in flat format (default: false)
--       ["body"]               = The index settings to be updated
--
-- @param    params    The put settings Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:putSettings(params)
  return self:requestEndpoint("PutSettings", params)
end

-------------------------------------------------------------------------------
-- Delete Template function
--
-- @usage
-- params["name"]           = (string) The name of the template (Required)
--       ["timeout"]        = (time) Explicit operation timeout
--       ["master_timeout"] = (time) Specify timeout for connection to master
--
-- @param    params    The delete template Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:deleteTemplate(params)
  return self:requestEndpoint("DeleteTemplate", params)
end

-------------------------------------------------------------------------------
-- Exists Template function
--
-- @usage
-- params["name"]           = (string) The name of the template (Required)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The exists template Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:existsTemplate(params)
  local temp, err = self:requestEndpoint("ExistsTemplate", params)
  if err == 200 then
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
-- Get Template function
--
-- @usage
-- params["name"]           = (list) The comma separated names of the index templates (Required)
--       ["flat_settings"]  = (boolean) Return settings in flat format (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The get template Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getTemplate(params)
  return self:requestEndpoint("GetTemplate", params)
end

-------------------------------------------------------------------------------
-- Put Template function
--
-- @usage
-- params["name"]           = (string) The name of the template (Required)
--       ["order"]          = (number) The order for this template when merging multiple matching ones (higher
--       numbers are merged later, overriding the lower numbers)
--       ["create"]         = (boolean) Whether the index template should only be added if new or can also replace
--       an existing one (default: false)
--       ["timeout"]        = (time) Explicit operation timeout
--       ["master_timeout"] = (time) Specify timeout for connection to master
--       ["flat_settings"]  = (boolean) Return settings in flat format (default: false)
--       ["body"]           = The template definition
--
-- @param    params    The put template Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:putTemplate(params)
  return self:requestEndpoint("PutTemplate", params)
end

-------------------------------------------------------------------------------
-- Exists Type function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names; use '_all' to check the types
--       across all indices (Required)
--       ["type"]               = (list) A comma-separated list of document types to check (Required)
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The put template Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:existsType(params)
  local temp, err = self:requestEndpoint("ExistsType", params)
  if err == 200 then
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
-- Get Upgrade function
--
-- @usage
-- params["index"]                 = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["ignore_unavailable"]    = (boolean) Whether specified concrete indices should be ignored when
--       unavailable (missing or closed)
--       ["wait_for_completion"]   = (boolean) Specify whether the request should block until the all segments are
--       upgraded (default: false)
--       ["only_ancient_segments"] = (boolean) If true, only ancient (an older Lucene major release) segments will
--       be upgraded
--       ["allow_no_indices"]      = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]      = (enum) Whether to expand wildcard expression to concrete indices that are
--       open, closed or both. (open,closed,none,all) (default: open)
--       ["human"]                 = (boolean) Whether to return time and byte values in human-readable format.
--       (default: false)
--
-- @param    params    The get upgrade Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getUpgrade(params)
  return self:requestEndpoint("GetUpgrade", params)
end

-------------------------------------------------------------------------------
-- Upgrade function
--
-- @usage
-- params["index"]                 = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["allow_no_indices"]      = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]      = (enum) Whether to expand wildcard expression to concrete indices that are
--       open, closed or both. (open,closed,none,all) (default: open)
--       ["ignore_unavailable"]    = (boolean) Whether specified concrete indices should be ignored when
--       unavailable (missing or closed)
--       ["wait_for_completion"]   = (boolean) Specify whether the request should block until the all segments are
--       upgraded (default: false)
--       ["only_ancient_segments"] = (boolean) If true, only ancient (an older Lucene major release) segments will
--       be upgraded
--
-- @param    params    The upgrade Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:upgrade(params)
  return self:requestEndpoint("PostUpgrade", params)
end

-------------------------------------------------------------------------------
-- Validate Query function
--
-- @usage
-- params["index"]                    = (list) A comma-separated list of index names to restrict the operation;
--       use '_all' or empty string to perform the operation on all indices
--       ["type"]                     = (list) A comma-separated list of document types to restrict the operation;
--       leave empty to perform the operation on all types
--       ["explain"]                  = (boolean) Return detailed information about the error
--       ["ignore_indices"]           = (enum) When performed on multiple indices, allows to ignore 'missing' ones
--       ["ignore_unavailable"]       = (boolean) Whether specified concrete indices should be ignored when
--       unavailable (missing or closed)
--       ["allow_no_indices"]         = (boolean) Whether to ignore if a wildcard indices expression resolves into
--       no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]         = (enum) Whether to expand wildcard expression to concrete indices that are
--       open, closed or both. (open,closed,none,all) (default: open)
--       ["operation_threading"]      = TODO: ?
--       ["q"]                        = (string) Query in the Lucene query string syntax
--       ["analyzer"]                 = (string) The analyzer to use for the query string
--       ["analyze_wildcard"]         = (boolean) Specify whether wildcard and prefix queries should be analyzed
--       (default: false)
--       ["default_operator"]         = (enum) The default operator for query string query (AND or OR) (AND,OR)
--       (default: OR)
--       ["df"]                       = (string) The field to use as default where no field prefix is given in the
--       query string
--       ["lenient"]                  = (boolean) Specify whether format-based query failures (such as providing
--       text to a numeric field) should be ignored
--       ["lowercase_expanded_terms"] = (boolean) Specify whether query terms should be lowercased
--       ["rewrite"]                  = (boolean) Provide a more detailed explanation showing the actual Lucene
--       query that will be executed.
--       ["source"]              = (string) The URL-encoded query definition (instead of using the request body)
--       ["body"]                     = The query definition specified with the Query DSL
--
-- @param    params    The validate query Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:validateQuery(params)
  return self:requestEndpoint("ValidateQuery", params)
end

-------------------------------------------------------------------------------
-- Delete Warmer function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names to delete warmers from (supports
--       wildcards); use '_all' to perform the operation on all indices. (Required)
--       ["name"]           = (list) A comma-separated list of warmer names to delete (supports wildcards); use
--       '_all' to delete all warmers in the specified indices. You must specify a name either in the uri or in the
--       parameters.
--       ["master_timeout"] = (time) Specify timeout for connection to master
--
-- @param    params    The delete warmer Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:deleteWarmer(params)
  return self:requestEndpoint("DeleteWarmer", params)
end

-------------------------------------------------------------------------------
-- Get Warmer function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names to restrict the operation; use
--       '_all' to perform the operation on all indices
--       ["name"]               = (list) The name of the warmer (supports wildcards); leave empty to get all
--       warmers
--       ["type"]               = (list) A comma-separated list of document types to restrict the operation; leave
--       empty to perform the operation on all types
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The get warmer Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getWarmer(params)
  return self:requestEndpoint("GetWarmer", params)
end

-------------------------------------------------------------------------------
-- Put Warmer function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names to register the warmer for; use
--       '_all' or omit to perform the operation on all indices
--       ["name"]               = (string) The name of the warmer (Required)
--       ["type"]               = (list) A comma-separated list of document types to register the warmer for;
--       leave empty to perform the operation on all types
--       ["master_timeout"]     = (time) Specify timeout for connection to master
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed) in the search request to warm
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices in the search request to warm. (This includes '_all' string or when no indices have been
--       specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both, in the search request to warm. (open,closed,none,all) (default: open)
--       ["request_cache"]      = (boolean) Specify whether the request to be warmed should use the request cache,
--       defaults to index level setting
--       ["body"]               = The search request definition for the warmer (query, filters, facets, sorting,
--       etc)
--
-- @param    params    The put warmer Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:putWarmer(params)
  return self:requestEndpoint("PutWarmer", params)
end

-------------------------------------------------------------------------------
-- Function to check whether an index exists or not
--
-- @usage
-- params["index"] = (list) A comma-separated list of indices to check (Required)
--
-- @param    params    The exists Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:exists(params)
  local temp, err = self:requestEndpoint("Exists", params)
  if err == 200 then
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
-- Function to get an index
--
-- @usage
-- params["index"] = (list) A comma-separated list of indices to check (Required)
--       ["feature"] = (list) A comma-separated list of features to return
--       ["ignore_unavailable"] = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]   = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--       ["local"]   = (bool) Return local information, do not retrieve the state from master node (default: false)
--
-- @param    params    The get Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:get(params)
  return self:requestEndpoint("Get", params)
end

-------------------------------------------------------------------------------
-- Function to delete indices
--
-- @usage
-- params["index"]   = (list) A comma-separated list of indices to delete; use '_all' or empty string to delete all indices
--       ["timeout"] = (time) Explicit operation timeout
--
-- @param    params    The delete Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:delete(params)
  return self:requestEndpoint("Delete", params)
end

-------------------------------------------------------------------------------
-- Function to create an index
--
-- @usage
-- params["index"]   = (string) The name of the index (Required)
--       ["timeout"] = (time) Explicit operation timeout
--       ["body"]    = (time) Explicit operation timeout
--
-- @param    params    The create Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:create(params)
  return self:requestEndpoint("Create", params)
end

-------------------------------------------------------------------------------
-- Function to optimize an index
--
-- @usage
-- params["index"]                = (list) A comma-separated list of index names; use '_all' or empty string to perform the operation on all indices
--       ["flush"]                = (boolean) Specify whether the index should be flushed after performing the operation (default: true)
--       ["max_num_segments"]     = (number) The number of segments the index should be merged into (default: dynamic)
--       ["only_expunge_deletes"] = (boolean) Specify whether the operation should only expunge deleted documents
--       ["operation_threading"]  = () TODO: ?
--       ["refresh"]              = (boolean) Specify whether the index should be refreshed after performing the operation (default: true)
--       ["wait_for_merge"]       = (boolean) Specify whether the request should block until the merge process is finished (default: true)
--       ["ignore_unavailable"]   = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]     = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]     = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--
-- @param    params    The optimize Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:optimize(params)
  return self:requestEndpoint("Optimize", params)
end

-------------------------------------------------------------------------------
-- Function to open an index
--
-- @usage
-- params["index"]   = (string) The name of the index (Required)
--       ["timeout"] = (time) Explicit operation timeout
--
-- @param    params    The open Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:open(params)
  return self:requestEndpoint("Open", params)
end

-------------------------------------------------------------------------------
-- Function to close an index
--
-- @usage
-- params["index"]   = (string) The name of the index (Required)
--       ["timeout"] = (time) Explicit operation timeout
--
-- @param    params    The open Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:close(params)
  return self:requestEndpoint("Close", params)
end

-------------------------------------------------------------------------------
-- Function to perform analysis process on a text
--
-- @usage
-- params["index"]        = (string) The name of the index to scope the operation
--       ["analyzer"]     = (string) The name of the analyzer to use
--       ["field"]        = (string) Use the analyzer configured for this field (instead of passing the analyzer name)
--       ["filters"]      = (list) A comma-separated list of filters to use for the analysis
--       ["prefer_local"] = (boolean) With 'true', specify that a local shard should be used if available, with 'false', use a random shard (default: true)
--       ["text"]         = (string) The text on which the analysis should be performed (when request body is not used)
--       ["tokenizer"]    = (string) The name of the tokenizer to use for the analysis
--       ["format"]       = (enum) Format of the output
--       ["body"]         = (enum) Format of the output
--
-- @param    params    The analyze Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:analyze(params)
  return self:requestEndpoint("Analyze", params)
end

-------------------------------------------------------------------------------
-- Function to refresh an index
--
-- @usage
--
-- params["index"]               = (list) A comma-separated list of index names; use '_all' or empty string to perform the operation on all indices
--       ["operation_threading"] = () TODO: ?
--       ["ignore_unavailable"]  = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]    = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]    = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--
-- @param    params    The refresh Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:refresh(params)
  return self:requestEndpoint("Refresh", params)
end

-------------------------------------------------------------------------------
-- Function to get the status of an index
--
-- @usage
-- params["index"]               = (list) A comma-separated list of index names; use '_all' or empty string to perform the operation on all indices
--       ["ignore_indices"]      = (enum) When performed on multiple indices, allows to ignore 'missing' ones
--       ["operation_threading"] = () TODO: ?
--       ["recovery"]            = (boolean) Return information about shard recovery
--       ["snapshot"]            = (boolean) TODO: ?
--
-- @param    params    The status Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:status(params)
  return self:requestEndpoint("Status", params)
end

-------------------------------------------------------------------------------
-- Function to seal an index
--
-- @usage
-- params["index"]   = (string) The name of the index
--
-- @param    params    The seal Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:seal(params)
  return self:requestEndpoint("Seal", params)
end

-------------------------------------------------------------------------------
-- Flush function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names; use '_all' or empty string for all
--       indices
--       ["force"]              = (boolean) Whether a flush should be forced even if it is not necessarily needed
--       ie. if no changes will be committed to the index. This is useful if transaction log IDs should be incremented
--       even if no uncommitted changes are present. (This setting can be considered as internal)
--       ["full"]               = (boolean) TODO: ?
--       ["wait_if_ongoing"]    = (boolean) If set to true the flush operation will block until the flush can be
--       executed if another flush operation is already executing. The default is false and will cause an exception to be
--       thrown on the shard level if another flush operation is already running.
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--
-- @param    params    The flush Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:flush(params)
  return self:requestEndpoint("Flush", params)
end

-------------------------------------------------------------------------------
-- Force Merge function
--
-- @usage
-- params["index"]                = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["flush"]                = (boolean) Specify whether the index should be flushed after performing the
--       operation (default: true)
--       ["ignore_unavailable"]   = (boolean) Whether specified concrete indices should be ignored when
--       unavailable (missing or closed)
--       ["allow_no_indices"]     = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]     = (enum) Whether to expand wildcard expression to concrete indices that are
--       open, closed or both. (open,closed,none,all) (default: open)
--       ["max_num_segments"]     = (number) The number of segments the index should be merged into (default:
--       dynamic)
--       ["only_expunge_deletes"] = (boolean) Specify whether the operation should only expunge deleted documents
--       ["operation_threading"]  = TODO: ?
--       ["wait_for_merge"]       = (boolean) Specify whether the request should block until the merge process is
--       finished (default: true)
--
-- @param    params    The force merge Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:forceMerge(params)
  return self:requestEndpoint("ForceMerge", params)
end

-------------------------------------------------------------------------------
-- Recovery function
--
-- @usage
-- params["index"]       = (list) A comma-separated list of index names; use '_all' or empty string to perform the
--       operation on all indices
--       ["detailed"]    = (boolean) Whether to display detailed information about shard recovery (default: false)
--       ["active_only"] = (boolean) Display only those recoveries that are currently on-going (default: false)
--       ["human"]       = (boolean) Whether to return time and byte values in human-readable format. (default:
--       false)
--
-- @param    params    The recovery Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:recovery(params)
  return self:requestEndpoint("Recovery", params)
end

-------------------------------------------------------------------------------
-- Segments function
--
-- @usage
-- params["index"]               = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["ignore_unavailable"]  = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]    = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]    = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["human"]               = (boolean) Whether to return time and byte values in human-readable format.
--       (default: false)
--       ["operation_threading"] = TODO: ?
--       ["verbose"]             = (boolean) Includes detailed memory usage by Lucene. (default: false)
--
-- @param    params    The segments Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:segments(params)
  return self:requestEndpoint("Segments", params)
end

-------------------------------------------------------------------------------
-- Shard Stores function
--
-- @usage
-- params["index"]               = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["status"]              = (list) A comma-separated list of statuses used to filter on shards to get store
--       information for (green,yellow,red,all)
--       ["ignore_unavailable"]  = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]    = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]    = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       closed or both. (open,closed,none,all) (default: open)
--       ["operation_threading"] = TODO: ?
--
-- @param    params    The shard stores Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:shardStores(params)
  return self:requestEndpoint("ShardStores", params)
end

-------------------------------------------------------------------------------
-- Stats function
--
-- @usage
-- params["index"]             = (list) A comma-separated list of index names; use '_all' or empty string to
--       perform the operation on all indices
--       ["metric"]            = (list) Limit the information returned the specific metrics.
--       ["completion_fields"] = (list) A comma-separated list of fields for 'fielddata' and 'suggest' index
--       metric (supports wildcards)
--       ["fielddata_fields"]  = (list) A comma-separated list of fields for 'fielddata' index metric (supports
--       wildcards)
--       ["fields"]            = (list) A comma-separated list of fields for 'fielddata' and 'completion' index
--       metric (supports wildcards)
--       ["groups"]            = (list) A comma-separated list of search groups for 'search' index metric
--       ["human"]             = (boolean) Whether to return time and byte values in human-readable format.
--       (default: false)
--       ["level"]             = (enum) Return stats aggregated at cluster, index or shard level
--       (cluster,indices,shards) (default: indices)
--       ["types"]             = (list) A comma-separated list of document types for the 'indexing' index metric
--
-- @param    params    The stats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:stats(params)
  return self:requestEndpoint("Stats", params)
end

-------------------------------------------------------------------------------
-- @local
-- Returns an instance of Indices class
-------------------------------------------------------------------------------
function Indices:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Indices

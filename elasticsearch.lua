local http = require "socket.http"
local url = require "socket.url"
local table = require "table"
local ltn12 = require "ltn12"
local json = require "cjson"


local elasticsearch = {}
local Client = {}

-------------------------------------------------------------
-- Function that makes a cURL request using luasocket library
-- Supports passing content body alongwith headers
-- 
-- @param method The method type of cURL request
-- @param url The target url to which the request is made
-- @param body The content body that is to be passed
--
-- @return respbody The response returned back after request
------------------------------------------------------------
function curl_request(method, url, body)
  body = body or nil
  local respbody = {}
  
  -- Checking if body is to be sent or not
  if body == nil then
    http.request {
      method = method,
      url = url,
      sink = ltn12.sink.table(respbody)
    }
  else
    http.request {
      method = method,
      url = url,
      headers = { ["Content-Length"] = string.len(body) },
      source = ltn12.source.string(body),
      sink = ltn12.sink.table(respbody)
    }
  end

  respbody = table.concat(respbody)
  return respbody
end

------------------------------------------------------------
-- Creates a new client using appropriate configurations
--
-- @param config The configuration table(host and port)
--
-- @return table The resulting client table
------------------------------------------------------------
function Client:new(config)
  newClient = {}
  newClient.config = config
  newClient.parsed_url = {
    scheme = 'http',
    host = newClient.config.host,
    port = newClient.config.port,
  }
  self.__index = self
  return setmetatable(newClient, self)
end

------------------------------------------------------------
-- Function to index a particular document
-- Making it searchable
--
-- @param document The table document that is to be indexed
-- @return respbody The response returned back after request
------------------------------------------------------------
function Client:index(document)
  local method = ""
  parsed_url = self.parsed_url
  url_path = '/' .. document.index
  url_path = url_path .. '/' .. document.type

  -- If id is given then it will be a PUT request
  if document.id ~= nil then
    method = "PUT"
    url_path = url_path .. '/' .. document.id
  -- Otherwise a POST request
  else
    method = "POST"
  end

  parsed_url.path = url_path
  return curl_request(method, url.build(parsed_url), json.encode(document.body))
end

------------------------------------------------------------
-- Function to search for a particular document
--
-- @param document The table document that is to be searched
--
-- @return respbody The response returned back after request
------------------------------------------------------------
function Client:search(document)
  parsed_url = self.parsed_url
  url_path = '/'

  -- Checking whether index and type are mentioned or not
  if document.index ~= nil then
    url_path = '/' .. document.index
    if document.type ~= nil then
      url_path = url_path .. '/' .. document.type
    end
  end

  url_path = url_path .. '/_search'
  parsed_url.path = url_path
  return curl_request("POST", url.build(parsed_url), json.encode(document.body))
end

------------------------------------------------------------
-- Function to delete a particular document
--
-- @param document THe table document to be deleted
--
-- @return respbody The response returned back after request
------------------------------------------------------------
function Client:delete(document)
  parsed_url = self.parsed_url
  url_path = '/' .. document.index
  url_path = url_path .. '/' .. document.type
  url_path = url_path .. '/' .. document.id
  
  parsed_url.path = url_path
  return curl_request("DELETE", url.build(parsed_url))
end

------------------------------------------------------------
-- Function that returns a client table that is used
-- for further communcication with elasticsearch server
--
-- @param config The configuration table(host and port)
--
-- @return client The resulting client table
------------------------------------------------------------
function elasticsearch.client(config)
  return Client:new(config)
end

return elasticsearch

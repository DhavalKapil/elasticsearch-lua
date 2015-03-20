local http = require "socket.http"
local url = require "socket.url"
local table = require "table"
local ltn12 = require "ltn12"
local json = require "cjson"

local elasticsearch = {}

local Client = {}

function curl_request(method, url, body)
  body = body or nil
  local respbody = {}
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
  return table.concat(respbody)
end

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

function Client:index(document)
  local method = ""
  parsed_url = self.parsed_url
  url_path = '/' .. document.index
  url_path = url_path .. '/' .. document.type
  if document.id ~= nil then
    method = "PUT"
    url_path = url_path .. '/' .. document.id
  else
    method = "POST"
  end
  parsed_url.path = url_path
  return curl_request(method, url.build(parsed_url), json.encode(document.body))
end

function Client:delete(document)
  parsed_url = self.parsed_url
  url_path = '/' .. document.index
  url_path = url_path .. '/' .. document.type
  url_path = url_path .. '/' .. document.id
  parsed_url.path = url_path
  return curl_request("DELETE", url.build(parsed_url))
end

function elasticsearch.client(config)
  return Client:new(config)
end

return elasticsearch

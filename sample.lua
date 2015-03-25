elasticsearch = require "elasticsearch"
socket = require "socket"

-------------------------------------------------------------
-- Function to sleep for some amount of time
-- Allowing for the operations to complete
--
-- @param n The amount of time to sleep
-------------------------------------------------------------
function sleep(n)
  socket.sleep(n)
end

client = elasticsearch.client({ host = "localhost", port = 9200 })

print "Client created for elasticsearch\n"
sleep(0.5)

document = {
  index = "test",
  type = "user",
  id = "1",
  body = { 
    name = "vampire",
    developer = true
  }
}
response = client:index(document)

print "Document has been indexed"
print "Response returned:"
print(response .. "\n")

sleep(2)

document = {
  index = "test",
  body = {
    query = {
      query_string = {
        query = 'vampire'
      }
    }
  }
}
response = client:search(document)

print "Search query run"
print "Response returned:"
print(response .. "\n")

document = {
  index = "test",
  type = "user",
  id = "1"
}
response = client:delete(document)

sleep(2)
print "Document has been deleted"
print "Response returned:"
print(response)
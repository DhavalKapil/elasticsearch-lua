local cjson = require "cjson"

local file = "2015-01-01-15.json"
local data = {}

for line in io.lines(file) do
  data[#data+1] = cjson.decode(line)
  data[#data]["id"] = #data
  if #data == 200 then
    break
  end
end

return data

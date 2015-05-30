-----------------------------------------------------------------------------
-- Declaring module
-----------------------------------------------------------------------------
local Connection = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The protocol of the connection
Connection.protocol = "http"
-- The host where the connection should be made
Connection.host = "localhost"
-- The port at which the connection should be made
Connection.port = 9300
-- Whether the client is alive or not
Connection.alive = false


-------------------------------------------------------------------------------
-- Makes a request to target server
--
-- @param 	params 	The parameters to be passed
-- @return 	table		The reponse returned
-------------------------------------------------------------------------------
function Connection:request(params)
	-- Function body
end

-------------------------------------------------------------------------------
-- Pings the target server and sets alive variable appropriately
-------------------------------------------------------------------------------
function Connection:ping()
	-- Function body
end

-------------------------------------------------------------------------------
-- Sniffs the network to collect information about other nodes in the cluster
--
-- @return 	table		The details about other nodes
-------------------------------------------------------------------------------
function Connection:sniff()
	-- Function body
end

-- Returns an instance of Connection class
-------------------------------------------------------------------------------
function Connection:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	-- Checking options
	if type(o.protocol) ~= "string" then
		error("protocol should be of string type")
	elseif type(o.host) ~= "string" then
		error("host should be of string type")
	elseif type(o.port) ~= "number" then
		error("port should be of number type")
	elseif type(o.alive) ~= "boolean" then
		error("alive should be of boolean type")
	end

	return o
end

return Connection
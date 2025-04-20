local enet = require 'enet'


local clientpeer = nil
local enetclient = nil
local server_ip_port = 'localhost:6750'
function lovr.load()
   enetclient = enet.host_create()
   clientpeer = enetclient:connect(server_ip_port)
end

local function client_send()
   enetclient:service(0)
   clientpeer:send("Hi")
end
function lovr.update(dt)
   client_send()
end

function lovr.draw()
end

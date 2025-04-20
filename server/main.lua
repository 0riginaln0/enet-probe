local enet = require 'enet'

local enethost = nil
local hostevent = nil
local server_ip_port = 'localhost:6750'

function lovr.load()
   enethost = enet.host_create(server_ip_port)
end

local function server_listen()
   hostevent = enethost:service(0)

   if hostevent then
      print("Server detected message type: " .. hostevent.type)
      if hostevent.type == "connect" then
         print(hostevent.peer, "connected.")
      end
      if hostevent.type == "receive" then
         print("Received message: ", hostevent.data, hostevent.peer)
      end
   end
end


function lovr.update(dt)
   server_listen()
end

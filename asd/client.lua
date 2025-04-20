local enet = require 'enet'

local clientpeer = nil
local enetclient = nil
local server_ip_port = 'localhost:6750'

function lovr.load()
    print("Starting as client...")
    enetclient = enet.host_create()
    clientpeer = enetclient:connect(server_ip_port)
end

local function clientSendAndReceive()
    local event = enetclient:service(0)

    -- Send input
    clientpeer:send("I pressed W button")

    -- Receive new state
    if event and event.type == 'receive' then
        print("Received ", event.data, " from ", event.peer)
    end
end

function lovr.update(dt)
    clientSendAndReceive()
end

function lovr.draw()
end

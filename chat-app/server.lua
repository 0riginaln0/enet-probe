local enet = require 'enet'
local stdlib = require 'stdlib'


local server_address = 'localhost:6750'
local server_host = nil

function lovr.load()
    print("Starting as server...")
    server_host = enet.host_create(
        server_address, -- bind_address
        32,             -- peer_count: set maximum connections (default 64)
        1,              -- channel_count: set maximum number of channels (default 1)
        0,              -- in_bandwidth: unlimited in bandwidth (default 0)
        0               -- out_bandwidth: unlimited out bandwidth (default 0)
    )
end

function lovr.update(dt)
    -- Getting updates from the server while game is running
    local new_event = server_host:service(1000)
    if new_event then
        if new_event.type == "connect" then
            print("A new client connected from ", new_event.peer)
        elseif new_event.type == "receive" then
            local data = new_event.data
            local channel = new_event.channel
            local peer = new_event.peer
            print("A packet of length " .. tostring(#data) .. "containing " .. data ..
                "was received from ", peer, "on channel " .. channel)
        elseif new_event.type == "disconnect" then
            print(new_event.peer, "disconnected")
        end
    end
end

function lovr.keyreleased(key)
    if key == 'escape' then
        lovr.event.quit(0)
    end
end

function lovr.quit()
    print("cleaning up")
    -- A truthy value can be returned from this callback to abort quitting. But we want to quit
    server_host:destroy()
    return false
end

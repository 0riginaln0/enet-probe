local enet = require 'enet'

local enethost = nil
local hostevent = nil
local server_ip_port = 'localhost:6750'
local max_peers = 32

local game_data = 1

function lovr.load()
    print("Starting as server...")
    enethost = enet.host_create(server_ip_port, max_peers)
end

local function serverListen()
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

local function sendUpdate()
    for i = 1, max_peers do
        local peer = enethost:get_peer(i)
        if peer:state() == 'connected' then
            game_data = game_data + 1
            peer:send(game_data)
        end
    end
end

function lovr.update(dt)
    -- Process incoming user commands
    serverListen()

    -- Run a physical simulation step
    -- Update all objects

    -- Decide if any client needs a world update and take a snapshot of the current world state
    -- if necessary
    sendUpdate()
end

function lovr.draw()
end

local enet = require 'enet'
local stdlib = require 'stdlib'


local server_address = 'localhost:6750'
local client_host = nil
local server_peer = nil

function lovr.load()
    print("Starting as client...")
    client_host = enet.host_create(
        nil, -- bind_address: nil makes a host that can not be connected to (typically a client)
        1,   -- peer_count: set maximum connections number to 1 (default 64)
        1,   -- channel_count: set maximum number of channels (default 1)
        0,   -- in_bandwidth: unlimited in bandwidth (default 0)
        0    -- out_bandwidth: unlimited out bandwidth (default 0)
    )

    -- Returns peer object associated with the remote host. The actual connection will not take
    -- place until the next host:service() is called, in which a "connect" event will be generated.
    server_peer = client_host:connect(
        server_address, -- address: The address to connect to in the format "ip:port"
        1,              -- channel_count: The number of channels to allocate.
        --              It should be the same as the channel count on the server. Defaults to 1.
        0               -- data: An integer value that can be associated with the connect event. Defaults to 0.
    )

    -- Wait for events, send and receive any ready packets.
    -- If an event is in the queue it will be returned and dequeued.
    -- Generally you will want to dequeue all waiting events every frame.
    local new_event = client_host:service(
        3000 -- timeout: The max number of milliseconds to be waited for an event. Default is 0.
    )

    -- host:service returns nil if no events occured. We need to check for this.
    if not new_event then
        print("Failed to receive message from the server.")
        lovr.event.quit(stdlib.EXIT_FAILURE)
        goto continue
    end
    -- When new_event is not nil, we handle it
    if new_event.type == "connect" then
        print("Connection to " .. server_address .. " succeeded.")
    else
        server_peer:reset()
        print("Connection to " .. server_address .. " failed.")
        lovr.event.quit(stdlib.EXIT_SUCCESS)
    end

    -- Getting updates from the server while game is running
    local new_event = client_host:service(3000)
    if new_event and new_event.type == "receive" then
        local data = new_event.data
        local channel = new_event.channel
        local peer = new_event.peer
        print("A packet of length " ..
            tostring(#data) .. "containing " .. data .. "was received from ", peer, "on channel " .. channel)
    end
    print("Timed out")
    lovr.event.quit()
    ::continue::
end

function lovr.update(dt)
end

function lovr.quit()
    print("Cleaning up")
    -- Requests a disconnection from the peer.
    -- The message is sent on the next host:service() or host:flush().
    server_peer:disconnect(
        0 -- Optional integer value to be associated with the disconnect.
    )
    client_host:flush()

    -- A truthy value can be returned from this callback to abort quitting. But we want to quit
    return false
end

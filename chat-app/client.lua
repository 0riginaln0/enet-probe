UI2D = require 'lib.ui2d.ui2d'
lovr.mouse = require 'lib.lovr-mouse'
local enet = require 'enet'
local stdlib = require 'lib.stdlib'


local server_address = 'localhost:6750'
local client_host = nil
local server_peer = nil

local menu = {
    chat_input_text = "",
    chat_history = { "1", "2", "3" },
}

function lovr.load()
    UI2D.Init("lovr", 18)
    lovr.graphics.setBackgroundColor(.18, .18, .18)

    print("Starting as client...")
    client_host = enet.host_create(nil, 1, 1, 0, 0)
    server_peer = client_host:connect(server_address, 1, 0)
    local new_event = client_host:service(3000)
    if not new_event then
        print("Failed to receive message from the server.")
        lovr.event.quit(stdlib.EXIT_FAILURE)
        goto continue
    end
    if new_event.type == "connect" then
        print("Connection to " .. server_address .. " succeeded.")
    else
        server_peer:reset()
        print("Connection to " .. server_address .. " failed.")
        lovr.event.quit(stdlib.EXIT_SUCCESS)
    end
    ::continue::
end

function lovr.update(dt)
    UI2D.InputInfo()

    local new_event = client_host:service(0)
    if new_event and new_event.type == "receive" then
        local data = new_event.data
        local channel = new_event.channel
        local peer = new_event.peer
        print("A packet of length " ..
            tostring(#data) .. "containing " .. data .. "was received from ", peer, "on channel " .. channel)
    end
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

local function drawChat(pass)
    pass:setProjection(1, mat4():orthographic(pass:getDimensions()))
    UI2D.Begin("Chat", 30, 30)
    local clicked, idx = UI2D.ListBox("chat_history", 10, 55, menu.chat_history)
    local new_text, finished_editing = UI2D.TextBox("", 55, menu.chat_input_text)
    menu.chat_input_text = new_text
    if finished_editing and menu.chat_input_text ~= "" and lovr.system.wasKeyPressed("return") then
        print("send message: " .. menu.chat_input_text)
        server_peer:send(menu.chat_input_text)
        table.insert(menu.chat_history, menu.chat_input_text)
        menu.chat_input_text = ""
    end
    UI2D.End(pass)
end

function lovr.draw(pass)
    drawChat(pass)
    local ui_passes = UI2D.RenderFrame(pass)

    -- Game code

    table.insert(ui_passes, pass)
    return lovr.graphics.submit(ui_passes)
end

function lovr.wheelmoved(dx, dy)
    UI2D.WheelMoved(dx, dy)

    if not UI2D.HasMouse() then
        -- something
    end
end

function lovr.keyreleased(key, scancode, repeating)
    UI2D.KeyReleased()
end

function lovr.keypressed(key, scancode, repeating)
    UI2D.KeyPressed(key, repeating)
end

function lovr.textinput(text, code)
    UI2D.TextInput(text)
end

function lovr.mousepressed(x, y, button)
    if button == 1 and not UI2D.HasMouse() then
        -- Code to handle lmb pressed if not in menu
    end
end

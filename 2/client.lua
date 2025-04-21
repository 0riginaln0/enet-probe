UI2D = require 'lib.ui2d.ui2d'
lovr.mouse = require 'lib.lovr-mouse'

local menu = {
    chat_input_text = "",
    chat_history = { "1", "2", "3" },
}

function lovr.load()
    UI2D.Init("lovr", 18)
    lovr.graphics.setBackgroundColor(.18, .18, .18)
end

function lovr.update(dt)
    UI2D.InputInfo()
end

local function drawChat(pass)
    pass:setProjection(1, mat4():orthographic(pass:getDimensions()))
    UI2D.Begin("Chat", 30, 30)
    local clicked, idx = UI2D.ListBox("chat_history", 10, 55, menu.chat_history)
    local new_text, finished_editing = UI2D.TextBox("", 55, menu.chat_input_text)
    menu.chat_input_text = new_text
    if finished_editing and menu.chat_input_text ~= "" and lovr.system.wasKeyPressed("return") then
        print("send message: " .. menu.chat_input_text)
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

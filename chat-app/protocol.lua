local ClientToServerMessageType = {
    INPUT = 0,
    CHAT = 2,
}

local function newClientInputMessage(input, last_frame)
    return {
        type = ClientToServerMessageType.INPUT,
        input = input,
        last_frame = last_frame
    }
end

local function newClientChatMessage(msg)
    return {
        type = ClientToServerMessageType.CHAT,
        msg = msg
    }
end

local ServerToClientMessageType = {
    DIFFUPDATE = 0,
    FULLUPDATE = 1,
    CHAT = 2,
}

local function newServerDiffUpdateMessage(world_dif)
    return {
        type = ServerToClientMessageType.DIFFUPDATE,
        world_dif = world_dif
    }
end

local function newServerFullUpdateMessage(world)
    return {
        type = ServerToClientMessageType.FULLUPDATE,
        world = world
    }
end

local function newServerChatMessage(messages)
    return {
        type = ServerToClientMessageType.CHAT,
        messages = messages
    }
end

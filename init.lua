local eventtap = require("hs.eventtap") 
local keycodes = require("hs.keycodes")
local events = eventtap.event.types

local spaceDown = false
local normalKey = ""
local produceSpace = true

-- listen to keypress on modifiers
-- eventtap.new({events.flagsChanged}, function(event)
--     print(event:getFlags())
-- end):start()

eventtap.new({ events.keyDown }, function(event)
    local currKey = keycodes.map[event:getKeyCode()]
    -- print(currKey .. " is down".." normalKey is " .. normalKey)
    if currKey == normalKey then
        if normalKey == "space" then
            -- print("generate space up")
            hs.eventtap.event.newKeyEvent("space", false):post()
        end
        return false
    end
    if currKey == "space" then
        spaceDown = true
        produceSpace = true
        return true
    end
    if spaceDown then
        local newKey = nil
        if currKey == "i" then
            newKey = "up"
        elseif currKey == "j" then
            newKey = "left"
        elseif currKey == "k" then
            newKey = "down"
        elseif currKey == "l" then
            newKey = "right"
        elseif currKey == "p" then
            newKey = "delete"
        elseif currKey == "o" then
            newKey = "end"
        elseif currKey == "u" then
            newKey = "home"
        elseif currKey == "h" then
            newKey = "return"
        end
        if newKey ~= nil then
            produceSpace = false
            normalKey = newKey
            hs.eventtap.event.newKeyEvent(newKey, true):post()
            hs.eventtap.event.newKeyEvent(newKey, false):post()
            return true
        end
    end
    return false
end):start()

eventtap.new({ events.keyUp }, function(event)
    local currKey = keycodes.map[event:getKeyCode()]
    -- print(currKey .. " is up".." normalKey is " .. normalKey)
    if currKey == normalKey then
        normalKey = ""
        return false
    end
    if currKey == "space" then
        spaceDown = false
        normalKey = ""
        if produceSpace then
            normalKey = "space"
            -- print("generate space down")
            hs.eventtap.event.newKeyEvent("space", true):post()
            return true
        end
    end
    return false
end):start()
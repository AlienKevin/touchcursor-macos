--- === TouchCursor ===
--- Speed up text edits and navigations by using the space bar
--- as a modifier key (but still lets you type spaces).
--- Allowing you to use letter keys as up, down, left, right,
--- delete, return, home, and end so your hands can comfortably
--- stay within the range of the letter keys.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "TouchCursor"
obj.version = "0.1"
obj.author = "Kevin Li <kevinli020508@gmail.com>"
obj.homepage = "https://github.com/AlienKevin/touchcursor-macos"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.spaceDown = false
obj.normalKey = ""
obj.produceSpace = true

-- listen to keypress on modifiers
-- eventtap.new({events.flagsChanged}, function(event)
--     print(event:getFlags())
-- end):start()

function obj:init()
    hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local currKey = hs.keycodes.map[event:getKeyCode()]
        -- print(currKey .. " is down".." normalKey is " .. normalKey)
        if currKey == self.normalKey then
            if self.normalKey == "space" then
                -- print("generate space up")
                hs.eventtap.event.newKeyEvent("space", false):post()
            end
            return false
        end
        if currKey == "space" then
            self.spaceDown = true
            self.produceSpace = true
            return true
        end
        if self.spaceDown then
            local newModifier = nil
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
            elseif currKey == "m" then
                newKey = "d"
                newModifier = hs.keycodes.map.ctrl
            end
            if newKey ~= nil then
                self.produceSpace = false
                self.normalKey = newKey
                if newModifier ~= nil then
                    hs.eventtap.event.newKeyEvent(newModifier, true):post()
                end
                hs.eventtap.event.newKeyEvent(newKey, true):post()
                hs.eventtap.event.newKeyEvent(newKey, false):post()
                if newModifier ~= nil then
                    hs.eventtap.event.newKeyEvent(newModifier, false):post()
                end
                return true
            end
        end
        return false
    end):start()

    hs.eventtap.new({ hs.eventtap.event.types.keyUp }, function(event)
        local currKey = hs.keycodes.map[event:getKeyCode()]
        -- print(currKey .. " is up".." normalKey is " .. normalKey)
        if currKey == self.normalKey then
            self.normalKey = ""
            return false
        end
        if currKey == "space" then
            self.spaceDown = false
            self.normalKey = ""
            if self.produceSpace then
                self.normalKey = "space"
                -- print("generate space down")
                hs.eventtap.event.newKeyEvent("space", true):post()
                return true
            end
        end
        return false
    end):start()
end

return obj

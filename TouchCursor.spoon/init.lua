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
obj.modifiersDown = {}

local STOP = true
local GO = false
local DOWN = true
local UP = false

-- Source: https://stackoverflow.com/a/641993/6798201
function table.shallowCopy(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
end

-- listen to keypress on modifiers
obj._flagWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    obj.modifiersDown = event:getFlags()
    -- print("Pressed: " .. dump(obj.modifiersDown))
end):start()

function obj:init()
    self._downWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local currKey = hs.keycodes.map[event:getKeyCode()]
        if currKey == self.normalKey then
            if self.normalKey == "space" then
                -- print("Lift up " .. dump(obj.modifiersDown) .. " + space")
                hs.eventtap.event.newKeyEvent("space", UP):setFlags(self.modifiersDown):post()
            end
            return GO
        end
        if currKey == "space" then
            if self.modifiersDown["cmd"] then
                return GO
            end
            self.spaceDown = true
            self.produceSpace = true
            return STOP
        end
        if self.spaceDown then
            local keyTable = {
                ["i"] = "up",
                ["j"] = "left",
                ["k"] = "down",
                ["l"] = "right",
                ["p"] = "delete",
                ["o"] = "end",
                ["u"] = "home",
                ["h"] = "return",
                ["m"] = "d"
            }
            local newKey = keyTable[currKey]
            local newModifiers = table.shallowCopy(obj.modifiersDown)
            if newKey ~= nil then
                self.produceSpace = false
                self.normalKey = newKey
                if currKey == "m" then
                    newModifiers["ctrl"] = true
                end
                hs.eventtap.event.newKeyEvent(newKey, DOWN):setFlags(newModifiers):post()
                if currKey == "m" then
                    newModifiers["ctrl"] = false
                end
                hs.eventtap.event.newKeyEvent(newKey, UP):setFlags(newModifiers):post()
                return STOP
            end
        end
        return GO
    end):start()

    self._upWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyUp }, function(event)
        local currKey = hs.keycodes.map[event:getKeyCode()]
        if currKey == self.normalKey then
            self.normalKey = ""
            if currKey == "space" and next(self.modifiersDown) ~= nil then
                return STOP
            end
            return GO
        end
        if currKey == "space" then
            if self.modifiersDown["cmd"] then
                return GO
            end
            self.spaceDown = false
            self.normalKey = ""
            if self.produceSpace then
                self.normalKey = "space"
                -- print("Press " .. dump(obj.modifiersDown) .. " + space")
                hs.eventtap.event.newKeyEvent("space", DOWN):setFlags(self.modifiersDown):post()
                return STOP
            end
        end
        return GO
    end):start()
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = k end
            if v then
                s = s .. dump(k) .. ', '
            end
        end
        return s .. '}'
    else
       return tostring(o)
    end
end

return obj

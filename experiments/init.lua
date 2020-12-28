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

function table.copy(t)
    local t2 = {}
    for k,v in pairs(t) do
      table.insert(t2, v)
    end
    return t2
end

function obj:init()
    -- listen to keypress on modifiers
    self._flagWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
        local flags = event:getFlags()
        self.modifiersDown = {}
        if flags["ctrl"] then
            table.insert(self.modifiersDown, "ctrl")
        end
        if flags["cmd"] then
            table.insert(self.modifiersDown, "cmd")
        end
        if flags["alt"] then
            table.insert(self.modifiersDown, "alt")
        end
        if flags["shift"] then
            table.insert(self.modifiersDown, "shift")
        end
    end):start()

    self._downWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local currKey = hs.keycodes.map[event:getKeyCode()]
        print("currKey is " .. currKey .. ", normalKey is " .. self.normalKey)
        if currKey == self.normalKey then
            hs.eventtap.event.newKeyEvent(table.copy(self.modifiersDown), currKey, UP):post()
            print("Press " .. dump(self.modifiersDown) .. " + " .. currKey)
            return GO
        end
        if currKey == "space" then
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
            if newKey ~= nil then
                self.produceSpace = false
                self.normalKey = newKey
                local newModifiersDown = table.copy(self.modifiersDown)
                if currKey == "m" then
                    table.insert(newModifiersDown, "ctrl")
                end
                -- print("Press " .. dump(self.modifiersDown) .. " + space + " .. newKey)
                hs.eventtap.event.newKeyEvent(newModifiersDown, newKey, DOWN):post()
                return STOP
            end
        end
        print("Press " .. dump(self.modifiersDown) .. " + " .. currKey)
        return GO
    end):start()

    self._upWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyUp }, function(event)
        local currKey = hs.keycodes.map[event:getKeyCode()]
        print("currKey is " .. currKey .. ", normalKey is " .. self.normalKey)
        if currKey == self.normalKey then
            self.normalKey = ""
            print("Lift up " .. dump(self.modifiersDown) .. " + " .. currKey)
            return GO
        end
        if currKey == "space" then
            self.spaceDown = false
            self.normalKey = ""
            if self.produceSpace then
                self.normalKey = "space"
                hs.eventtap.event.newKeyEvent(table.copy(self.modifiersDown), "space", DOWN):post()
                return STOP
            end
        end
        print("Lift up " .. dump(self.modifiersDown) .. " + " .. currKey)
        return GO
    end):start()
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. dump(v) .. ', '
       end
       return s .. '}'
    else
       return tostring(o)
    end
 end

return obj

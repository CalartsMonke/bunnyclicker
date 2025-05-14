Dungeon = Object:extend()
local Room = require('src.room')

local blueSquare = require('assets').images.blueRoomSquare

function Dungeon:new()

    self.confirm = 0

    self.STATES =
 {
    SELECTING = 1,
    PREVIEWING = 2,
    ACTIVE = 3,
 }
    self.state = self.STATES.SELECTING
    self.rooms = {}
    self.roomlimit = 10
    self.roommin = 6

    self.eRoomMax = 5
    self.eRoomMin = 2

    self.activeRoom = 0 --index of room that is being played
    self.previewRoom = 1 --index of room to show when selecting room

    self:generateNew()
end

function Dungeon:generateNew()
    for i = 1, 7 do
    local newRoom = Room(1)
    print(newRoom)
    newRoom.parentDungeon = self
    table.insert(self.rooms, newRoom)

    end
end

function Dungeon:returnToRoomSelect()
    self.activeRoom = 0
    self.state = self.STATES.SELECTING
end

function Dungeon:previewIncrement()
    self.previewRoom = self.previewRoom + 1
    if self.previewRoom >= #self.rooms + 1 then
        self.previewRoom = 1
    end
end

function Dungeon:previewDecrement()
    self.previewRoom = self.previewRoom - 1
    if self.previewRoom <= 0 then
        self.previewRoom = #self.rooms
    end
end

function Dungeon:keypressed(key, scancode, isrepeat)
    if key == 'a' then
        self:previewDecrement()
    end

    if key == 'd' then
        self:previewIncrement()
    end

    if key == 'space' then

    end
end

function Dungeon:confirmRoomChoice(dt)

    if love.keyboard.isDown('space') then
        self.confirm = self.confirm + dt
    else
        self.confirm = 0
    end

    if self.confirm > 1 then
        if not self.rooms[self.previewRoom].isCleared then
        self.activeRoom = self.previewRoom
        self.state = self.STATES.ACTIVE
        end
        self.confirm = 0
    end
end

function Dungeon:update(dt)
    --Confirm a room to enter



    if self.state == self.STATES.SELECTING then
        self:confirmRoomChoice(dt)
        print("CURRENTLY SELECTING")
    end

    if self.state == self.STATES.ACTIVE then
        self.rooms[self.activeRoom]:update(dt)
        print("CURRENTLY ACTIVE")
    end


end

function Dungeon:draw()

    if self.state == self.STATES.SELECTING then
        love.graphics.print("ROOM NAME: "..self.rooms[self.previewRoom].displayName, 200, 200)

        for i=1, #self.rooms do
            local index = i
            local heightSep = 0

            if index == self.previewRoom then
                heightSep = -8
            end

            love.graphics.draw(blueSquare, 100 + i * 32, 100 + heightSep)
        end

        love.graphics.print(self.previewRoom, 300, 100)
        love.graphics.print(self.activeRoom, 200, 100)
    end

    if self.state == self.STATES.ACTIVE then
        self.rooms[self.activeRoom]:draw()
    end
end


return Dungeon
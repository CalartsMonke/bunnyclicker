Dungeon = Object:extend()

function Dungeon:new()
    self.rooms = {}
    self.roomlimit = 10
    self.roommin = 6

    self.eRoomMax = 5
    self.eRoomMin = 2

    self.activeRoom = 0 --index of room that is being played

end

function Dungeon:generateNew()

end

function Dungeon:update()
    self.rooms[self.activeRoom]:update()
end

function Dungeon:draw()
    self.rooms[self.activeRoom]:draw()
end


return Dungeon
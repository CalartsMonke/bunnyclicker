local entities = require 'roomEntities'
local player = _G.player



local room = Object:extend()
room.name = "battletestroom_01"
room.id = 2
room.roomObjects = {}
local roomObjects = room.roomObjects

function room:enter(previous, ...)
	-- set up the level
    self.currentEncounter = require 'src.battlemanager':GetCurrentEncounter()

    table.insert(roomObjects, _G.player)



end

function room:update(dt)
    _G.player:update(dt)
    self.currentEncounter:update(dt)

end

function room:leave(next, ...)
	-- destroy entities and cleanup resources
end

function room:draw()
    _G.player:draw()
          --Draw items im too lazy to sort rn
    self.currentEncounter:draw()

    gameHud:draw()
end

return room
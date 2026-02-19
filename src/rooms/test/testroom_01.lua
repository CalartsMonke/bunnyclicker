local testMap = sti('map/test/map1.lua')
local entities = require 'roomEntities'
local player = _G.player



local room = Object:extend()
room.name = "testroom_01"
room.id = 1
room.roomObjects = {}
local roomObjects = room.roomObjects

function room:enter(previous, ...)
	-- set up the level
    table.insert(roomObjects, _G.worldPlayer)

    if (testMap.layers["Walls"]) then
        for i, obj in pairs(testMap.layers["Walls"].objects) do
            local object = require 'src.wallNormal'(obj.x, obj.y, obj.width, obj.height)
            table.insert(roomObjects, object)
        end
    end
    if (testMap.layers["Ladder"]) then
        for i, obj in pairs(testMap.layers["Ladder"].objects) do
            local object = require 'src.ladder'(obj.x, obj.y, obj.width, obj.height)
            table.insert(roomObjects, object)
        end
    end
    if (testMap.layers["Enemy"]) then
        for i, obj in pairs(testMap.layers["Enemy"].objects) do
            local object = require 'src.enemyOverworld'(obj.x, obj.y, obj.properties.id)
            table.insert(roomObjects, object)
        end
    end
end

function room:update(dt)
     --UPDATE ENTITIES
     for i = 1, #entities do
        
        if i <= #entities then
            local item = entities[i]
                item:update(dt)
        end
    end

end

function room:leave(next, ...)
    for i=#roomObjects, 1, -1 do
        table.remove(roomObjects, i)
    end
end

function room:draw()
    testMap:draw()

          --Draw items im too lazy to sort rn
          for i = 1, #roomObjects do
        
            if i <= #roomObjects then
                local item = roomObjects[i]
                if item.draw ~= nil then
                    item:draw()
                end
                if player.resumesword ~= nil then
                    if item:is(Player) then
                        item:draw()
                    end
                    if item:is(Resumesword) then
                    item:draw()
                    end
                end
            end
        end

        gameHud:draw()
end

return room
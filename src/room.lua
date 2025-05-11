local entities = require('roomEntities')
local entityList = {}
local RoomLevel = {}

local spawnTimeDelayMax = 1 -- 2 seconds
local spawnTimeDelay = 0
local activeEnemyCount = 0
local activeEnemyLimit = 3


function RoomLevel:SetRoomEntities(currentRoom)
    local id = currentRoom
    
    if id == 1 then
        local e1 = require 'src.enemy.enemy'
        entityList =
        {
            e1(150 * 2, 150),
            e1(330 , 200),
            e1(115 * 2, 125),
            e1(125 * 2, 175),
            e1(150 * 2, 150),
            e1(200 * 2, 200),

        }
    end
end

function RoomLevel:update(dt)
    spawnTimeDelay = spawnTimeDelay + dt

    if spawnTimeDelay >= spawnTimeDelayMax then
        if self:getEnemyCount() < activeEnemyLimit then
            print("THIS SHOULD RUN")
            local enemyToAdd = table.remove(entityList, 1)
            table.insert(entities, enemyToAdd)
            
        end
        spawnTimeDelay = spawnTimeDelay - spawnTimeDelayMax
    end

end

function RoomLevel:getEnemyCount()
    local count = 0
    for i = 1, #entities do
        local item = entities[i]

        if item:is(Enemy) then
            if item.state == item.STATES.ACTIVE then
             count = count + 1
            end
        end

    end

    return count
end

function RoomLevel:checkWin()
    if self:getEnemyCount() <= 0 and #entityList == 0 then
        return true
    else return false
    end
end

return RoomLevel


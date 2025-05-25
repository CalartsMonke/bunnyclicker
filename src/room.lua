local entities = require('roomEntities')
local object = require('lib.classic')
local bagdrop = require 'src.collectible.bagDrop'
local debugChart = require('src.debugchart')



RoomLevel = object:extend()
function RoomLevel:new(roomID)
    self.clearWait = 0
    self.prizeClearX = love.math.random(100, 200)
    self.prizeClearY = love.math.random(100, 200)
    local bag = bagdrop(self.prizeClearX, self.prizeClearY, love.math.random(1, 3))
    bag.parentRoom = self
    bag.isActive = false
    self.prizeItem = bag
    self.isCleared = false

    self.spawnTimeDelay = 0
    self.activeEnemyCount = 0
    self.entityList = {}
    
    self:SetRoomEntities(roomID)
end


function RoomLevel:SetRoomEntities(currentRoom)
    local id = currentRoom
    
    if id == 1 then
        local e1 = require 'src.enemy.enemyHorizontal'
        self.spawnTimeDelayMax = 1
        self.activeEnemyLimit = 3
        self.displayName = 'THIS IS FLIPPING EPIC'
 
        self.entityList =
        {
            e1(150 * 2, 150),
            e1(330 , 200),
            e1(115 * 2, 125),
            e1(125 * 2, 175),
            e1(200 * 2, 200),

        }
    end

    if id == 2 then
        local e1 = require 'src.enemy.enemyHorizontal'
        self.spawnTimeDelayMax = 0.2
        self.activeEnemyLimit = 6
        self.displayName = 'THIS IS FLIPPING NOT EPIC AT ALL'
 
        self.entityList =
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

local player = require ('gameStats').player
local world = require ('world')

function RoomLevel:update(dt)

    --UPDATE ENTITIES
    for i = 1, #entities do
        
        if i <= #entities then
            local item = entities[i]
            if player.resumesword == nil then
                item:update(dt)
            end
            if player.resumesword ~= nil then
                if item:is(Player) then
                    item:update(dt)
                end
                if item:is(Resumesword) then
                item:update(dt)
                end
            end
            if item:is(BagDrop) then
                local tempString = "COIN BAG AT SPOT "..i
                debugChart:AddToChart(tempString)
            end
        end
    end

    self.spawnTimeDelay = self.spawnTimeDelay + dt

    if self.spawnTimeDelay >= self.spawnTimeDelayMax then
        if self:getEnemyCount() < self.activeEnemyLimit then
            local enemyToAdd = table.remove(self.entityList, 1)
            table.insert(entities, enemyToAdd)
            --Check if the room is clear and win if so
            if self:checkWin() == true and self.isCleared ~= true then
                self.isCleared = true
            end
        end
        self.spawnTimeDelay = self.spawnTimeDelay - self.spawnTimeDelayMax
    end

    if self.isCleared == true then
        self.clearWait = self.clearWait + dt
    end

    if self.prizeItem ~= nil then
        if self.clearWait >= 0.6 and self.prizeItem.isActive == false then
            self.prizeItem.isActive = true
            table.insert(entities, self.prizeItem)
        end
    end

end

function RoomLevel:EndLevel()
    self.prizeItem.isActive = false
    self.prizeItem = nil
    self:clearEntities()
    self.parentDungeon:returnToRoomSelect()
end


function RoomLevel:clearEntities()


    for i = #entities, 1, -1 do
        local item = entities[i]
        if not item:is(Player) or (not item:is(Collectible) and item == self.prizeItem) then
            item:Destroy()
        end
    end

end

function RoomLevel:keypressed()

end


function RoomLevel:draw()

      --Draw items im too lazy to sort rn
      local worldItems, worldLen = world:getItems()
      for i = 1, worldLen do
          local item = worldItems[i]
          item:draw()
      end

      if self.prizeItem.isActive then
        love.graphics.print("THE ITEM IS ACTIVE", 200, 100)
      end
      if self.prizeItem.isActive == false then
        love.graphics.print("THE ITEM IS NOT ACTIVE AT ALL", 200, 100)
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
    if self:getEnemyCount() <= 0 and #self.entityList == 0 then
        return true
    else return false
    end
end

return RoomLevel


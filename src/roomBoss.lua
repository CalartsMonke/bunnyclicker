local entities = require('roomEntities')
local Object = require('lib.classic')
local enemyHorizontal = require('src.enemy.enemyHorizontal')



RoomBoss = Object:extend()
function RoomBoss:new()
    self.parentDungeon = nil
    self.isCleared = false
    self.displayName = 'big boss bust yo balls'
    local newBoss = enemyHorizontal(200, 200)
    newBoss.parentRoom = self
    self.bossEntity = newBoss
    self.bossEntity.isBoss = true
    self.bossEntity.hpMax = 100
    self.bossEntity.hp = self.bossEntity.hpMax
end

function RoomBoss:keypressed(key)

end

local player = require ('gameStats').player
local world = require ('world')
function RoomBoss:update(dt)

    --PLAY MUSIC
    love.audio.play(require('assets').music.boss2)

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
            end
        end

end

function RoomBoss:draw()
      --Draw items im too lazy to sort rn
      local worldItems, worldLen = world:getItems()
      for i = 1, worldLen do
          local item = worldItems[i]
          item:draw()
      end

      if self.isCleared then
        love.graphics.print("YOU WON THE FIGHT", 200, 200)
      end

end

function RoomBoss:enter()
table.insert(entities, self.bossEntity)
end

function RoomBoss:exit()
    self.isCleared = true
    self.bossEntity:Destroy()
end

return RoomBoss
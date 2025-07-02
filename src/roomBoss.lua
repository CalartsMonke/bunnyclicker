local entities = require('roomEntities')
local Object = require('lib.classic')
local enemyHorizontal = require('src.enemy.enemyHorizontal')

local bossHpX = 200
local bossHpY = 0

local bossHpLength = 200

RoomBoss = Object:extend()
function RoomBoss:new()
    self.parentDungeon = nil
    self.isCleared = false
    self.displayName = 'big boss bust yo balls'
    local newBoss = enemyHorizontal(200, 200)
    newBoss.parentRoom = self
    self.bossEntity = newBoss
    self.bossEntity.isBoss = true
    self.bossEntity.hpMax = 350
    self.bossEntity.hp = self.bossEntity.hpMax


    self.hpXOff = 0
    self.hpYOff = 0

    self.prevHp = self.bossEntity.hp
end

function RoomBoss:keypressed(key)

end

local player = require ('gameStats').player
local world = require ('world')
function RoomBoss:update(dt)


    if self.prevHp ~= self.bossEntity.hp then
        self.hpXOff = love.math.random(-2, 2)
        self.hpYOff = love.math.random(-2, 2)
    end

    flux.to(self, 0.1, { hpXOff = 0})
    flux.to(self, 0.1, { hpYOff = 0})

    self.prevHp = self.bossEntity.hp
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
    --draw healthbar
    local barlength = (self.bossEntity.hp / self.bossEntity.hpMax ) * bossHpLength
    
    love.graphics.setFont(require'assets'.fonts.dd16)
    love.graphics.print("HP-", bossHpX + self.hpXOff, bossHpY + self.hpYOff)
    love.graphics.setFont(require'assets'.fonts.ns13)

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    for i=1, bossHpLength do
        love.graphics.line((bossHpX + self.hpXOff + 48) + i-1, bossHpY + self.hpYOff + 6, (bossHpX + self.hpXOff + 48)  + i-1, bossHpY + self.hpYOff + 12)
    end
    love.graphics.setColor(1, 1, 1, 1)

    for i=1, barlength do
        love.graphics.line((bossHpX + self.hpXOff + 48) + i-1, bossHpY + self.hpYOff + 6, (bossHpX + self.hpXOff + 48)  + i-1, bossHpY + self.hpYOff + 12)
    end


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
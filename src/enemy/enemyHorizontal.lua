


local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

--bullet
local Bullet = require 'src.bullet'

enemyHorizontal = Enemy:extend()



function enemyHorizontal:new(x, y)
    self.super.new(self,x,y)
    self.addToTags{"enemyHorizontal"}
    self.type = "EnemyHorizontal"
    self.ENEMYNAME = "TALKERBUN"
    self.image = require('assets').images.enemies.talkerBun.talkerbun_idle
    self.isPlaying = true

    self.prevHp = self.hp
    self:addToGame(self.image, x, y)


end


function enemyHorizontal:update(dt)

    
    world:update(self, self.x, self.y)
    self:updatePlayingState(dt)
    if self.isPlaying == true then
        self:updateStatusEffects(dt)


        --aggro decrease
        self.aggro = self.aggro - (self.aggroDecrease * dt)

        --spawn bullets
        self.bulletTimer = self.bulletTimer - (dt + (self.aggro / 10000))
        if self.bulletTimer <= 0 then
            self.bulletTimer = self.bulletTimer + self.bulletTimerMax + love.math.random(1, 30) * 0.10

            self:SpawnBulletHorizontal(game.player, 4, 200, 100, 3, 2)
        end
    end
end

function enemyHorizontal:draw()
    if self.isPlaying == true then
        self:drawStatusEffects()

        love.graphics.setColor(1, 1, 1, self.drawAlpha)
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1)
        love.graphics.setColor(1, 1, 1, 1)

        local x,y,w,h = self.world:getRect(self)
        love.graphics.setColor(0,1,0)
       love.graphics.rectangle('line', x, y, w, h)
        love.graphics.setColor(1,1,1)
    end
end


return enemyHorizontal
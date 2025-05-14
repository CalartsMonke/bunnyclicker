


local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

--bullet
local Bullet = require 'src.bullet'

enemyHorizontal = Enemy:extend()



function enemyHorizontal:new(x, y)
    self.super.new(self,x,y)
    self.image = require('assets').images.enemy2

    self:addToGame(self.image, x, y)
end


function enemyHorizontal:update(dt)
    self:updatePlayingState()
    if self.isPlaying == true then

        if self.hp <= 0 then
            local coinDrop = require 'src.coinDrop'
            local Coin = coinDrop(self.x, self.y)
            self.state = self.STATES.DEAD
        end


        --aggro decrease
        self.aggro = self.aggro - (self.aggroDecrease * dt)

        --spawn bullets
        self.bulletTimer = self.bulletTimer - (dt + (self.aggro / 10000))
        if self.bulletTimer <= 0 then
            self.bulletTimer = self.bulletTimer + self.bulletTimerMax + love.math.random(1, 30) * 0.10

            self:SpawnBulletHorizontal(game.player, 4, 200, 100)
        end
    end
end

function enemyHorizontal:draw()
    if self.isPlaying == true then
        love.graphics.draw(self.image, self.x, self.y, 0, 0.5, 0.5)
        love.graphics.print(tostring(self.hp), self.x + 5, self.y - 18)
        love.graphics.print(self.bulletTimer, self.x + 5, self.y - 32)
        love.graphics.print(self.state, self.x + 20, self.y - 50)
    end
end


return enemyHorizontal
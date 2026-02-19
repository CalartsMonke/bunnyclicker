local Collectible = require('src.collectible.collectible')

local player = require 'gameStats'.player
local hud = require 'gameplayhud'
local entities = require 'roomEntities'

KeyBoss = Collectible:extend()

function KeyBoss:new(x, y, parent)
    self.super.new(self)
    self.isActive = false
    self.parentRoom = parent or nil
    self.image = require('assets').images.bossKey
    self:addToGame(self.image, x, y)
    self.isActive = false

    self.travelTime = 0.4
    self.currentTime = 0

    self.delayTime = 0
    self.delayTimeMax = 1.5
    self.value = 1
    self.width = 32
    self.height = 32

    self.states = {1, 2}
    self.state = self.states[1]

    self.yExtra = 0
end


function KeyBoss:update(dt)
    if self.isActive == true then

        self:updateBounce(dt)

        if self.state == self.states[2] then
            self.currentTime = self.currentTime + dt
            self.delayTime = self.delayTime + dt
            if self.currentTime >= self.travelTime * 1.5 then
                player.hasBossKey = true
            end

            if self.delayTime >= self.delayTimeMax then
                self.parentRoom:EndLevel()
            end

            flux.to(self, self.travelTime, {x = hud.heartIconPosX})
            flux.to(self, self.travelTime, {y = hud.heartIconPosY})
        end
    end
end

function KeyBoss:collect()
    if self.isActive == nil or self.isActive == true then
    self.state = self.states[2]
    end
end

function KeyBoss:draw()
    if self.isActive == true then
        love.graphics.draw(self.image, self.x, self.y + self.yExtra)
    end
end

return KeyBoss
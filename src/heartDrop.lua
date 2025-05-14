local Entity = require('src.Entity')

local player = require 'gameStats'.player
local hud = require 'gameplayhud'
local entities = require 'roomEntities'

heartDrop = Entity:extend()

function heartDrop:new(x, y)
    self.image = require('assets').images.heartDrop
    self:addToGame(self.image, x, y)

    self.travelTime = 0.4
    self.currentTime = 0
    self.value = 1

    self.states = {1, 2}
    self.state = self.states[1]
end

function heartDrop:update()

    if self.state == self.states[2] then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.travelTime * 1.5 then
            player.currentHp = player.currentHp + self.value
            self:Destroy()
        end
        flux.to(self, self.travelTime, {x = hud.heartIconPosX})
        flux.to(self, self.travelTime, {y = hud.heartIconPosY})
    end
    
end

function heartDrop:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
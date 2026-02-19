local Collectible = require('src.collectible.collectible')

local player = require 'gameStats'.player
local hud = require 'gameplayhud'
local entities = require 'roomEntities'

heartDrop = Collectible:extend()

function heartDrop:new(x, y)
    self.image = require('assets').images.heartDrop
    self:addToGame(self.image, x, y)
    self.isActive = true

    self.travelTime = 0.2
    self.currentTime = 0
    self.value = 1
    self.width = 8
    self.height = 8

    table.insert(entities, self)
    self.states = {1, 2}
    self.state = self.states[1]
end

function heartDrop:collect()
    if self.isActive == nil or self.isActive == true then
    self.state = self.states[2]
    end
end

function heartDrop:update(dt)
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

return heartDrop
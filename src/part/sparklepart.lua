local assets = require 'assets'

sparklepart = Object:extend()

function sparklepart:new()
    self.part = love.graphics.newParticleSystem(assets.images.star, 100)

    self.part:setParticleLifetime(0.3, 0.6) -- life between 2s and 5s


    local maxX = love.math.random(-100, 100)
    local maxY = love.math.random(-100, 100)

    --self.part:setLinearAcceleration(0, 0, maxX, maxY, 30) --move to bottom of the screen
    self.part:setDirection(love.math.random(10))
    self.part:setRotation(love.math.random(10))
    self.part:setSpeed(100)
    self.part:setColors(255, 255, 255, 255, 255, 255, 255, 0)
end



return sparklepart
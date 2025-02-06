local assets = require 'assets'

sparklepart = Object:extend()

function sparklepart:new()
    sparklepart.part = love.graphics.newParticleSystem(assets.images.bunnycursor, 1000)

    sparklepart.part:setParticleLifetime(0.3, 0.6) -- life between 2s and 5s

    sparklepart.part:setLinearAcceleration(0, 0, love.math.random(-60, 60), love.math.random(-100, 100)) --move to bottom of the screen
    sparklepart.part:setColors(255, 255, 255, 255, 255, 255, 255, 0)
end



return sparklepart
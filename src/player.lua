local object = require 'lib.classic'
local world = require 'world'

Player = object:extend();

function Player:new()
self.x, self.y = 1, 1
self.width, self.height = 16, 16
print("THE PLAYER IS MADE")
world:add(self, self.x, self.y, self.width, self.height)
end

function Player:update(dt)
self.x, self.y = love.mouse.getPosition()
end

function Player:draw()

end

return Player

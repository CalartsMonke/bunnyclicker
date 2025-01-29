local entity = require 'src.entity'
local world = require 'world'
Enemy = entity:extend()

function Enemy:new(x, y)
    self.hp = 60
    self.x = x
    self.y = y
    self.width = 32
    self.height = 32

    world:add(self, self.x, self.y, self.width, self.height)
end

function Enemy:update()

end

function Enemy:draw()

end

return Enemy
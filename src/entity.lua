local object = require "lib.classic"

Entity = object:extend()

function Entity:new(x, y)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
end

function Entity:update()

end

function Entity:draw()

end

function Entity:Destroy()
self.world:remove(self)
end

function Entity:getCenter()
    return self.x + self.width / 2,
            self.y + self.height / 2
end

return Entity
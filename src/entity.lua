local entities = require('roomEntities')
Entity = Object:extend()

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
    require 'world':remove(self)
    for i = 1, #entities do
        local item = entities[i]

        if item == self then
            table.remove(entities, i)
        end
    end
end

function Entity:getCenter()
    return self.x + self.width / 2,
            self.y + self.height / 2
end

return Entity
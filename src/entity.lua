local entities = require('roomEntities')
Entity = Object:extend()

function Entity:new(x, y)
    self.x = x
    self.y = y
end

function Entity:addToGame(image, x, y)
    self.image = image
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.world = require('world')

    self.world:add(self, self.x, self.y, self.width, self.height)
end

function Entity:update()

end

function Entity:draw()

end

function Entity:getDirectionToObject(target)
    local tsx, tsy = target:getCenter()
    local sx, sy = self:getCenter()
    local direction = (math.atan2(tsy - sy, tsx - sx))

    return direction
end

function Entity:BossDefeat()
    if self.isBoss == true then
        --idk some dying code here that may spawn a item or end the level
    end
end

function Entity:drawDebugHitbox()
    local x,y,w,h = self.world:getRect(self)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle('line', x, y, w, h)
    love.graphics.setColor(1,1,1)
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
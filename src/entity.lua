local entities = require('roomEntities')
Entity = Object:extend()

function Entity:new(x, y)
    self.x = x
    self.y = y
end

function Entity:addToGame(image, x, y, w, h)
    self.type = "Entity"
    self.image = image
    self.x = x or 100
    self.y = y or 100
    self.width = self.image:getWidth() or w
    self.height = self.image:getHeight() or h
    self.world = require('world')

    self.world:add(self, self.x, self.y, self.width, self.height)
end

function Entity:update()

end

function Entity:draw()

end

function Entity:addToTags(tag)
    if self.tags == nil then
        self.tags = {}
    end

    table.insert(self.tags, tag)
end

function Entity:hasTag(tag)

    local tagFound = false
    if self.tags ~= nil then
        for i=1, #self.tags do
            local _tag = self.tags[i]
            if _tag == tag then
                tagFound = true
                return true
            end
        end
    end
    

    if tagFound == true then
        return true
    else
        return false
    end
end

function Entity:getDirectionToObject(target)
    local tsx, tsy = target:getCenter()
    local sx, sy = self:getCenter()
    local direction = (math.atan2(tsy - sy, tsx - sx))

    return direction
end

function Entity:getDistanceToObject(target, selfx, selfy)
    local x, y = self:getCenter()
    local xx = selfx or x
    local yy = selfy or y
    local sx, sy = target:getCenter()
    local distance = math.sqrt((sx - xx)^2 + (sy - yy)^2)

    return distance
end

function Entity:getNearestObjectInCircle(radius, tag, x, y)
    local sx, sy = self:getCenter()
    local items, len = self.world:queryRect(sx - radius, sy - radius, radius *2.5, radius * 2.5)

    closestItem = nil
    for i=1, len do
        item = items[i]
        if item ~= self then
            if item.isActive == true or item.isPlaying == true then
                if item:hasTag(tag) then
                    if closestItem == nil then
                        closestItem = item
                    end
        
                    if self:getDistanceToObject(item) < closestItem:getDistanceToObject(self) then
                        closestItem = items[i]
        
                    end
                end
            end
            
        end
    end

    return closestItem or nil
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
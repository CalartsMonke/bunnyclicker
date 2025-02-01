local entity = require 'src.entity'
local world = require 'world'

Resumesword = entity:extend()


function Resumesword:new(x, y, tx, ty)

self.states = {1, 2}
self.state = self.states[1]
self.direction = math.atan2(ty - y, tx - x)



 self.x, self.y = x, y
 self.ix, self.iy = x, y
 self.tx, self.ty = tx, ty
 self.image = love.graphics.newImage('/img/idlesword.png/')
 self.imageAngle = 0;
 self.speed = 40

 self.xDrawOff = 0
 self.yDrawOff = 0
 

 --drawing
 self.yEx = 0

 self.width, self.height = self.image:getWidth(), self.image:getHeight()

 self.world = world

 world:add(self, self.x, self.y, self.width, self.height)
end

function distance ( x1, y1, x2, y2 )
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt ( dx * dx + dy * dy )
  end

function Resumesword:update(dt)
    if self.state == 1 then
        
        local sx, sy = self:getCenter()
        local angle = self.direction

        self.x = self.x + math.cos((angle)) * self.speed * dt
        self.y = self.y + (math.sin((angle)) * self.speed * dt)

        self.imageAngle = self.imageAngle +  20* dt

        local halfDistance = distance(self.ix, self.iy, self.tx, self.ty)/2
        local distance = distance(self.x, self.y, self.tx, self.ty)
        self.xDrawOff, self.yDrawOff = 8, 8

        if distance > halfDistance then
            self.yEx = self.yEx - 30 * dt
        end
        if distance < halfDistance then
            self.yEx = self.yEx + 30 * dt
        end

        if distance < 3 then
            self.state = 2
            self.yEx = 0
        end

    elseif self.state == 2 then
        self.imageAngle = 0
        self.xDrawOff = 0
        self.yDrawOff = 0
    end
end

function Resumesword:draw()
    love.graphics.draw(self.image, self.x, self.y + self.yEx, self.imageAngle, 1, 1, self.xDrawOff, self.yDrawOff)

    if self.state == 1 then
        local sx, sy = self:getCenter()
        local fullDistance = distance(self.ix, self.iy, self.tx, self.ty)
        local halfDistance = distance(self.ix, self.iy, self.tx, self.ty)/2
        local distance = distance(self.x, self.y, self.tx, self.ty)
        local offY = 0
        if distance < fullDistance * 0.9 and distance > fullDistance * 0.1 then
            offY = halfDistance - math.abs(distance)
            love.graphics.setColor(0,0,0)
            --love.graphics.circle('fill', self.x, self.y + offY, 3)
            love.graphics.setColor(1,1,1)
        end
    end
end



return Resumesword
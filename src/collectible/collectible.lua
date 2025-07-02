local entity = require "src.entity"

Collectible = entity:extend()

function Collectible:new()
    self.bounceY = 0
    self.bounceForce = 500
    self.yExtra = 0
    self.drawY = 0
    self.speed = 100

    self.direction = love.math.random(0, 360)

    self.bounceYDelta = 0
end

function Collectible:updateBounce(dt)

    local grv = 1600

    if self.bounceY > 0 then
    self.bounceYDelta = self.bounceYDelta - grv * dt
    end

    if self.bounceY < 0 then

        if self.bounceForce > 150 then
            self.bounceForce = self.bounceForce * 0.7
            self.bounceYDelta = self.bounceForce
        end


        self.bounceY = 0
    end

    self.bounceY = self.bounceY + self.bounceYDelta * dt
end

function Collectible:MoveWithSpeed(dt)

    
    local angle = self.direction

    local newX = math.cos((angle)) * self.speed * dt
    local newY = math.sin((angle)) * self.speed * dt

    if self.speed > 0 then
        self.speed = self.speed - 75 * dt
    end

    if self.speed < 0 then
        self.speed = 0
    end
    self.x = self.x + newX
    self.y = self.y + newY
    self.world:update(self, self.x + newX, self.y + newY)
end

function Collectible:draw()

    if self.isActive == true then
        if self.animFrames == nil then
            love.graphics.draw(self.image, self.x, self.y - self.bounceY)
        else
            love.graphics.draw(self.image, self.animFrames[self.frameToDraw], self.x, self.y)
        end
    end

end




return Collectible
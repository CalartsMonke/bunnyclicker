local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

Bullet = entity:extend()


function Bullet:new(x, y)
    self.x = x
    self.y = y
    self.offX = self.x - game.player.x
    self.offY = self.y - game.player.y
    self.world = world
    self.image = love.graphics.newImage('/img/bullet.png/')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()


    self.states = {0, 1, 2}
    self.speed = 200

    self.world:add(self, self.x, self.y, self.width, self.height)


    local t = game.player
    local s = self
    self.sx, self.sy = self:getCenter()
    self.tsx, self.tsy = t:getCenter()
    self.direction = (math.atan2(self.tsy - self.sy, self.tsx - self.sx))



    --timer
    self.bulletTimer= 1

end

local function GetAngle(a, b)
    local angle = math.atan(b.y - a.y, b.x - a.x)
    return angle
end

local filter = function(item, other)

    return nil

end

function Bullet:update(dt)
    local tx, ty = game.player.x, game.player.y

    if self.bulletTimer <= 0 then


        local sx, sy = self:getCenter()
        local angle = self.direction

        self.x = self.x + math.cos((angle)) * self.speed * dt
        self.y = self.y + math.sin((angle)) * self.speed * dt
        

        local p = game.player
        if (p.x > self.x and p.x < self.x + self.width) and (p.y > self.y and p.y < self.y + self.height) then
            if p.invicbility > 0 then
                p:TakeDamage(1)
            end
        end

    else
        self.x = game.player.x + self.offX
        self.y = game.player.y + self.offY
       self.bulletTimer = self.bulletTimer - dt
    end

        

end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Bullet
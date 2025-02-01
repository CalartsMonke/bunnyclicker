local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

--bullet
local Bullet = require 'src.bullet'
Enemy = entity:extend()

function Enemy:new(x, y)
    self.hp = 60

    self.image = love.graphics.newImage('/img/laenemy.png/')
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.world = world
   

    world:add(self, self.x, self.y, self.width, self.height)


    --Damage
    self.damageToTake = 0

    --bullets
    self.bulletTimerMax = 3
    self.bulletTimer = self.bulletTimerMax
end

function Enemy:TakeDamage(damage)
    self.hp = self.hp - damage
end

function Enemy:update(dt)
    if self.hp < 0 then
        self:Destroy()
    end


    --spawn bullets
    self.bulletTimer = self.bulletTimer - dt
    if self.bulletTimer <= 0 then
        self.bulletTimer = self.bulletTimer + self.bulletTimerMax

        self:SpawnBulletCircle(game.player, 4, 0.2, 50)
    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 0.5, 0.5)
    love.graphics.print(tostring(self.hp), self.x + 5, self.y - 18)
end

--- Spawn a circle of bullets around the given object
function Enemy:SpawnBulletCircle(target, num, angleincrease, distance)
    local angle = math.floor(love.math.random(0, 360))
    for i=1, num do
    local tx, ty = target.x, target.y
    local bx, by = 0, 0


    bx = tx + (math.cos(angle + (angleincrease * i)) * distance)
    by = ty - (math.sin(angle + (angleincrease * i)) * distance)
    local bullet = Bullet(bx, by)
    end


end

return Enemy
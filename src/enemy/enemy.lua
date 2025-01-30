local entity = require 'src.entity'
local world = require 'world'
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
end

function Enemy:TakeDamage(damage)
    self.hp = self.hp - damage
end

function Enemy:update()
    if self.hp < 0 then
        self:Destroy()
    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 0.5, 0.5)
    love.graphics.print(tostring(self.hp), self.x + 5, self.y - 18)
end

return Enemy
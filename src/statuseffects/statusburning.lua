StatusBurning = require'src.statuseffects.status':extend()
local image = require ('assets').images.burning
local anim8 = require('lib.anim8')

local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())


function StatusBurning:new(owner, time)
    self.timer = time or 2
    self.owner = owner

    self.burnDamage = 1

    self.triggerRateMax = 0.2
    self.triggerRate = self.triggerRateMax
    self.animation = anim8.newAnimation(g('1-3',1), 0.2)
end

function StatusBurning:update(dt)
    self.animation:update(dt)
    if self.triggerRate > 0 then
        self.triggerRate = self.triggerRate - dt
    end

    if self.triggerRate <= 0 then
        self.owner:TakeDamage(self.burnDamage)
        self.triggerRate = self.triggerRateMax
    end

    self.timer = self.timer - dt
end

function StatusBurning:draw()
    self.animation:draw(image, self.owner.x, self.owner.y)
end

return StatusBurning
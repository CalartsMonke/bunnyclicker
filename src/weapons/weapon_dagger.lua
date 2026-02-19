local weapon = require "src.weapons.weapon"

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

WeaponDagger = weapon:extend()

function WeaponDagger:new()
    self.damage = 3
    self.delay = 0
    self.delayMax = 1 * 0.4
    self.delayCritTime = self.delayMax * 0.8
    self.uses = 99
    self.image = require 'assets'.images.dagger1
    self.name = 'DAGGER'
    self.canChargeWeapon = true
    self.chargeAmount = 20
    self.canCrit = true
    
    self.basic = true
end

function WeaponDagger:update(dt)
    if self.delay <= self.delayMax then
    self.delay = self.delay + dt
    end

    if self.delay > self.delayMax then
        self.delay = self.delayMax
    end
end

function WeaponDagger:use(owner, target)
    if self.delay >= self.delayMax or self.delay >= self.delayCritTime then
    local damage = self.damage + owner.baseDamage

    if self.delay >= self.delayCritTime and self.delay < self.delayMax and self.canCrit == true then
        local spark = sparklePart()
        table.insert(partTable ,partStation(owner.x, owner.y, spark.part, 1))
        damage = damage - damage * 0.3
    end

    target:TakeDamage(damage, owner.aggroAdd)




    self.delay = self.delay - self.delay

    local chance = love.math.random(0, 2)
    if chance == 1 then
        owner.rotateMax = owner.rotateMax + 90/2
        love.audio.play(require'assets'.sounds.slash1)
    else
        owner.rotateMax = owner.rotateMax - 45/2
        love.audio.play(require'assets'.sounds.slash2)
    end

        self.canCrit = true
    return true
    else
        self.canCrit = false
    end


end

function WeaponDagger:draw()

end

return WeaponDagger
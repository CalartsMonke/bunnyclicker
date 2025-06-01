local weapon = require "src.weapons.weapon"

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

WeaponDagger = weapon:extend()

function WeaponDagger:new()
    self.damage = 3
    self.delay = 0
    self.delayMax = 1 * 0.4
    self.uses = 99
    self.image = require 'assets'.images.dagger1
    self.name = 'DAGGER'
    
    self.basic = true
end

function WeaponDagger:update(dt)
    if self.delay <= self.delayMax then
    self.delay = self.delay + dt
    end
end

function WeaponDagger:use(owner, target)
    if self.delay >= self.delayMax then
    local damage = self.damage + owner.baseDamage

    target:TakeDamage(damage, owner.aggroAdd)
    self.delay = self.delay - self.delayMax

    local chance = love.math.random(0, 2)
    if chance == 1 then
        owner.rotateMax = owner.rotateMax + 90/2
        love.audio.play(require'assets'.sounds.slash1)
    else
        owner.rotateMax = owner.rotateMax - 45/2
        love.audio.play(require'assets'.sounds.slash2)
    end
    local spark = sparklePart()
    table.insert(partTable ,partStation(owner.x, owner.y, spark.part, 1))
    end
end

function WeaponDagger:draw()

end

return WeaponDagger
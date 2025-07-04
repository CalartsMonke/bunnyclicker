local weapon = require "src.weapons.weapon"

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

WeaponBrokenBottle = weapon:extend()

function WeaponBrokenBottle:new()
    self.damage = 99999
    self.delay = 0
    self.delayMax = 1 * 0.4
    self.uses = 1
    self.image = require('assets').images.brokenBottle
    self.name = "BROKEN BOTTLE"
end

function WeaponBrokenBottle:update(dt)
    if self.delay <= self.delayMax then
    self.delay = self.delay + dt
    end
end

function WeaponBrokenBottle:use(owner, target)
    if self.delay >= self.delayMax then
    local damage = self.damage + owner.baseDamage
    if target.isBoss == true then
       damage = 15 
    end
    target:TakeDamage(damage, owner.aggroAdd)
    self.delay = self.delay - self.delayMax

    local chance = love.math.random(0, 2)
    if chance == 1 then
        owner.rotateMax = owner.rotateMax + 90/2
        love.audio.play(require'assets'.sounds.bottlesmash1)
    else
        owner.rotateMax = owner.rotateMax - 45/2
        love.audio.play(require'assets'.sounds.bottlesmash2)
    end
    local spark = sparklePart()
    table.insert(partTable ,partStation(owner.x, owner.y, spark.part, 1))

    self.uses = self.uses -1

    return true
    end
end

function WeaponBrokenBottle:draw()

end

return WeaponBrokenBottle
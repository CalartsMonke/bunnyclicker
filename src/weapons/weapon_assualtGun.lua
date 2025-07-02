local weapon = require "src.weapons.weapon"

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

WeaponAssualtGun = weapon:extend()

function WeaponAssualtGun:new()
    self.damage = 6
    self.delay = 0
    self.delayMax = 0.05
    self.uses = 8
    self.image = require('assets').images.assualtGun
        self.name = "ASSUALT GUN"

end

function WeaponAssualtGun:update(dt)
    if self.delay <= self.delayMax then
    self.delay = self.delay + dt
    end
end

function WeaponAssualtGun:use(owner, target)
    if self.delay >= self.delayMax then
    local damage = self.damage + owner.baseDamage

    self.uses = self.uses - 1
    local Bullet = require ('src.playerBullet')
    local bullet = Bullet(_G.player.x, _G.player.y, self.damage)

    self.delay = self.delay - self.delayMax

    local chance = love.math.random(0, 2)
    if chance == 1 then
        owner.rotateMax = owner.rotateMax + 90/2
        love.audio.play(require'assets'.sounds.gunshot1)
    else
        owner.rotateMax = owner.rotateMax - 45/2
        love.audio.play(require'assets'.sounds.gunshot2)
    end
    local spark = sparklePart()
    table.insert(partTable ,partStation(owner.x, owner.y, spark.part, 1))

    return true
    end
end

function WeaponAssualtGun:draw()

end

return WeaponAssualtGun
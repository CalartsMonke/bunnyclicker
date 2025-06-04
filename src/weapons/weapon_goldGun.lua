local weapon = require "src.weapons.weapon"

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

WeaponGoldGun = weapon:extend()

function WeaponGoldGun:new()
    self.damage = 6
    self.delay = 0
    self.delayMax = 0.05
    self.uses = 2
    self.image = require('assets').images.goldGun
    self.name = "GOLD GUN"
end

function WeaponGoldGun:update(dt)
    if self.delay <= self.delayMax then
    self.delay = self.delay + dt
    end
end

function WeaponGoldGun:use(owner, target)
    if self.delay >= self.delayMax then
    local damage = self.damage + owner.baseDamage

    self.uses = self.uses - 1
    local Bullet = require ('src.playerBullet')
    local bullet = Bullet(_G.player.x, _G.player.y, damage)

    if target.hp - damage <= 0 then
        local coin = require 'src.collectible.coinDrop'(target.x, target.y)
    end

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
    end
end

function WeaponGoldGun:draw()

end

return WeaponGoldGun
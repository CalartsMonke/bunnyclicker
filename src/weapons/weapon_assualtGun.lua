local weapon = require "src.weapons.weapon"

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

WeaponAssualtGun = weapon:extend()

function WeaponAssualtGun:new()
    self.damage = 18
    self.delay = 0
    self.delayMax = 0.05
    self.uses = 1
    self.image = require('assets').images.assualtGun
        self.name = "ASSUALT GUN"

    self.aimRadius = 60

    self.level1Aim = 40
    self.level2Aim = 20
    self.level3Aim = 10

    self.missAim = 5
    self.isDying = false
    self.deathTimer = 0.5

    self.flipTimerMax = 0.15
    self.flipTimer = self.flipTimerMax

    self.amountToDecrease = 2
    self.decreasingRadius = false
    self.started = false

    self.level1ChargeCost = 125
    self.level2ChargeCost = 225
    self.level3ChargeCost = 250
end

function WeaponAssualtGun:update(dt)


    if self.decreasingRadius then
        self.amountToDecrease = self.amountToDecrease + (self.amountToDecrease * 1.8) * dt

        self.aimRadius = self.aimRadius - self.amountToDecrease * dt

        if self.aimRadius <= 0 then
            if self.started == true and not self.isDying then
                self.decreasingRadius = false
                self:getRadiusPower()
                self.isDying = true
            end
        end
    end

    if self.isDying then
        self.flipTimer = self.flipTimer - dt
        self.deathTimer = self.deathTimer - dt

        if self.flipTimer <= 0 then
            self.flipTimer = self.flipTimerMax
        end

    end
end

function WeaponAssualtGun:mousepressed(button)

    if self.started == true and not self.isDying then
        self.decreasingRadius = false
        self:getRadiusPower()
        self.isDying = true
    end
end

function WeaponAssualtGun:getRadiusPower()
    if self.aimRadius > self.level1Aim then
        self:ActionMiss()
    elseif self.aimRadius < self.level1Aim and self.aimRadius > self.level2Aim then
        self:ActionLevel1()
    elseif self.aimRadius < self.level2Aim and self.aimRadius > self.level3Aim then
        self:ActionLevel2()
    elseif self.aimRadius < self.level3Aim and self.aimRadius > self.missAim then
        self:ActionLevel3()
    elseif self.aimRadius < self.missAim then
        self:ActionMiss()
    end

end

function WeaponAssualtGun:ActionMiss()

    local amount = math.floor(love.math.random(6, 9))

    for i=1, amount do
        local bullet = require('src.projectiles.projectile_shrapnelBullet')(_G.player.x, _G.player.y)
        bullet.direction = love.math.random(0, 360)
    end
end

function WeaponAssualtGun:ActionLevel1()
    local damage = self.damage * 1
    self.target:TakeDamage(damage)
end

function WeaponAssualtGun:ActionLevel2()
    local damage = self.damage * 1.5
    self.target:TakeDamage(damage)
    local burn = require'src.statuseffects.statusburning'(self.target, 1.2)
    self.target:AddToStatusEffects(burn)
end

function WeaponAssualtGun:ActionLevel3()
    local damage = self.damage * 4
    self.target:TakeDamage(damage)
end


function WeaponAssualtGun:use(owner, target, level)
    if self.started ~= true then
        self.target = target
        --self.decreasingRadius = true

        --self.started = true

        if level == 1 then
            self:ActionLevel1()
        end
        if level == 2 then
            self:ActionLevel2()
        end
        if level == 3 then
            self:ActionLevel3()
        end
    
        return true
    end
end

function WeaponAssualtGun:draw()


    if self.started == true then

        --love.graphics.setLineStyle("rough")

        love.graphics.setColor(1, 0, 1, 0.4)
        for i=self.level1Aim, self.level2Aim, -2 do
            --love.graphics.circle('line', _G.player.x, _G.player.y - 48, i)
        end
        love.graphics.setColor(1, 1, 0, 0.4)
        for i=self.level2Aim, self.level3Aim, -2 do
            --love.graphics.circle('line', _G.player.x, _G.player.y - 48, i)
        end
        love.graphics.setColor(1, 0, 0, 0.4)
        for i=self.level3Aim, self.missAim, -2 do
            --love.graphics.circle('line', _G.player.x, _G.player.y - 48, i)
        end


        local circleAlpha = 60 - (self.aimRadius)

        if self.flipTimer > self.flipTimerMax / 2 then
            --love.graphics.setColor(1, 1, 1, circleAlpha / 100)
        else
            --love.graphics.setColor(0.3, 0.3, 0.3, 1)
        end

        for i = self.aimRadius -2, self.aimRadius + 2 do
            --love.graphics.circle('line', _G.player.x, _G.player.y - 48, self.aimRadius)
        end

        love.graphics.setColor(1,1,1,1)
    end
end

return WeaponAssualtGun
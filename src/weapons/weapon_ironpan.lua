local weapon = require "src.weapons.weapon"

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

WeaponIronPan = weapon:extend()

function WeaponIronPan:new()
    self.damage = 6
    self.delay = 0
    self.delayMax = 1 * 0.4
    self.uses = 1
    self.image = require('assets').images.items.ironpan
    self.name = "IRON PAN"

    self.totalDamage = 0

    self.barsSpawned = false
    self.currentBarNumber = 1
    self.owner = nil

    self.state = 1

    self.deathTimer = 0.2
    self.isDying = false

    self.hitBars = {}
    self.barsLeft = 4
    self.barHeight = 16
    self.barWidth = 2
    self.barHitX = 0
    self.barHitWidth = 8
    self.barHitOriginY = 0
    self.barImage = require('assets').images.hud.barTarget
end

function WeaponIronPan:update(dt)
    self:UpdateBars(dt)
    if self.currentBarNumber > 4 then
        self.isDying = true
    end

    if self.isDying == true then
        self.deathTimer = self.deathTimer - dt
    end

    if self.deathTimer <= 0 then
        self.state = 3
    end
end

function WeaponIronPan:EndWeapon()
    local damage = self.totalDamage
    local owner = self.owner
    local target = self.target

    target:TakeDamage(damage)
    self.uses = self.uses - 1

    local chance = love.math.random(0, 2)
    if chance == 1 then
        owner.rotateMax = owner.rotateMax + 90/2
    else
        owner.rotateMax = owner.rotateMax - 45/2
    end
    love.audio.play(require 'assets'.sounds.panhit)
    for i=1, math.floor(damage/4) do
        local spark = sparklePart()
        table.insert(partTable ,partStation(target.x, target.y, spark.part, 1))
    end
end

function WeaponIronPan:MakeBar(x)
    local bar = {}
    bar.x = x
    bar.y = self.barHeight

    bar.extraY = 0
    bar.width = self.barWidth
    bar.height = self.barHeight
    bar.speed = 120
    bar.parent = self
    bar.drawAlpha = 1
    self.goodHit = false
    self.badHit = false
    self.normalHit = false



    bar.state = 1

    bar.deathTime = 0.2
    bar.deathTimeMax = 0.2

    function bar:update(dt)
        if self.state == 1 then
        self.x = self.x - self.speed * dt
        end

        if self.state == 2 then
            self.extraY =  self.extraY - 150 * dt
            bar.drawAlpha = bar.drawAlpha - 2 * dt
            bar.deathTime = bar.deathTime - dt
        end



        
    end

    function bar:mousepressed(x, y, button, istouch)
        local parent = self.parent
        local damageToAdd = self.parent.damage
        local sx = self.x + self.width / 2
        if sx >= 0 and sx <= 8 then
            damageToAdd = damageToAdd * 3
            self.goodHit = true

            local sound = love.audio.newSource('/aud/pancrit.wav/', 'static')
            love.audio.play(sound)
            --love.audio.play(require 'assets'.sounds.pancrit)
        elseif sx > 32 or sx < 0 then
            damageToAdd = damageToAdd * 0.5
            self.badHit = true
        else
            local sound = love.audio.newSource('/aud/hitmark.mp3/', 'static')
            love.audio.play(sound)
        end

        bar.state = 2
        parent.totalDamage = parent.totalDamage + damageToAdd
        parent.currentBarNumber = parent.currentBarNumber + 1
    end

    function bar:draw()
        local extraalpha = 0

        if self.parent.hitBars[self.parent.currentBarNumber] == self then
            extraalpha = 0.5
        end

        if self.goodHit == true then
            love.graphics.setColor(1, 1, 0, self.drawAlpha - .5 + extraalpha)
        elseif self.badHit == true then
            love.graphics.setColor(0.8, 0, 0, self.drawAlpha - .5 + extraalpha)
        else
            love.graphics.setColor(1, 1, 1, self.drawAlpha - .5 + extraalpha)
        end
        love.graphics.rectangle('fill', _G.player.x  + self.x,( _G.player.y - self.y - 8) + self.extraY, self.width, self.height)
        love.graphics.setColor(1, 1, 1, 1)

    end


    return bar

end

function WeaponIronPan:mousepressed(x, y, button, istouch)
    if #self.hitBars > 0 then
        if self.currentBarNumber <= #self.hitBars then
        local currentBar = self.hitBars[self.currentBarNumber]
        currentBar:mousepressed()

        end
    end

end

function WeaponIronPan:UpdateBars(dt)
    if self.barsSpawned == true then
        if self.state == 3 then
            self:EndWeapon()
        end
    end
    for i = #self.hitBars, 1, -1 do
        bar = self.hitBars[i]

        if bar.x < -5 then
            bar.drawAlpha = bar.drawAlpha - 4 * dt
            bar.deathTime = bar.deathTime - dt * 0.7
            bar.badHit = true
            bar.extraY =  bar.extraY - 150 * dt
            if self.hitBars[self.currentBarNumber] == self then
                bar:mousepressed()
            end

        end

        bar:update(dt)

    end
end

function WeaponIronPan:use(owner, target)
    if self.state == 1 then
        self.barsSpawned = true
        self.target = target
        self.owner = owner
        if #self.hitBars <= 0 then
                for i = 1, 4 do
                    local bar = self:MakeBar(i * 32 + (math.random(32, 64) + 64))
        
                    table.insert(self.hitBars, bar)
                end 
                self.state = 2
        end
        return true
    end
end

function WeaponIronPan:draw()
    if #self.hitBars > 0 then
        love.graphics.draw(self.barImage, _G.player.x + self.barHitX, _G.player.y - 24)
        for i = #self.hitBars, 1, -1 do
            bar = self.hitBars[i]

            if bar.x < 96 then
                bar:draw()
            end
        end
    end
end

return WeaponIronPan
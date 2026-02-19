local player = _G.player
local entities = require('roomEntities')
WoodyMiniGun = Entity:extend()
local Image = require'assets'.images.enemies.woodyBoss.woodyBoss_gunMini
local Bullet = require'src.bullet'

function WoodyMiniGun:new(x, y, owner)

    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.owner = owner.owner

    self.image = Image

    self.bulletsMax = 1
    self.bullets = self.bulletsMax

    self.direction = 0
    self.image_angle = 0

    self.bulletInbetweenShootDelayMax = 1
    self.bulletInbetweenShootDelay = 1.5

    self.bulletReloadTimerMax = 100
    self.bulletReloadTimer = 100

    self.deathTimer = 0.6
    self.isDying = false
    self.isPlaying = true
    self.extraAngle = 0


    self.drawAlpha = 0
    self.extraAngleToAdd = -20



    self.STATES = {
        LINE = 1,
        SPRAY = 2,
        LINEMINIGUNS = 3,
    }

    self.state = self.STATES.LINE

    table.insert(require('roomEntities'), self)
end

function WoodyMiniGun:update(dt)
    if self.isDying == false then
        self.direction = self:getDirectionToObject(_G.player)
        self.image_angle = self.direction
    end

    if self.isDying then
        self.deathTimer = self.deathTimer - dt
        self.extraAngle = self.extraAngle + self.extraAngleToAdd * dt
        self.extraAngleToAdd = self.extraAngleToAdd * 0.8
    end

    if self.deathTimer < 0 or self.owner.actionTimer <= 0 then
        self:Destroy()
    end

    if self.drawAlpha < 1 then
        self.drawAlpha = self.drawAlpha + 3 * dt
    end

    if self.bullets > 0 then
        self.bulletInbetweenShootDelay = self.bulletInbetweenShootDelay - dt
        if self.bulletInbetweenShootDelay <= 0 then


            if self.state == self.STATES.LINE then
                local bullet = Bullet(self.x, self.y)
                bullet.bulletTimer = 0
                bullet.speed = 300
            end







            local sound = ripple.newSound(require'assets'.sounds.gunshot1)
            sound:play()
            self.bulletInbetweenShootDelay = self.bulletInbetweenShootDelayMax
            self.bullets = self.bullets - 1
        end
    else
        self.isDying = true
        self.bulletReloadTimer = self.bulletReloadTimer - dt
        if self.bulletReloadTimer < 0 then
            self.bullets = self.bulletsMax
            self.bulletReloadTimer = self.bulletReloadTimerMax
        end
    end

end

function WoodyMiniGun:draw()
    --love.graphics.draw(self.image, self.x, self.y)
    love.graphics.setColor(1, 1, 1, self.drawAlpha)
    love.graphics.draw(self.image, self.x + 2, self.y + 6, self.image_angle + self.extraAngle, 2, 2, self.width/2, self.height/2 )
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.print(self.bullets, self.x, self.y - 60)
    --love.graphics.print(self.bulletInbetweenShootDelay, self.x, self.y - 40)
    --love.graphics.print(self.bulletReloadTimer, self.x, self.y - 20)
end

return WoodyMiniGun
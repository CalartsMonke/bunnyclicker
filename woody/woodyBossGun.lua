local player = _G.player
WoodyGun = Entity:extend()
local Image = require'assets'.images.enemies.woodyBoss.woodyBoss_gun
local Bullet = require'src.bullet'
local Minigun = require'woody.woodyBossMiniGun'

function WoodyGun:new(x, y, owner)

    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.owner = owner

    self.image = Image

    self.bulletsMax = 6
    self.bullets = self.bulletsMax

    self.direction = 0
    self.image_angle = 0

    self.bulletInbetweenShootDelayMax = 0.05
    self.bulletInbetweenShootDelay = 0.1

    self.bulletReloadTimerMax = 0.2
    self.bulletReloadTimer = 0.2


    self.STATES = {
        LINE = 1,
        SPRAY = 2,
        LINEMINIGUNS = 3,
    }

    self.state = self.STATES.LINE
end

function WoodyGun:ChangeState(state)
    if state == self.STATES.LINE then
        
        self.bulletsMax = 6
        self.bullets = self.bulletsMax

        self.bulletInbetweenShootDelayMax = 0.05
        self.bulletInbetweenShootDelay = 0.1
    
        self.bulletReloadTimerMax = 0.2
        self.bulletReloadTimer = 0.2
        
        self.state = self.STATES.LINE
    end

    if state == self.STATES.SPRAY then
        
        self.bulletsMax = 999
        self.bullets = self.bulletsMax

        self.bulletInbetweenShootDelayMax = 0.05
        self.bulletInbetweenShootDelay = 0.1
    
        self.bulletReloadTimerMax = 0.2
        self.bulletReloadTimer = 0.2
        
        self.state = self.STATES.SPRAY
    end

    if state == self.STATES.LINEMINIGUNS then
        
        self.bulletsMax = 3
        self.bullets = 3

        self.bulletInbetweenShootDelayMax = 0.05
        self.bulletInbetweenShootDelay = 0.1
    
        self.bulletReloadTimerMax = 0.6
        self.bulletReloadTimer = 0.6
        
        self.state = self.STATES.LINEMINIGUNS
    end


end

function WoodyGun:update(dt)
    self.direction = self:getDirectionToObject(_G.player)
    self.image_angle = self.direction

    if self.bullets > 0 then
        self.bulletInbetweenShootDelay = self.bulletInbetweenShootDelay - dt
        if self.bulletInbetweenShootDelay <= 0 then
            if self.state == self.STATES.SPRAY then
                local player = _G.player
                local randDirection = self:getDirectionToObject(player) + math.rad(love.math.random(-30, 30))
                local bullet = Bullet(self.x, self.y, randDirection)
                bullet.bulletTimer = 0
                bullet.speed = 300
            end


            if self.state == self.STATES.LINE then
                local bullet = Bullet(self.x, self.y)
                bullet.bulletTimer = 0
                bullet.speed = 300
            end

            if self.state == self.STATES.LINEMINIGUNS then
                local bullet = Bullet(self.x, self.y)
                bullet.bulletTimer = 0
                bullet.speed = 350
            end









            local sound = ripple.newSound(require'assets'.sounds.gunshot2)
            sound.volume = 0.6
            sound:play()
            self.bulletInbetweenShootDelay = self.bulletInbetweenShootDelayMax
            self.bullets = self.bullets - 1
        end
    else
        self.bulletReloadTimer = self.bulletReloadTimer - dt
        if self.bulletReloadTimer < 0 then

            if self.state == self.STATES.LINEMINIGUNS then


                for i=1, 2 do
                    local randomX = love.math.random(10, 600)
                    local randomY = love.math.random(10, 300)
                    local minigun = Minigun(randomX, randomY, self)

                    if minigun:getDistanceToObject(_G.player) < 50 then
                        minigun.x = minigun.x + 50
                    end
                end
            end

            self.bullets = self.bulletsMax
            self.bulletReloadTimer = self.bulletReloadTimerMax
        end
    end

end

function WoodyGun:draw()
    love.graphics.draw(self.image, self.x, self.y)
    --love.graphics.draw(self.image, self.x + 2, self.y + 6, self.image_angle, 1, 1, self.width/2, self.height/2 )
    --love.graphics.print(self.bullets, self.x, self.y - 60)
    --love.graphics.print(self.bulletInbetweenShootDelay, self.x, self.y - 40)
    --love.graphics.print(self.bulletReloadTimer, self.x, self.y - 20)
end

return WoodyGun
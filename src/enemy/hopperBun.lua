
local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

enemyHopperBun = Enemy:extend() 

function enemyHopperBun:new(x, y)
    self.super.new(self,x,y)
    self.type = 'EnemyDasherBun'
    self.ENEMYNAME = "HOPPERBUN"
    self:addToTags("EnemyDasherBun")

    self.hpMax = 80
    self.hp = self.hpMax
    self.prevHp = self.hp
    self.image = require('assets').images.enemies.hopperBun.hopperbun_idle

    self.STATES =
    {
    NONE = 1,
    ACTIVE = 2,
    DEAD = 3,
    IDLE = 4,
    HOPPING = 5,
    RESTING = 6
    }
    self.speedMax = 225
    self.speed = self.speedMax
    self.dashTimer = 6
    self.dashTimerMax = 6
    self.aimAngle = 0
    self.state = self.STATES.IDLE

    self.hopsMax = 4
    self.hopsLeft = self.hopsMax
    self.hopSpeedDecrease = 300
    self.hopSpeed = 100
    self.hopDelayMax = 1
    self.hopDelay = self.hopDelayMax
    self.restTimeMax = 5
    self.restTime = self.restTimeMax


    self.flip = 1
    self.flipTimer = 0.1
    self.xScale = 1


    self.animFrames = {}
    self.frameWidth = 32
    self.frameHeight = 32
    self.frameToDraw = 1
    self.currentFrame = 1
    local aimage = require('assets').images.enemies.hopperBun.hopperbun_resting

    for i=0,1 do
        table.insert(self.animFrames, love.graphics.newQuad(i * self.frameWidth, 0, self.frameWidth, self.frameHeight, aimage:getWidth(), aimage:getHeight()))
    end

    self:addToGame(self.image, x, y)
end

local filter = function(item, other)
    if not item:is(Player) then
        return 'cross'
    end

    if item:is(Player) then
        return 'cross'
    end
end

function enemyHopperBun:update(dt)
    self:updateStatusEffects(dt)


    self.currentFrame = (self.currentFrame + 2 * dt)
    if self.currentFrame > #self.animFrames + 1  then
        self.currentFrame = 1
    end

    self.frameToDraw = math.floor(self.currentFrame)

    if self.state == self.STATES.HOPPING then
        if self.triAlphaCurrent <= self.triAlphaMax then
        self.triAlphaCurrent = self.triAlphaCurrent + dt
        end
    else
        if self.triAlphaCurrent >= 0 then
            self.triAlphaCurrent = self.triAlphaCurrent - dt
        end
    end

    self:updateCollisionTriangle(dt)
    self:updatePlayingState(dt)
    if self.isPlaying == true then
        self.world:update(self, self.x, self.y)

        if self.state == self.STATES.IDLE then
            
            if self.hopDelay > 0 then
                self.hopDelay = self.hopDelay - dt

            end

            if self.hopDelay <= 0 then
                    self.state = self.STATES.HOPPING
                    self.hopsLeft = self.hopsLeft - 1
                    self.speed = self.speedMax
                    self.direction = self:getDirectionToObject(_G.player)
                    for i=1, 6 do
                        local Xnum = love.math.random(20, 600)
                        local axe = require'src.projectiles.enemy.projectile_fallingAxe'(self.x, self.y, Xnum)
                        

                    end

            end
        end

        if self.state == self.STATES.HOPPING then
            

            local angle = self.direction
            self.speed = self.speed - self.hopSpeedDecrease * dt

            --RESET TO IDLE IF SPEED IS 0
            if self.speed <= 0 then

                if self.hopsLeft > 0 then
                    self.hopDelay = self.hopDelayMax
                    self.state = self.STATES.IDLE
                end


                --RESET TO RESTING IF HOPS ARE 0
                if self.hopsLeft <= 0 then
                    self.state = self.STATES.RESTING
                end
            end

            local newX = math.cos((angle or 10)) * self.speed * dt
            local newY = math.sin((angle or 10)) * self.speed * dt

            local cols, len
                self.x, self.y, cols, len = self.world:move(self, self.x + newX, self.y + newY, filter) --idk why this don't work
                --cols, len = self.world:queryRect(self.x, self.y, 16, 16)
        
                for i=1, len do
                    local col = cols[i]
                    local item = col.other
                    
                    if col.other.is then
                        if col.other:is(Player) then
                            if col.other.invicbility <= 0 then
                                col.other:TakeDamage(1)
                            end
                        end
                    end
                end
        end

        if self.state == self.STATES.RESTING then
            self.restTime = self.restTime - dt

            if self.restTime <= 0 then
                self.state = self.STATES.IDLE
                self.hopDelay = self.hopDelayMax * 2
                self.restTime = self.restTimeMax
                self.hopsLeft = self.hopsMax
            end
        end

    end
end

function enemyHopperBun:draw()
    if self.isPlaying == true then
        self:drawStatusEffects()
        self:drawCollisionTriangle()
        local image = self.image

        if self.state == self.STATES.HOPPING then
            image = require('assets').images.enemies.hopperBun.hopperbun_hopping
        elseif self.state == self.STATES.RESTING then
            image = require('assets').images.enemies.hopperBun.hopperbun_resting
        end

        if self.state == self.STATES.RESTING then
            love.graphics.draw(image, self.animFrames[self.frameToDraw], self.x, self.y)
        else
        love.graphics.setColor(1, 1, 1, self.drawAlpha)
        love.graphics.draw(image, self.x, self.y)
        love.graphics.setColor(1, 1, 1, 1)
        end

        --self:drawDebugHitbox()
    end
end

return enemyHopperBun
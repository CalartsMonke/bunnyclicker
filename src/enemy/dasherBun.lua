


local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

--bullet
local Bullet = require 'src.bullet'

enemyDasherBun = Enemy:extend()



function enemyDasherBun:new(x, y)
    self.super.new(self,x,y)
    self.type = 'EnemyDasherBun'
    self:addToTags("EnemyDasherBun")

    self.hpMax = 20
    self.hp = self.hpMax
    self.prevHp = self.hp
    self.image = require('assets').images.enemies.dasherBun.dasherbun_idle

    self.STATES =
    {
       NONE = 1,
       ACTIVE = 2,
       DEAD = 3,
       IDLE = 4,
       DASHING = 5,
    }
    self.speedMax = 225
    self.speed = self.speedMax
    self.dashTimer = 6
    self.dashTimerMax = 6
    self.aimAngle = 0
    self.state = self.STATES.IDLE
    self.flip = 1
    self.flipTimer = 0.1
    self.xScale = 1

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


function enemyDasherBun:update(dt)



    if self.state == self.STATES.DASHING then
        if self.triAlphaCurrent <= self.triAlphaMax then
        self.triAlphaCurrent = self.triAlphaCurrent + dt
        end
    else
        if self.triAlphaCurrent >= 0 then
            self.triAlphaCurrent = self.triAlphaCurrent - dt
        end
    end




    self:updateCollisionTriangle(dt)
    self:updatePlayingState()
    if self.isPlaying == true then

        self:updateStatusEffects(dt)

        if self.state == self.STATES.IDLE then
            world:update(self, self.x, self.y)
            self.dashTimer = self.dashTimer - dt

            if self.dashTimer <= 0 then
                self.state = self.STATES.DASHING
                self.direction = self:getDirectionToObject(_G.player)
                self.speed = self.speedMax
                if _G.player.x - self.x < 0 then
                    self.xScale = 1
                else
                    self.xScale = -1
                end
            end

        end

        if self.state == self.STATES.DASHING then
            local angle = self.direction
            self.speed = self.speed - 150 * dt

            if self.speed <= 0 then
                print("THIS IS RUNNING CORRECTLY")
                self.dashTimer = self.dashTimerMax
                self.state = self.STATES.IDLE
            end

            local newX = math.cos((angle or 10)) * self.speed * dt
            local newY = math.sin((angle or 10)) * self.speed * dt

            local cols, len
            self.x, self.y, cols, len = self.world:move(self, self.x + newX, self.y + newY, filter) --idk why this don't work
            --cols, len = self.world:queryRect(self.x, self.y, 16, 16)
    
            for i=1, len do
                local col = cols[i]
                local item = col.other
    
                if col.other:is(Player) then
                    if col.other.invicbility <= 0 then
                        col.other:TakeDamage(1)
                    end
                end
            end
        end
        if self.hp <= 0 then
            self:Die()
        end

        self.flipTimer = self.flipTimer - dt
        if self.flipTimer <= 0 then
            self.flip = self.flip * -1
            self.flipTimer = 0.05
        end


    end
end

function enemyDasherBun:draw()
    if self.isPlaying == true then
        self:drawStatusEffects()
        local offset = 0
        if self.dashTimer < self.dashTimerMax * 0.5 and self.state == self.STATES.IDLE then
            offset = (self.dashTimer - self.dashTimerMax + 2) * self.flip
        else
            offset = 0
        end

        if self.state == self.STATES.IDLE then
            self.image = require 'assets'.images.enemies.dasherBun.dasherbun_idle
        end
        if self.state == self.STATES.DASHING then
            self.image = require 'assets'.images.enemies.dasherBun.dasherbun_dash

        end
        self:drawCollisionTriangle()


        local originOffset = 0

        if self.xScale == 1 then
            originOffset = 0
        else
            originOffset = self.image:getWidth()
        end

        love.graphics.draw(self.image, self.x + (offset), self.y, 0, self.xScale, 1, originOffset, 0)
        love.graphics.print(tostring(self.hp), self.x + 5, self.y - 18)
        love.graphics.print(self.bulletTimer, self.x + 5, self.y - 32)
        love.graphics.print(self.state, self.x + 20, self.y - 50)

        self:drawDebugHitbox()
    end
end


return enemyDasherBun
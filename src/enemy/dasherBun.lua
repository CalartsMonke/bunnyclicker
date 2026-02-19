


local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

--bullet
local Bullet = require 'src.bullet'
local enemyid = require 'src.enemyid'
local physics = require 'physics'






--MAKE ATTACK REF FUNCTIONS
local TriBulletsAtSides = function(self, dt)
    if self.delayUntillNextAttack <= 0 then
        self.funvar1 = self.funvar1 + 1
        self.delayUntillNextAttack = self.delayUntillNextAttackMax

        local bulletImage = require 'assets'.images.projectiles.whiteBullet

        local angle = 0

        if self.funvar1 == 1 then
            angle = 0
            print(angle)
        end
        if self.funvar1 == 2 then
            angle = 90
            print(angle)
        end
        if self.funvar1 == 3 then
            angle = 180
            print(angle)
        end
        if self.funvar1 == 4 then
            angle = 270
            print(angle)
        end
        local battleBoxCenX = _G.battlebox.x + (_G.battlebox.width/2)
        local battleBoxCenY = _G.battlebox.y + (_G.battlebox.height/2)

        local newX = battleBoxCenX + math.cos(math.rad(angle)) * 130
        local newY = battleBoxCenY + math.sin(math.rad(angle)) * 130
        local attackAngle = angle + 180

        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle), bulletImage)
        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle + 10), bulletImage)
        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle - 10), bulletImage)

        if self.funvar1 >= 4 then
            self.funvar1 = 1
        end
        
    end
end
local focusattacks = require 'src.attacks'

enemyDasherBun = Enemy:extend()

function enemyDasherBun:new(x, y, params)
    self.super.new(self,x,y)
    self.type = 'EnemyDasherBun'
    self:addToTags("EnemyDasherBun")
    self.ENEMYNAME = "DASHERBUN"
    self.enemyid = enemyid.dasherbun

    self.bulletX = params.bulletX or 0
    self.bulletY = params.bulletY or 0
    self.fieldX = x
    self.fieldY = y

    self.hpMax = 80
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
       ATTACKING = 6,
    }
    self.fieldMode = true
    self.speedMax = 225
    self.speed = self.speedMax
    self.dashTimer = 6
    self.dashTimerMax = 6
    self.aimAngle = 0
    self.state = self.STATES.IDLE
    self.flip = 1
    self.flipTimer = 0.1
    self.xScale = 1
    self.playerTarget = nil

    self.attackStat = 5
    self.defenseStat = 0

    self:addToGame(self.image, x, y)
    self.shape:setSensor(true)

    self.attacks = {
        {attack = focusattacks.TriBulletsAtSides, owner = self, name = "EpicAttack1"},
        {attack = focusattacks.TriBulletsAtSides2, owner = self, name = "EpicAttack2"},
    }
end

function enemyDasherBun:returnToField()

end

function enemyDasherBun:focusAttack(dt)

end

function enemyDasherBun:update(dt)

    local dX, dY = 0, 0

    self:updateCollisionTriangle(dt)
    self:updatePlayingState(dt)
    if self.state == self.STATES.DASHING then
        if self.triAlphaCurrent <= self.triAlphaMax then
        self.triAlphaCurrent = self.triAlphaCurrent + dt
        end
    else
        if self.triAlphaCurrent >= 0 then
            self.triAlphaCurrent = self.triAlphaCurrent - dt
        end
    end

    if self.isPlaying == true then
        self:updateStatusEffects(dt)

        if self.body:isAwake() then
            print("AWAKE")
        else
            print("Snore mimimi")
        end
        self.body:setAwake(true)
        if self.state == self.STATES.IDLE then
            self.dashTimer = self.dashTimer - dt


             dX = 0
             dY = 0

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
                self.dashTimer = self.dashTimerMax
                self.state = self.STATES.IDLE
            end

            dX = math.cos((angle or 10)) * self.speed
            dY = math.sin((angle or 10)) * self.speed

            local cols, len
                    --MOVE
            self.body:setInertia(0)
            self.shape:setFriction(0)

            if self.playerTarget ~= nil then
                if self.playerTarget.invicbility <= 0 then
                    self.playerTarget:TakeDamage(self.attackStat)
                end
            end
        end
        self.flipTimer = self.flipTimer - dt
        if self.flipTimer <= 0 then
            self.flip = self.flip * -1
            self.flipTimer = 0.05
        end

        if self.fieldMode == true then
            self.body:setLinearVelocity(dX, dY)
            local px, py = self.body:getPosition()
            self.fieldX, self.fieldY = px, py
            self.x, self.y = px, py
        else
            self.x = self.bulletX
            self.y = self.bulletY
            self.body:setX(self.x)
            self.body:setY(self.y)
        end
    end
end

function enemyDasherBun:draw()
    physics.draw_body(self.body)
    if self.isPlaying == true then

        love.graphics.print(self.x, self.x, self.y - 16)
        love.graphics.print(self.y, self.x + 32, self.y - 16)
        self:drawStatusEffects()
        local offset = 0
        if self.dashTimer < self.dashTimerMax * 0.5 and self.state == self.STATES.IDLE then
            offset = (self.dashTimer - self.dashTimerMax + 2) * self.flip
        else
            offset = 0
        end

        if self.state == self.STATES.IDLE or self.state == self.STATES.ATTACKING then
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
        love.graphics.setColor(1, 1, 1, self.drawAlpha)
        love.graphics.draw(self.image, self.x + (offset), self.y, 0, self.xScale, 1, originOffset, 0)
        love.graphics.setColor(1, 1, 1, 1)




        --self:drawDebugHitbox()
    end


end


function enemyDasherBun.on_collision_start(self, other, normal_x, normal_y, x1, y1, x2, y2)
    if self.isPlaying == true then
        -- handler logic here, 
        local body_a = self:get_body() -- love.physics.Body
        local body_b = other:get_body() -- love.physics.Body
        local ax, ay = body_a:getPosition()
        local bx, by = body_b:getPosition()

        print("SOMETHING ENTERED COLLISION")
        if other.is then
            if other:is(Player) then
                self.playerTarget = other
            end
        end
    end

end

function enemyDasherBun.on_collision_exit(self, other, normal_x, normal_y, x1, y1, x2, y2)
    if self.isPlaying == true then
        -- handler logic here, 
        local body_a = self:get_body() -- love.physics.Body
        local body_b = other:get_body() -- love.physics.Body
        local ax, ay = body_a:getPosition()
        local bx, by = body_b:getPosition()

        if other == self.playerTarget or other:is(Player) then
            print("AWESOME")
            self.playerTarget = nil
        end
    end

end

function enemyDasherBun:collision_presolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end

function enemyDasherBun:collision_postsolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end


return enemyDasherBun
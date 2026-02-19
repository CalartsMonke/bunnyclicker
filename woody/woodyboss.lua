local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'
local anim8 = require 'lib.anim8'

local player

--bullet
local Bullet = require 'src.bullet'

local music = require'assets'.music.bosswoody

enemyWoodyBoss = Enemy:extend()

function enemyWoodyBoss:new(x, y)
    self.super.new(self,x,y)
    self.type = 'EnemyWoody'
    self:addToTags("Enemy")
    self:addToTags("EnemyWoody")
    self.music = music

    self.hpMax = 500
    self.hp = self.hpMax
    self.prevHp = self.hp

    self.isHurt = false
    self.hurtImageChangeTimerMax = 0.5
    self.hurtImageChangeTimer = 0.2


    self.gunX = self.x + 60
    self.gunY = self.y + 50
    self.gun = require 'woody.woodyBossGun'(self.gunX, self.gunY, self)

    self.OwnedProjectiles = {}



    self.image = require('assets').images.enemies.woodyBoss.woodyBoss_idle
    local g = anim8.newGrid(46, 95, self.image:getWidth(), self.image:getHeight())
    self.idleAnimation = anim8.newAnimation(g('1-6', 1), 0.3)

    self.images = {
        hurt1 = require'assets'.images.enemies.woodyBoss.woodyBoss_hurt1,
        aim = require'assets'.images.enemies.woodyBoss.woodyBoss_aim,
    }
    self.animations = {}

    self.animation = self.idleAnimation
    self.chargeGive = 100


    self.ATTACKSTATES = {
        IDLE = 1,
        SHOOTINGLINE = 2,
        HATTHROW = 3,
        SHOOTINGSPRAY = 4,
        SHOOTINGLINEMINIGUN = 5,
    }
    self.attackstate = self.ATTACKSTATES.IDLE

    self.actionsBeforeReturnToIdleMax = 3
    self.actionsBeforeReturnToIdle = self.actionsBeforeReturnToIdleMax

    self.actionTimer = 5
    self.idleTimerMax = 3
    self.idleTimer = self.idleTimerMax


    self:addToGame(self.image, self.x, self.y)
    self.width = 46
    self.height = 95
    self.world:update(self, self.x, self.y, self.width, self.height)
end

local filter = function(item, other)
    if not item:is(Player) then
        return 'cross'
    end

    if item:is(Player) then
        return 'cross'
    end
end

function enemyWoodyBoss:update(dt)
    if player ~= _G.player then
        player = _G.player
    end

    local newX, newY = 0, 0
    self.world:update(self, self.x, self.y, self.width, self.height)
    self.world:move(self, self.x + newX, self.y + newY, filter)
    self.animation:update(dt)

    self:updatePlayingState()
    if self.isPlaying == true then

        if self.isHurt == true then
            if self.hurtImageChangeTimer > 0 then
                self.hurtImageChangeTimer = self.hurtImageChangeTimer - dt
            end

            if self.hurtImageChangeTimer <= 0 then
                self.hurtImageChangeTimer = self.hurtImageChangeTimerMax
                self.isHurt = false
            end

        end

        self:updateStatusEffects(dt)
        if self.hp <= 0 then
            self:Die()
        end

        self.actionTimer = self.actionTimer - dt



        if self.attackstate == self.ATTACKSTATES.IDLE then
            if self.actionTimer <= 0 then
                --GET RANDOM STATE TO CHANGE INTO BUT FOR NOW ITS SHOOTINGLINE
                local state = self.ATTACKSTATES.SHOOTINGLINE

                self:transitionToState(state)
            end
        end

        if self.attackstate == self.ATTACKSTATES.SHOOTINGLINE then
            if self.gun ~= nil then
                self.gun:update(dt)
            end

            if self.actionTimer <= 0 then
                --GET RANDOM STATE TO CHANGE INTO BUT FOR NOW ITS SHOOTINGLINE
                local state = self.ATTACKSTATES.IDLE
                self:EndOfAttack()
                self:transitionToState(state)
            end

        end

        if self.attackstate == self.ATTACKSTATES.SHOOTINGSPRAY then
            if self.gun ~= nil then
                self.gun:update(dt)
            end

            if self.actionTimer <= 0 then
                --GET RANDOM STATE TO CHANGE INTO BUT FOR NOW ITS SHOOTINGLINE
                local state = self.ATTACKSTATES.IDLE
                self:EndOfAttack()
                self:transitionToState(state)
            end

        end

        if self.attackstate == self.ATTACKSTATES.SHOOTINGLINEMINIGUN then
            if self.gun ~= nil then
                self.gun:update(dt)
            end

            if self.actionTimer <= 0 then
                --GET RANDOM STATE TO CHANGE INTO BUT FOR NOW ITS SHOOTINGLINE
                local state = self.ATTACKSTATES.IDLE
                self:EndOfAttack()
                self:transitionToState(state)

            end

        end

        if self.attackstate == self.ATTACKSTATES.HATTHROW then
        
        end
    end

end

function enemyWoodyBoss:EndOfAttack()
    player:ChargeHealing(self.chargeGive)
end



function enemyWoodyBoss:transitionToState(state)



    if state == self.ATTACKSTATES.IDLE then
        self.attackstate = self.ATTACKSTATES.IDLE
        self.actionsBeforeReturnToIdle = self.actionsBeforeReturnToIdleMax
        self.actionTimer = self.idleTimerMax
    end

    if state == self.ATTACKSTATES.SHOOTINGLINE then
        self.attackstate = self.ATTACKSTATES.SHOOTINGLINE
        self.actionsBeforeReturnToIdle = self.actionsBeforeReturnToIdleMax
        self.actionTimer = 8
        self.gun:ChangeState(self.gun.STATES.LINE)
    end

    if state == self.ATTACKSTATES.SHOOTINGSPRAY then
        self.attackstate = self.ATTACKSTATES.SHOOTINGLINE
        self.actionsBeforeReturnToIdle = self.actionsBeforeReturnToIdleMax
        self.actionTimer = 8
        self.gun:ChangeState(self.gun.STATES.SPRAY)
    end

    if state == self.ATTACKSTATES.SHOOTINGLINEMINIGUN then
        self.attackstate = self.ATTACKSTATES.SHOOTINGLINEMINIGUN
        self.actionsBeforeReturnToIdle = self.actionsBeforeReturnToIdleMax
        self.actionTimer = 8
        self.gun:ChangeState(self.gun.STATES.LINEMINIGUNS)
    end
end




function enemyWoodyBoss:draw()


    --DRAW SPRITE BASED ON STATE
    if self.isPlaying == true then
        if self.isHurt == true then
            love.graphics.draw(self.images.hurt1, self.x, self.y, 0, 1, 1, 10, 0)
        else

            if self.attackstate == self.ATTACKSTATES.SHOOTINGLINE then
                love.graphics.draw(self.images.aim, self.x, self.y, 0, 1, 1, 10, 0)
                self.gun:draw()
                self.gun.x = self.x + 60
                self.gun.y = self.y + 25
            end

            if self.attackstate == self.ATTACKSTATES.SHOOTINGSPRAY then
                love.graphics.draw(self.images.aim, self.x, self.y, 0, 1, 1, 10, 0)
                self.gun:draw()
                self.gun.x = self.x + 60
                self.gun.y = self.y + 25
            end

            if self.attackstate == self.ATTACKSTATES.SHOOTINGLINEMINIGUN then
                love.graphics.draw(self.images.aim, self.x, self.y, 0, 1, 1, 10, 0)
                self.gun:draw()
                self.gun.x = self.x + 60
                self.gun.y = self.y + 25
            end

            if self.attackstate == self.ATTACKSTATES.IDLE then
                self.animation:draw(self.image, self.x, self.y)
            end
        end



    end



end



return enemyWoodyBoss
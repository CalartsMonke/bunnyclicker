local Entity = require 'src.entity'

local entities = require 'roomEntities'
local world = require 'world'
local battlemanager = require 'src.battlemanager'
local physics = require 'physics'

PlayerOverworld = Entity:extend()

local anim8 = require('lib.anim8')

local colliderXoff = 6
local colliderYoff = 8
local colliderWidth = 18
local colliderHeight = 24

local grv = 400
local fallGain = 100

local playerCollider



local images = {
    idle = require 'assets'.images.player.idle,
    move = require 'assets'.images.player.move,
}



local moveGrid = anim8.newGrid(32, 32, images.move:getWidth(), images.move:getHeight())
local animations = {
    move = anim8.newAnimation(moveGrid('1-4',1), 0.3)
}

function PlayerOverworld:new(x, y)
    self.PERSISTS = true
    self.x = x or 200
    self.y = y or 200
    self.width = 32
    self.height = 32

    self.world = world



    self.image = images.idle
    --self:addToGame(self.image, self.x, self.y)

    self.col = {
        world = self.world,
        x = self.x + 6,
        y = self.y + 8,
        width = colliderWidth,
        height = colliderHeight,
        collider = {},
    }


    self.body, self.shape = physics.new_rectangle_collider(self.world, 'dynamic', self.col.x, self.col.y - 100, self.col.width, self.col.height)
    self.shape:setUserData(self)

    playerCollider = self.col.collider


    self.moveSpeed = 100

    self.hspeed = 0
    self.hspeedMax = 100
    self.hspeedDecay = self.hspeedMax * 9
    self.hspeedGain = self.hspeedMax * 2
    self.vspeed = 10
    self.moveDirection = 1

    self.climbSpeed = 50

    self.stepDistance = 150
    self.climbStepTimerMax = 0.15
    self.climbStepTimer = self.climbStepTimerMax
    self.climbDirection = 1
    self.actualClimb = 0

    self.jumpForce = 0
    self.jumpsLeft = 1
    self.jumpsLeftMax = 1
    self.jumpHackTimer = 0.01

    self.currentLadderClimbing = nil


    self.GROUNDSTATES = {
        GROUNDED = 1,
        MIDAIR = 2,
    }

    self.isTouchingLadder = false
    self.groundState = self.GROUNDSTATES.MIDAIR

    self.currentTileStandingOn = nil


    table.insert(entities, self)

end

local filter = function(item, other, shape, otherShape)


    if other:is(WallNormal) then
        return 'slide'
    end
    if other:is(Ladder) then
        return 'cross'
    end

    return 'cross'
end

function PlayerOverworld:update(dt)





    if input:down('right') then
        self.hspeed = self.hspeed + self.hspeedGain * dt
        self.moveDirection = 1
    elseif input:down('left') then
        self.hspeed = self.hspeed + self.hspeedGain * dt
        self.moveDirection = -1
    else
        if self.hspeed > 0 then
            self.hspeed = self.hspeed - self.hspeedDecay * dt
        end
    end

    if input:pressed('subweapon') then
        if self.currentTileStandingOn ~= nil then
            if self.jumpsLeft > 0 then
                self.jumpsLeft = self.jumpsLeft - 1
                self.jumpForce = 200
                self.jumpHackTimer = 0.01
            end
        end
    end

    if self.jumpHackTimer > 0 then
        self.jumpHackTimer = self.jumpHackTimer - dt
    end
    local isTouchingLadder = false
    local climbStepGain = 0


    if self.isTouchingLadder == true then
        if input:down('up') then
            self.climbDirection = -1
            self.climbStepTimer = self.climbStepTimer - dt
        elseif input:down('down') then
            self.climbDirection = 1
            self.climbStepTimer = self.climbStepTimer - dt
        else
            self.climbStepTimer = self.climbStepTimerMax
        end

        self.vspeed = 0
    end

    if self.climbStepTimer <= 0 then
        self.climbStepTimer = self.climbStepTimerMax
        climbStepGain = self.stepDistance * self.climbDirection
        self.actualClimb = climbStepGain
    end


    if self.hspeed > 0 then
        animations.move:update((self.hspeed * 0.01) * dt)
    end

    if self.hspeed > self.hspeedMax then self.hspeed = self.hspeedMax end
    if self.hspeed <= 0 then self.hspeed = 0 end




    if self.groundState == self.GROUNDSTATES.MIDAIR and isTouchingLadder == false then
        self.vspeed = self.vspeed + grv * dt
    elseif self.groundState == self.GROUNDSTATES.GROUNDED then
        self.vspeed = 0
    end

    if self.jumpForce > 0 then
        --self.jumpForce = self.jumpForce - 100 * dt
    end
    if self.jumpForce < 0 then
        self.jumpForce = 0
    end
    flux.to(self, 0.5, {jumpForce = 0})
    flux.to(self, 0.125, {actualClimb = 0})

    local dX = 0
    local dY = 0
    local dYClimb = 0

    if self.isTouchingLadder == false then
        dX = (self.hspeed * self.moveDirection)
        dY = ((self.vspeed) - (self.jumpForce))
    else
        dX = (self.hspeed * self.moveDirection)
        dY = 0
        dYClimb = self.actualClimb
    end


    --MOVE
    self.body:setInertia(0)
    self.shape:setFriction(0)
    self.body:setLinearVelocity(dX * 1 , dY + dYClimb)
    local px, py = self.body:getPosition()
    self.x, self.y = px, py


    local items, len

    --reset colliderlision variables

    local isStandingOnSomething = false
    local hasJumped = false


    local foundLadder = false

    if self.currentTileStandingOn == nil then
        self.groundState = self.GROUNDSTATES.MIDAIR
    elseif self.currentTileStandingOn ~= nil then
        self.groundState = self.GROUNDSTATES.GROUNDED
    end


    --RESET
    self.currentTileStandingOn = nil


end

function PlayerOverworld:draw()

    --local x,y,w,h = self.world:getRect(self.collider)
    --love.graphics.setcolor(0,1,0)
        --love.graphics.rectangle('line', x, y, w, h)
    --love.graphics.setcolor(1,1,1)

    if self.currentTileStandingOn ~= nil then
        --local groundItem = self.currentTileStandingOn
        --local x,y,w,h = self.world:getRect(self.currentTileStandingOn)
        --love.graphics.setcollideror(0,0,1)
        --love.graphics.rectangle('line', x, y, w, h)
        --love.graphics.setcollideror(1,1,1)
    end

    physics.draw_body(self.body)
    if self.currentTileStandingOn then
        physics.draw_body(self.currentTileStandingOn.body)
    end


    local xscaleOff = 0
    if self.moveDirection == -1 then
        xscaleOff = self.image:getWidth()
    end

    if self.hspeed > 0 then 
        animations.move:draw(images.move, self.x + xscaleOff, self.y, 0, self.moveDirection, 1, 0, 0)
    else
        love.graphics.draw(images.idle, self.x + xscaleOff, self.y, 0, self.moveDirection, 1, 0, 0)
    end
end



function PlayerOverworld.on_collision_start(self, other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

    if other:is(Ladder) then
        self.isTouchingLadder = true
    end

    if other:is(EnemyOverworld) then
        battlemanager:LoadEncounter(other.encounter)
    end

end

function PlayerOverworld.on_collision_exit(self, other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

    if other:is(Ladder) then
        self.isTouchingLadder = false
    end

end

function PlayerOverworld:collision_presolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end

function PlayerOverworld:collision_postsolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

    --GET GROUND DATA


    if normal_y == 1 then
        --self.jumpForce = 0

        if self.jumpHackTimer <= 0 then
            self.jumpsLeft = self.jumpsLeftMax
            --self.jumpForce = 0
        end

        self.currentTileStandingOn = other
    end


end

return PlayerOverworld
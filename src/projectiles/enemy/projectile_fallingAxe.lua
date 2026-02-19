local proj = require 'src.projectiles.projectile'
local flux = require 'lib.flux'
local player = _G.player
ProjectileFallingAxe = proj:extend()

function ProjectileFallingAxe:new(x, y, targetX, targetY)

    self.type = "ProjFallingAxe"
    self.image = require "assets".images.projectiles.enemyAxe
    self.x = x
    self.y = y
    self.targetX = targetX or player.x
    self.targetY = targetY or 10

    self.IMAGE_ANGLE = 0

    self.travelTime = 0.3
    self.fallSpeed = 100
    self.damage = 1

    self:addToGame(self.image, self.x, self.y, 16, 16)
    table.insert(require "roomEntities", self)

    self.STATES = {
        TRAVEL = 1,
        FALLING = 2,
    }
    self.state = self.STATES.TRAVEL

    local selfx, selfy = x, y
    self.prevX = selfx
    self.prevY = selfy
    self.afterImagePositions = {
        {x = selfx, y = selfy, prevX = self.x, prevY = self.y, timer = 0.01, timerMax = 0.01},
        {x = selfx, y = selfy, prevX = self.x, prevY = self.y, timer = 0.02, timerMax = 0.02},
        {x = selfx, y = selfy, prevX = self.x, prevY = self.y, timer = 0.03, timerMax = 0.04},
    }



    self.trailTimerMax = 0.05
    self.trailTimer = self.trailTimerMax
end

function ProjectileFallingAxe:update(dt)

    local targetX = self.targetX
    local targetY = self.targetY
    if self.state == self.STATES.TRAVEL then
        flux.to(self, self.travelTime, {x = targetX })
        flux.to(self, self.travelTime, {y = targetY })
        self.IMAGE_ANGLE = self.IMAGE_ANGLE + 12 * dt

        if self.x > self.targetX - 2 and self.x < self.targetX + 2 then
            if self.y > self.targetY - 2 and self.y < self.targetY + 2 then
                self.state = self.STATES.FALLING
            end
        end
    end

    if self.state == self.STATES.FALLING then
        self.y = self.y + self.fallSpeed * dt

        self.fallSpeed = self.fallSpeed + (300 + self.fallSpeed*0.8) * dt

        self.IMAGE_ANGLE = self.IMAGE_ANGLE + 12 * dt
    end




    self.prevX, self.prevY = self.x, self.y

    self.trailTimer = self.trailTimer - dt
    if self.trailTimer <= 0 then
        self.trailTimer = self.trailTimerMax

        local prevImage = nil
        for i=1, #self.afterImagePositions do
            local image = self.afterImagePositions[i]

            image.timer = image.timer - dt

            if image.timer <= 0 then
                image.timer = image.timerMax
                if i == 1 then
                    image.prevX = image.x
                    image.prevY = image.y
                    image.x, image.y = self.prevX, self.prevY
                    prevImage = image
                else
                    local prevI = self.afterImagePositions[i-1]
                    image.prevX = prevI.x
                    image.prevY = prevI.y
                    image.x, image.y = prevI.prevX, prevI.prevY
                    prevImage = image
                end
            end


        end

    end


end

function ProjectileFallingAxe:draw()


    love.graphics.draw(self.image, self.x + 16, self.y + 16, self.IMAGE_ANGLE, 1, 1, self.width/2, self.height/2 )

    if self.state == self.STATES.FALLING then

        for i=1, #self.afterImagePositions do

            local image = self.afterImagePositions[i]
            love.graphics.setColor(1, 1, 1, 0.6 - (i *0.1))
            love.graphics.draw(self.image, image.x + 16, image.y + 16, self.IMAGE_ANGLE, 1, 1, self.width/2, self.height/2 )
            love.graphics.setColor(1, 1, 1, 1)
        end

    end
end


return ProjectileFallingAxe
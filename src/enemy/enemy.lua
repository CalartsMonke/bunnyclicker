local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

--bullet
local Bullet = require 'src.bullet'
Enemy = entity:extend()



function Enemy:new(x, y)

    self.STATES =
 {
    NONE = 1,
    ACTIVE = 2,
    DEAD = 3,
 }

    self.hp = 30
    self.state = self.STATES.ACTIVE
    self.isPlaying = false

    self.image = love.graphics.newImage('/img/laenemy.png/')
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.world = world

    self.aggro = 0
    self.aggroDecrease = 2
    self.aggroMult = 1
   

    world:add(self, self.x, self.y, self.width, self.height)

    --bullets
    self.bulletTimerMax = 3
    self.bulletTimer = self.bulletTimerMax
end


function Enemy:TakeDamage(damage, aggrotoadd)
if self.state ~= self.STATES.NONE or self.STATES.DEAD then
    self.hp = self.hp - damage
    
    --increase aggro
    self.aggro = self.aggro + (aggrotoadd * self.aggroMult)
end
end

function Enemy:updatePlayingState()
    if self.state ~= self.STATES.NONE and self.state ~= self.STATES.DEAD then
        self.isPlaying = true
    else
        self.isPlaying = false
    end
end

function Enemy:update(dt)
    self:updatePlayingState()
if self.isPlaying == true then

    if self.hp <= 0 then
        local coinDrop = require 'src.coinDrop'
        local Coin = coinDrop(self.x, self.y)
        self.state = self.STATES.DEAD
    end


    --aggro decrease
    self.aggro = self.aggro - (self.aggroDecrease * dt)

    --spawn bullets
    self.bulletTimer = self.bulletTimer - (dt + (self.aggro / 10000))
    if self.bulletTimer <= 0 then
        self.bulletTimer = self.bulletTimer + self.bulletTimerMax + love.math.random(1, 30) * 0.10

        self:SpawnBulletCircle(game.player, 4, 0.60, 100)
    end
end
end

function Enemy:draw()
if self.isPlaying == true then
    love.graphics.draw(self.image, self.x, self.y, 0, 0.5, 0.5)
    love.graphics.print(tostring(self.hp), self.x + 5, self.y - 18)
    love.graphics.print(self.bulletTimer, self.x + 5, self.y - 32)
    love.graphics.print(self.state, self.x + 20, self.y - 50)
end
end

--- Spawn a circle of bullets around the given object
function Enemy:SpawnBulletCircle(target, num, angleincrease, distance)
    local angle = math.floor(love.math.random(0, 360))
    for i=1, num do
    local tx, ty = target.x, target.y
    local bx, by = 0, 0


    bx = tx + (math.cos(angle + (angleincrease * i)) * distance)
    by = ty - (math.sin(angle + (angleincrease * i)) * distance)
    local bullet = Bullet(bx, by)
    end


end

return Enemy
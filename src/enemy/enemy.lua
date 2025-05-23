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

    self.parentRoom = nil

    self.hpMax = 30
    self.hp = self.hpMax
    self.state = self.STATES.ACTIVE
    self.isPlaying = false
    self.isBoss = false

    self.aggro = 0
    self.aggroDecrease = 2
    self.aggroMult = 1
   



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

--Do actions based on death and enemy state
function Enemy:Die()
    if self.isBoss == true then
        self.parentRoom:exit()
    end

    if self.isBoss == false then
        local coinDrop = require 'src.collectible.coinDrop'
        local heartDrop = require 'src.collectible.heartDrop'
        local Coin = coinDrop(self.x, self.y)
        --local Heart = heartDrop(self.x, self.y)
        self.state = self.STATES.DEAD
        self:Destroy()
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

--Spawn a line of horizontal bullets on the y axis of the given object
function Enemy:SpawnBulletHorizontal(target, num, distance, speed)
    local tx = target.x
    local ty = target.y
    local prevBullet = nil
    for i=1, num do

        local bullet = Bullet( tx + distance , ty)
        bullet.direction = math.rad(180)
        if prevBullet ~= nil then
        bullet.speed = prevBullet.speed * 0.8
        end
        prevBullet = bullet
    end

end

return Enemy
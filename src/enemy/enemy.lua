local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

--bullet
local Bullet = require 'src.bullet'
Enemy = entity:extend()



function Enemy:new(x, y)
    self.x = x or 100
    self.y = y or 100
    self.width = 32
    self.height = 32
    self.type = "Enemy"
    self:addToTags("Enemy")

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

    self.triAngle = 90
    self.triAlphaMax = 0.4
    self.triAlphaCurrent = 0
    self.trianglePoints = {}
    local tp = self.trianglePoints
    local sx, sy = self:getCenter()
    tp[1] = {sx, sy - 16}
    tp[2] = {sx - 16, sy + 16}
    tp[3] = {sx + 16, sy + 16}
end

function Enemy:updateCollisionTriangle(dt)
    local distance = 32
    self.triAngle = (self.triAngle + 100 * dt)
    local sx, sy = self:getCenter()
    local angle = self.triAngle % 360
    local tp = self.trianglePoints
    tp[1][1] = sx + math.cos(math.rad(90 + angle)) * distance;
    tp[1][2] = sy + math.sin(math.rad(90 + angle)) * distance;
    
    tp[2][1] = sx + math.cos(math.rad(210 + angle)) * distance;
    tp[2][2] = sy + math.sin(math.rad(210 + angle)) * distance;
    
    tp[3][1] = sx + math.cos(math.rad(330 + angle)) * distance;
    tp[3][2] = sy + math.sin(math.rad(330 + angle)) * distance;
     
end

function Enemy:drawCollisionTriangle()
    local tp = self.trianglePoints
    local verticies = { tp[1][1], tp[1][2], tp[2][1], tp[2][2], tp[3][1], tp[3][2]}

    love.graphics.setColor(1, 0, 0, self.triAlphaCurrent)
    love.graphics.polygon('fill', verticies)
    love.graphics.setColor(1, 1, 1, 1)

end

function Enemy:TakeDamage(damage, aggrotoadd)
    if self.state ~= self.STATES.NONE or self.STATES.DEAD then
        self.hp = self.hp - damage
        
        --increase aggro
        --self.aggro = self.aggro + (aggrotoadd * self.aggroMult)
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
        local chance = love.math.random(0, 2)

        if chance == 1 then
        local Coin = coinDrop(self.x, self.y)
        end
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

        local bullet = require('src.bullet')( tx + distance , ty)
        bullet.direction = math.rad(180)
        if prevBullet ~= nil then
        bullet.speed = prevBullet.speed * 0.8
        end
        prevBullet = bullet
    end

end

--- Spawn a circle of bullets around the given object
function Enemy:SpawnBulletWavyCircle(target, num, angleincrease, distance, wavyness, wavySpeed)
    local angle = math.floor(love.math.random(0, 360))
    for i=1, num do
    local tx, ty = target.x, target.y
    local bx, by = 0, 0


    bx = tx + (math.cos(angle + (angleincrease * i)) * distance)
    by = ty - (math.sin(angle + (angleincrease * i)) * distance)
    local bullet = require 'src.bulletWavy'(bx, by, wavyness, wavySpeed)
    end
end

--Spawn a line of horizontal bullets on the y axis of the given object
function Enemy:SpawnBulletWavyHorizontal(target, num, distance, speed)
    local tx = target.x
    local ty = target.y
    local prevBullet = nil
    for i=1, num do

        local bullet = require('src.bulletWavy')( tx + distance , ty, 3, 5)
        bullet.direction = math.rad(180)
        if prevBullet ~= nil then
        bullet.speed = prevBullet.speed * 0.8
        end
        prevBullet = bullet
    end

end

return Enemy
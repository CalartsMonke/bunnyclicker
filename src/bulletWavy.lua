local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'
local flux = require 'lib.flux'

BulletWavy = entity:extend()


function BulletWavy:new(x, y, wavyness, wavyspeed)
    self.x = x
    self.y = y
    self.offX = self.x - game.player.x
    self.offY = self.y - game.player.y
    self.world = world
    self.image = love.graphics.newImage('/img/bullet.png/')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.maxWavyness = wavyness
    self.currentWavyness = 0
    self.wavySpeed = wavyspeed
    self.wavyIncrease = true
    self.wavyMultiplier = 1


    self.states = {0, 1, 2}
    self.speed = 200

    table.insert(require('roomEntities'), self)
    self.world:add(self, self.x, self.y, self.width, self.height)


    local t = game.player
    local s = self
    self.sx, self.sy = self:getCenter()
    self.tsx, self.tsy = t:getCenter()
    self.direction = (math.atan2(self.tsy - self.sy, self.tsx - self.sx))



    --timer
    self.bulletTimer= 1

end

local function GetAngle(a, b)
    local angle = math.atan(b.y - a.y, b.x - a.x)
    return angle
end

local filter = function(item, other)
    if item:is(Bullet) then
        return 'cross'
    end

    if item:is(Player) then
        return 'cross'
    end
end

function BulletWavy:updateWavyness(dt)

    --flux.to(self, self.wavySpeed, {currentWavyness = self.maxWavyness * self.wavyMultiplier })

    if self.wavyIncrease == true then
        self.currentWavyness = self.currentWavyness + self.wavySpeed * dt

        if self.currentWavyness >= self.maxWavyness then
            self.wavyIncrease = false
            self.wavyMultiplier = -1
            self.currentWavyness = self.maxWavyness
        end
    end

    if self.wavyIncrease == false then
        self.currentWavyness = self.currentWavyness + (self.wavySpeed * -1) * dt

        if self.currentWavyness >= self.maxWavyness * -1 then
            self.wavyIncrease = true
            self.wavyMultiplier = 1
            self.currentWavyness = self.maxWavyness * -1
        end
    end

end

function BulletWavy:update(dt)
    self:updateWavyness(dt)
    local tx, ty = game.player.x, game.player.y

    if self.bulletTimer <= 0 then


        local sx, sy = self:getCenter()
        local angle = self.direction

        local newX = math.cos((angle)) * self.speed * dt
        local newY = math.sin((angle + self.currentWavyness )) * self.speed * dt
        
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

    else
        self.x = game.player.x + self.offX
        self.y = game.player.y + self.offY
       self.bulletTimer = self.bulletTimer - dt
    end

        

end

function BulletWavy:draw()
    local x,y,w,h = self.world:getRect(self)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle('line', x, y, w, h)
    love.graphics.setColor(1,1,1)

    love.graphics.draw(self.image, self.x, self.y)


end

return BulletWavy
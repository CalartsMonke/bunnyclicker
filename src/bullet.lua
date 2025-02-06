local entity = require 'src.entity'
local world = require 'world'
local game = require 'gameStats'

Bullet = entity:extend()


function Bullet:new(x, y)
    self.x = x
    self.y = y
    self.offX = self.x - game.player.x
    self.offY = self.y - game.player.y
    self.world = world
    self.image = love.graphics.newImage('/img/bullet.png/')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()


    self.states = {0, 1, 2}
    self.speed = 200

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
        print("RETURNING NIL")
        return 'cross'
    end

    if item:is(Player) then
        print('RETURNING CROSS')
        return 'cross'
    end
end

function Bullet:update(dt)
    local tx, ty = game.player.x, game.player.y

    if self.bulletTimer <= 0 then

        if self:is(Bullet) then
            print("I AM A BULLET")
        end


        local sx, sy = self:getCenter()
        local angle = self.direction

        local newX = math.cos((angle)) * self.speed * dt
        local newY = math.sin((angle)) * self.speed * dt
        
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
                print("PLAYER TOOK DAMAGE")
            end
        end

    else
        self.x = game.player.x + self.offX
        self.y = game.player.y + self.offY
       self.bulletTimer = self.bulletTimer - dt
    end

        

end

function Bullet:draw()
    local x,y,w,h = self.world:getRect(self)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle('fill', x, y, w, h)
    love.graphics.setColor(1,1,1)

    love.graphics.draw(self.image, self.x, self.y)


end

return Bullet
local entity = require 'src.entity'
local world = require 'world'
local physics = require 'physics'
local game = require 'gameStats'
local assets = require 'assets'
local defaultImage = assets.images.projectiles.whiteBullet
local colXoff = 4
local colYoff = 4

Bullet = entity:extend()


function Bullet:new(x, y, direction)
    self.x = x
    self.y = y
    self.offX = self.x - game.player.x
    self.offY = self.y - game.player.y
    self.world = world
    self.image = defaultImage
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.damage = 1


    self.states = {0, 1, 2}
    self.speed = 200

    self.col = {
        world = self.world,
        x = self.x + colXoff,
        y = self.y + colYoff,
        width = 8,
        height = 8,
    }
    self.body, self.shape = physics.new_rectangle_collider(world, 'dynamic', self.x, self.y, 8, 8)
    self.shape:setUserData(self)
    self.shape:setSensor(true)


    local t = game.player
    local s = self
    self.sx, self.sy = self:getCenter()
    self.tsx, self.tsy = t:getCenter()
    self.direction = direction or (math.atan2(self.tsy - self.sy, self.tsx - self.sx))


    self.deathTimer = 20



    --timer
    self.bulletTimer=0

end

local function GetAngle(a, b)
    local angle = math.atan(b.y - a.y, b.x - a.x)
    return angle
end

local filter = function(item, other)
    return 'cross'
end

function Bullet:update(dt)
    local tx, ty = game.player.x, game.player.y

    if self.bulletTimer <= 0 then


        local sx, sy = self:getCenter()
        local angle = self.direction

        local dX = math.cos((angle)) * self.speed
        local dY = math.sin((angle)) * self.speed
        
        self.body:setLinearVelocity(dX, dY)
        local px, py = self.body:getPosition()
        self.x, self.y = px, py

    else
        self.x = game.player.x + self.offX
        self.y = game.player.y + self.offY
       self.bulletTimer = self.bulletTimer - dt
    end

        self.deathTimer = self.deathTimer - dt
        if self.deathTimer <= 0 then self:Destroy() end

end

function Bullet:draw()

    love.graphics.draw(self.image, self.x, self.y)


end

function Bullet.on_collision_start(self, other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

    if other.is then
        if other:is(Player) then
            if other.invicbility <= 0 then
                other:TakeDamage(self.damage or 1)
            end
        end
    end

end

function Bullet.on_collision_exit(self, other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end

function Bullet:collision_presolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end

function Bullet:collision_postsolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end

return Bullet
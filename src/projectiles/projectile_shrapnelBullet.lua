local proj = require 'src.projectiles.projectile'

ProjectileShrapnelBullet = proj:extend()

function ProjectileShrapnelBullet:new(x, y)

    self.type = "ProjShrapnelBullet"
    self.image = require "assets".images.projectiles.smallBullet
    self.x = x
    self.y = y

    self.speed = 500
    self.damage = 3

    self:addToGame(self.image, self.x, self.y, 16, 16)
    table.insert(require "roomEntities", self)

    self.timer = 1

end

local filter = function(item, other)
    if not item:is(Player) then
        return 'cross'
    end

    if item:is(ProjectileShrapnelBullet) then
        return 'cross'
    end
end

function ProjectileShrapnelBullet:update(dt)


    if self.speed > 5 then
        self.speed = self.speed - 1000 * dt
    end


    self.timer = self.timer - dt

    if self.timer < 0 then
        self:Destroy()
    end


    if self.timer > 0 then 
    local angle = self.direction

    local newX = math.cos((angle)) * self.speed * dt
    local newY = math.sin((angle)) * self.speed * dt

    local cols, len
    self.x, self.y, cols, len = self.world:move(self, self.x + newX, self.y + newY, filter) --idk why this don't work
    --cols, len = self.world:queryRect(self.x, self.y, 16, 16)

    for i=1, len do
        local col = cols[i]
        local item = col.other

        if item:is(Enemy) then
            if item.isPlaying == true then
            
                col.other:TakeDamage(self.damage)
                self:Destroy()
            end
        end
    end

end
end

function ProjectileShrapnelBullet:draw()
    love.graphics.setColor(1, 1, 1, self.timer + 0.25)
    love.graphics.draw(self.image, self.x + 16, self.y + 16, self.direction, 0.5, 0.5, self.width/2, self.height/2 )
    love.graphics.setColor(1, 1, 1, 1)
    --self:drawDebugHitbox()
end

return ProjectileShrapnelBullet
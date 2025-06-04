local proj = require ('src.projectiles.projectile')

ProjectileBrownBrick = proj:extend()

function ProjectileBrownBrick:new(x, y)
    self.type = "ProjBrownBrick"
    self.image = require "assets".images.projectiles.brownBrick
    self.x = x
    self.y = y

    self.speed = 500
    self.damage = 50

    self:addToGame(self.image, self.x, self.y, 16, 16)
    table.insert(require "roomEntities", self)

    self.target = self:getNearestObjectInCircle(500, "Enemy")
    if self.target ~= nil then
        self.direction = self:getDirectionToObject(self.target)
    else
        self.direction = love.math.random(0, 100)
    end
    print("THE DIRECTION IS "..self.direction)
    --self.direction = 90


end

local filter = function(item, other)
    if not item:is(Player) then
        return 'cross'
    end

    if item:is(Player) then
        return 'cross'
    end
end

function ProjectileBrownBrick:update(dt)



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

function ProjectileBrownBrick:draw()
    love.graphics.draw(self.image, self.x + 16, self.y + 16, self.direction, 0.5, 0.5, self.width/2, self.height/2 )

   -- self:drawDebugHitbox()
end

return ProjectileBrownBrick
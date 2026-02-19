local entity = require ('src.entity')
local entities = require ('roomEntities')

PlayerBulletStatic = entity:extend()

function PlayerBulletStatic:new(x, y, damage)
    self.STATES = {
        ACTIVE = 1,
        HIT = 2,
    }
    self.state = self.STATES.ACTIVE
    self.timer = 0
    self.deathTime = 0.1
    self.damage = damage
    self.x = x
    self.y = y
    self.width = 8
    self.height = 8
    self.world = require('world')
    self.world:add(self, self.x, self.y, self.width, self.height)
    table.insert(entities, self)

    
end

function PlayerBulletStatic:update(dt)
    self.timer = self.timer + dt


        if self.state == self.STATES.ACTIVE then
            --get items to interact with
            local items, len = self.world:queryRect(self.x - 2, self.y - 2, self.width + 2, self.height + 2)

            local tableOfEnemies = {}
            for i = 1, len do
                local item = items[i]

                if item:is(Enemy) then
                    if item.isPlaying then
                        item:TakeDamage(self.damage, 0)
                        self.state = self.STATES.HIT
                    end
                end    
            end
        end


        if self.timer >= self.deathTime then
            self:Destroy()
        end

end

function PlayerBulletStatic:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return PlayerBulletStatic
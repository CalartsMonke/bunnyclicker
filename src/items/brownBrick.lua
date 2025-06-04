local iitem = require('src.items.inventoryItem')
local player = _G.player

BrownBrick = iitem:extend()

function BrownBrick:new()
    self.STATES = {
        INACTIVE = 1,
        ACTIVE = 2,
    }
    self.image = require('assets').images.brownBrick
    self.state = self.STATES.INACTIVE
    self.name = "Brown Brick"
    self.rechargeTimeMax = 0
    self.rechargeTime = 0

    self.damage = 0
end

function BrownBrick:update(dt)
    if self.state == self.STATES.INACTIVE and _G.player.resumesword == nil then
        if self.rechargeTime <= self.rechargeTimeMax then
            self.rechargeTime = self.rechargeTime + dt
            end
    end

end

function BrownBrick:Use()
        local sx, sy = _G.player:getCenter()
        local item = require "src.projectiles.projectile_brownBrick"(sx - 8,  sy - 8)
        self:removeFromPlayerActives()
end

function BrownBrick:draw()

end

return BrownBrick


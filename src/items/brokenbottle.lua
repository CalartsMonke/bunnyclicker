local iitem = require('src.items.inventoryItem')
local player = _G.player

Brokenbottle = iitem:extend()

function Brokenbottle:new()
    self.STATES = {
        INACTIVE = 1,
        ACTIVE = 2,
    }
    self.image = require('assets').images.brokenBottle
    self.state = self.STATES.INACTIVE
    self.name = "Broken Bottle"
    self.rechargeTimeMax = 10
    self.rechargeTime = 0

    self.damage = 6
end

function Brokenbottle:update(dt)
    if self.state == self.STATES.INACTIVE and _G.player.resumesword == nil and not _G.player.equippedWeapon:is(WeaponBrokenBottle) then
        if self.rechargeTime <= self.rechargeTimeMax then
            self.rechargeTime = self.rechargeTime + dt
            end
    end

end

function Brokenbottle:Use()
        if self.rechargeTime >= self.rechargeTimeMax then
            _G.player.equippedWeapon = require('src.weapons.weapon_brokenBottle')()
            self.rechargeTime = self.rechargeTime - self.rechargeTimeMax
        end
end

function Brokenbottle:draw()

end

return Brokenbottle


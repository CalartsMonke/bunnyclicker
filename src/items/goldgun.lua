local iitem = require('src.items.inventoryItem')
local player = _G.player

GoldGun = iitem:extend()

function GoldGun:new()
    self.STATES = {
        INACTIVE = 1,
        ACTIVE = 2,
    }
    self.image = require('assets').images.goldGun
    self.state = self.STATES.INACTIVE
    self.name = "Gold Gun"
    self.price = 17
    self.isActive = true
    self.rechargeTimeMax = 10
    self.rechargeTime = 0
end

function GoldGun:update(dt)

    if self.state == self.STATES.INACTIVE and _G.player.resumesword == nil and not _G.player.equippedWeapon:is(WeaponGoldGun) then
        if self.rechargeTime <= self.rechargeTimeMax then
            self.rechargeTime = self.rechargeTime + dt
            end
    end

end

function GoldGun:Use()
    if self.rechargeTime >= self.rechargeTimeMax then
        _G.player.equippedWeapon = require('src.weapons.weapon_goldGun')()
        self.rechargeTime = self.rechargeTime - self.rechargeTimeMax
    end
    
end

function GoldGun:draw()

end

return GoldGun


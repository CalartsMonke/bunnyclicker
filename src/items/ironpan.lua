local iitem = require('src.items.inventoryItem')
local player = _G.player

IronPan = iitem:extend()

function IronPan:new()
    self.STATES = {
        INACTIVE = 1,
        ACTIVE = 2,
    }
    self.currentCharges = 1
    self.maxCharges = 4
    self.chargeProgressMax = 50
    self.chargeProgress = 0
    self.image = require('assets').images.items.ironpan
    self.state = self.STATES.INACTIVE
    self.name = "Iron Pan"
    self.isActive = true
    self.rechargeTimeMax = 10
    self.rechargeTime = 0
    self.price = 4

    self.damage = 6
end

function IronPan:update(dt)
    if self.state == self.STATES.INACTIVE and _G.player.resumesword == nil and not _G.player.equippedWeapon:is(WeaponIronPan) then
        if self.rechargeTime <= self.rechargeTimeMax then
            self.rechargeTime = self.rechargeTime + dt
            end
    end

end

function IronPan:Use()
        if self.currentCharges > 0 then
            self.currentCharges = self.currentCharges - 1
            _G.player.equippedWeapon = require('src.weapons.weapon_ironpan')()
            self.rechargeTime = self.rechargeTime - self.rechargeTimeMax
        end
end

function IronPan:draw()

end

return IronPan


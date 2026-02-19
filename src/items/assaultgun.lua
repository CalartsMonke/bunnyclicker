local iitem = require('src.items.inventoryItem')
local player = _G.player

AssaultGun = iitem:extend()

function AssaultGun:new()
    self.STATES = {
        INACTIVE = 1,
        ACTIVE = 2,
    }
    self.image = require('assets').images.assualtGun
    self.state = self.STATES.INACTIVE
    self.name = "Assault Gun"
    self.isActive = true
    self.price = 10
    self.rechargeTimeMax = 10
    self.rechargeTime = 0

    self.currentCharges = 1
    self.maxCharges = 4
    self.chargeProgressMax = 50
    self.chargeProgress = 0

    self.chargeCurrent = 0
    self.chargeMax = 250
    self.level1ChargeCost = 125
    self.level2ChargeCost = 225
    self.level3ChargeCost = 250
end

function AssaultGun:update(dt)

    if self.state == self.STATES.INACTIVE and _G.player.resumesword == nil and not _G.player.equippedWeapon:is(WeaponAssualtGun) then
        if self.rechargeTime <= self.rechargeTimeMax then
        self.rechargeTime = self.rechargeTime + dt
        end
    end

end

function AssaultGun:Use()
    if self.currentCharges > 0 then
        self.currentCharges = self.currentCharges - 1
        _G.player.equippedWeapon = require('src.weapons.weapon_assualtGun')()
        self.rechargeTime = self.rechargeTime - self.rechargeTimeMax
    end
    
end

function AssaultGun:draw()

end

return AssaultGun


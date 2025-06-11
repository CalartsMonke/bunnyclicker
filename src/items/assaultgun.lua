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
end

function AssaultGun:update(dt)

    if self.state == self.STATES.INACTIVE and _G.player.resumesword == nil and not _G.player.equippedWeapon:is(WeaponAssualtGun) then
        if self.rechargeTime <= self.rechargeTimeMax then
        self.rechargeTime = self.rechargeTime + dt
        end
    end

end

function AssaultGun:Use()
    if self.rechargeTime >= self.rechargeTimeMax then
        _G.player.equippedWeapon = require('src.weapons.weapon_assualtGun')()
        self.rechargeTime = self.rechargeTime - self.rechargeTimeMax
    end
    
end

function AssaultGun:draw()

end

return AssaultGun


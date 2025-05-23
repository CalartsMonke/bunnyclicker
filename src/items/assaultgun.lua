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
    self.reloadTimeMax = 20
    self.reloadTime = 15
    self.ammoMax = 8
    self.ammoUses = 0

    self.damage = 6
end

function AssaultGun:update(dt)
    if self.state == self.STATES.ACTIVE then
        if _G.player.leftmbpressed then
            self.ammoUses = self.ammoUses - 1
            local Bullet = require ('src.playerBullet')
            local bullet = Bullet(_G.player.x, _G.player.y, self.damage)
        end

        if self.ammoUses <= 0 then
            self.state = self.STATES.INACTIVE
        end
    end

    if self.state == self.STATES.INACTIVE and _G.player.resumesword == nil then
        self.reloadTime = self.reloadTime + dt
    end

end

function AssaultGun:Use()
    if self.reloadTime >= self.reloadTimeMax then
        _G.player:releaseSword()
        self.ammoUses = self.ammoMax
        self.state = self.STATES.ACTIVE
        self.reloadTime = 0
    end
    
end

function AssaultGun:draw()

end

return AssaultGun


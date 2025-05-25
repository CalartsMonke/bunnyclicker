local weapon = require "src.weapons.weapon"

WeaponDagger = weapon:extend()

function WeaponDagger:new()
    self.damage = 4
    self.delay = 60/5
    self.delayMax = 60/5
    self.uses = nil
end

function WeaponDagger:update()

end

function WeaponDagger:use()

end

function WeaponDagger:draw()

end

return WeaponDagger
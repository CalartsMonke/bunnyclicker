

local HealingItem = Object:extend()


function HealingItem:AddToCharge(charge)
    self.charge = self.charge + charge
end

return HealingItem
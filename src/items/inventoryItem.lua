

InventoryItem = Object:extend()

function InventoryItem:new()

    self.currentCharges = 1
    self.maxCharges = 4
    self.chargeProgressMax = 75
    self.chargeProgress = 0

end

function InventoryItem:update()

end

function InventoryItem:draw()

end

function InventoryItem:removeFromPlayerActives()

end

return InventoryItem
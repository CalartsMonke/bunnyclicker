

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
    local activeItems = _G.player.activeItems

    for i=1, #activeItems do
        item = activeItems[i]

        if item == self then
            activeItems[i] = nil
        end
    end
end

function InventoryItem:processCharge()
    if self.chargeProgress >= self.chargeProgressMax then
        if self.currentCharges < self.maxCharges then
            self.chargeProgress = self.chargeProgress - self.chargeProgressMax
            self.currentCharges = self.currentCharges + 1
        end
    end
end

return InventoryItem


InventoryItem = Object:extend()

function InventoryItem:new()

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

return InventoryItem
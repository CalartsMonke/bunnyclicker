local entities = require('roomEntities')
local object = require('lib.classic')
local gameStats = require('gameStats')
local shopHeart = require('src.shopHeart')

local shopNone = {
    price = 0
}

RoomShop = object:extend()

function RoomShop:new()
    self.parentDungeon = nil
    self.isCleared = false
    self.displayName = 'THIS IS A FLIPPING SHOP'
    self.items = {shopHeart(200, 200)}
    self.setSelected = nil
    self.previewIndex = nil
    self.selectedItems = nil
end

function RoomShop:keypressed(key, scancode, isrepeat)
    if key == 'a' then
        self.selectedItems = 1
    end

    if key == 'd' then
        self.selectedItems = 2
    end

    if key == 'w' then
        self.previewIndex = self.previewIndex - 1
    end

    if key == 'return' then
        self:exit()
    end
end

function RoomShop:enter()
    for i=#self.items, 1, -1 do
        local item = table.remove(self.items, 1)
        item.isActive = true

        table.insert(entities, item)
    end
end

function RoomShop:exit()
    for i=#entities, 1, -1 do
        local item = entities[i]

        if item:is(shopItem) then
            local shopitem = table.remove(entities, i)
            shopitem.isActive = false
            table.insert(self.items, shopitem)
        end
    end
    self.parentDungeon:returnToRoomSelect()
end

local player = require ('gameStats').player
local world = require ('world')

function RoomShop:update(dt)


       --UPDATE ENTITIES
       for i = 1, #entities do
        
        if i <= #entities then
            local item = entities[i]
            if player.resumesword == nil then
                item:update(dt)
            end
            if player.resumesword ~= nil then
                if item:is(Player) then
                    item:update(dt)
                end
                if item:is(Resumesword) then
                item:update(dt)
                end
            end
        end
    end
end

function RoomShop:draw()
    print("THIS IS WORKING")

    --Draw items im too lazy to sort rn
    local worldItems, worldLen = world:getItems()
    for i = 1, worldLen do
        local item = worldItems[i]
        item:draw()
    end

end

return RoomShop
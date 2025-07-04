local entity = require 'src.entity'
local world = require 'world'
local Resumesword = require 'src.resumesword'

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'
local entities = require 'roomEntities'

local chart = require 'src.debugchart'

--TEMP
local Gun = require 'src.items.assaultgun'

Player = Entity:extend()

function Player:new()
self.states = {1, 2}
self.state = 1


self.x, self.y = 1, 1

self.mOffX, self.mOffY = 8, 8
self.width, self.height = 8, 8
self.boxX, self.boxY = self.x, self.y
self.insideBox = false
self.resumesword = nil
self.world = world

--IMAGES
self.image = love.graphics.newImage('/img/cursor.png/')

--spawn inital sword
self.resumesword = Resumesword(love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 50, love.graphics.getHeight()/2, love.graphics.getWidth()/2)
self.resumesword.state = 2
self.boxX = 0
self.boxY = 0


--Shop stats
self.shopNormalKarma = 100
self.shopDarkKarma = 100
self.shopDrugKarma = 100


--ITEMS
self.activeItems = {
    require'src.items.ironpan'()
}
self.activeItemMax = 1
self.consumableItems = {
    require 'src.items.brownBrick'()
}
self.consumableItemsMax = 1
self.passiveItems = {

}
self.passiveItemsMax = 999

--damage stats
self.equippedWeapon = require('src.weapons.weapon_ironpan')()
self.baseDamage = 1
self.aggroAdd = 3

--hp
self.maxHp = 5
self.currentHp = self.maxHp
self.invicbilityMax = 1.5
self.invicbility = self.invicbilityMax

self.rotate = 0
self.rotateMax = 0

self.prevX = self.x
self.prevY = self.y

self.coins = 0

self.hasBossKey = false


self.leftmbpressed = false
print("THE PLAYER IS MADE")
world:add(self, self.x, self.y, self.width, self.height)
end

function Player:TakeDamage(amt)
    self.currentHp = self.currentHp - amt

    self.invicbility = self.invicbility + self.invicbilityMax
end

local filter = function(item, other)
    if item:is(Bullet) then
        return 'cross'
    end

    if item:is(Player) then
        return nil
    end
end

function Player:releaseSword()
    self.resumesword = Resumesword(self.x, self.y, self.boxX, self.boxY)
    self.boxX = 0
    self.boxY = 0
end

function Player:keypressed(key, scancode, isrepeat)
    local items = self.activeItems

    if key == 'p' then
        self.equippedWeapon = require('src.weapons.weapon_ironpan')()
    end

    if key == 'z' then
        if items[1] ~= nil then
            if items[1].Use ~= nil then
                self.activeItems[1]:Use()
            end
        end
    end
    if key == 'x' then
        if self.consumableItems[1] ~= nil then
            if self.consumableItems[1].Use ~= nil then
                self.consumableItems[1]:Use()
            end
        end
    end
    if key == 'c' then
        if items[3] ~= nil then
            if items[3].Use ~= nil then
            self.activeItems[3]:Use()
            end
        end
    end

    if key == 'o' then
        self.hasBossKey = true
    end
end

function Player:addToItems(item)
    if item.isConsumable == true then
        self:addItemToConsumables(item)
    end
    if item.isActive == true then
        self:addItemToActives(item)
    end
    if item.isPassive == true then
        self:addItemToPassives(item)
    end

end

function Player:addItemToActives(item)
    local items = self.activeItems
    local itemsMax = self.activeItemMax

    items[1] = item
end

function Player:addItemToConsumables(item)
    local items = self.consumableItems
    local itemsMax = self.consumableItemsMax

    items[1] = item

end

function Player:addItemToPassives(item)
    local items = self.passiveItems
    local itemsMax = self.passiveItemsMax

    if #items < itemsMax then
        table.insert(items, item)
    else
        
    end

end

function Player:updatePrevPos()
    self.prevX = self.x
    self.prevY = self.y
end

function Player:updateRotate(dt)
    local rotateDecrease = 4
    self.rotateMax = self.rotateMax + (self.x - self.prevX)

    self.rotate = self.rotate + self.rotateMax * dt 
    --bring back down
    flux.to(self, 0.2, {rotateMax = 0 })

    local maxRotate = 90
    if self.rotate > math.rad(maxRotate) then
        self.rotate = math.rad(maxRotate)
    end

    local minRotate = -45
    if self.rotate < math.rad(minRotate) then
        self.rotate = math.rad(minRotate)
    end
    --
end

function Player:itemsUpdate(dt)
    self.equippedWeapon:update(dt)
    --transform into base item if uses are gone
    if self.equippedWeapon.uses <= 0 then
        self.equippedWeapon = require('src.weapons.weapon_dagger')()
    end
    for i = 1, #self.activeItems, 1 do
        if self.activeItems[i] ~= nil then
            local item = self.activeItems[i]
            item:update(dt)
        end

    end
end

function Player:mousepressed(x, y, button, istouch)
    if self.equippedWeapon.mousepressed ~= nil then
        self.equippedWeapon:mousepressed(x, y, button, istouch)
    end
    for i = 1, #self.activeItems, 1 do
        if self.activeItems[i] ~= nil then
            local item = self.activeItems[i]
            if item.mousepressed ~= nil then
                item:mousepressed(x, y, button, istouch)
            end
        end
    end

    if button == 2 then
        local sx, sy = _G.player:getCenter()
        local item = require "src.projectiles.projectile_brownBrick"(sx - 8,  sy - 8)
        
    end

end


function Player:update(dt)
    self:updateRotate(dt)
    self:updatePrevPos()
    self:itemsUpdate(dt)

    if self.currentHp > self.maxHp then
        self.currentHp = self.maxHp
    end


    flux.to(self, dt, { rotate = 0})

    --subtract invicbility
    if self.invicbility >= 0 then
        self.invicbility = self.invicbility - dt
    end

    if self.currentHp <= 0 then
        self.state = 2
    end

    local hpString = 'HP: '..self.currentHp
    local invString = 'INV: '..self.invicbility
    chart:AddToChart(hpString)
    chart:AddToChart(invString)


    local sx, sy = self:getCenter()
    

    --get if button is clicked


    if self.insideBox == true and self.resumesword == nil then
        self.boxX, self.boxY = self.x, self.y


        --get items to interact with
        local items, len = self.world:queryRect(self.x - 16, self.y - 16, self.x + self.width + 16, self.y + self.height + 16)

        for i = 1, len do
            local item = items[i]
            if item:is(Enemy) and item.isPlaying == true then
                if (self.x > item.x and self.x < item.x + item.width) and (self.y > item.y and self.y < item.y + item.height) then
                    if self.leftmbpressed then
                        if self.equippedWeapon:use(self, item) == true then
                            if self.equippedWeapon.canChargeWeapon == true then
                                self.activeItems[1].chargeProgress = self.activeItems[1].chargeProgress + self.equippedWeapon.chargeAmount
                                self.activeItems[1]:processCharge()
                            end
                        end


                    end
                end
            end
            if (self.x > item.x and self.x < item.x + item.width) and (self.y > item.y and self.y < item.y + item.height) then
                if item:is(Collectible) then
                    if item.state == item.states[1] then
                        if item.isActive == true then
                            item:collect()
                        end
                    end
                end
                if item:is(shopItem) then
                    item.displayAlpha = 3

                    if self.leftmbpressed then
                        item:buy()
                    end
                end
            end
        end
        
    elseif self.insideBox == false and (self.boxX > 0 or self.boxY > 0) then
        --self:releaseSword()
    end

    local sword = self.resumesword
    if sword ~= nil then
        if (self.x > sword.x and self.x < sword.x + sword.width) and (self.y > sword.y and self.y < sword.y + sword.height) and self.insideBox == true then
            if love.mouse.isDown('1') then
                sword:Destroy()
                self.resumesword = nil
                sword = nil
            end
        end
    end

    self.world:move(self, self.x, self.y, filter)

    --reset button clicked
    self.leftmbpressed = false
end

function Player:drawItems()
    if self.equippedWeapon.draw ~= nil then 
    self.equippedWeapon:draw()
    end
end


function Player:draw()
    if self.state == 1 then
        local x,y,w,h = self.world:getRect(self)
        love.graphics.setColor(0,1,0)
       love.graphics.rectangle('line', x, y, w, h)
        love.graphics.setColor(1,1,1)

        --draw image
        love.graphics.draw(self.image, self.x + 4, self.y + 4, self.rotate, 1, 1, 8, 8)

        self:drawItems()
    end

end

return Player

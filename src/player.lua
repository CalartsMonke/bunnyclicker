local entity = require 'src.entity'
local world = require 'world'
local physics = require 'physics'
local Resumesword = require 'src.resumesword'

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'
local entities = require 'roomEntities'

local battleBox = _G.battleBox
local battlemanager = require 'src.battlemanager'


local ripple = require 'lib.ripple'

local chart = require 'src.debugchart'

--TEMP
local Gun = require 'src.items.assaultgun'



local function goToGameOverScreen()
    currentRoom = require 'src.rooms.gameover1':enter()
end

Player = Entity:extend()

function Player:new()
self.states = {1, 2}
self.state = 1
self.type = "Player"


self.x, self.y = battleBox.x + battleBox.width/2, battleBox.y + battleBox.height/2

self.mOffX, self.mOffY = 8, 8
self.width, self.height = 8, 8
self.boxX, self.boxY = self.x, self.y
self.insideBox = false
self.resumesword = nil
self.world = world

self.highlightedEnemy = nil

--IMAGES
self.image = love.graphics.newImage('/img/cursor.png/')

--spawn inital sword
self.boxX = 0
self.boxY = 0


--Shop stats
self.shopNormalKarma = 100
self.shopDarkKarma = 100
self.shopDrugKarma = 100


--ITEMS
self.activeItems = {
    require'src.items.assaultgun'()
}
self.activeItemMax = 1
self.consumableItems = {

}
self.consumableItemsMax = 1
self.passiveItems = {

}
self.passiveItemsMax = 999

self.equippedHealing = require 'src.equip.healing.healing_CowboyFood'()

--damage stats
self.equippedWeapon = require('src.weapons.weapon_dagger')()
self.equippedSubweapon = require('src.weapons.weapon_assualtGun')()
self.baseDamage = 1
self.aggroAdd = 3

self.attackStat = 2
self.defenseStat = 2

--hp
self.maxHpClamp = 30
self.maxHp = 10
self.currentHp = self.maxHp
self.prevHp = self.currentHp
self.invicbilityMax = 1.5
self.invicbility = self.invicbilityMax
self.invicbilityAlphaSwitchTimerMax = 0.1
self.invicbilityAlphaSwitchTimer = self.invicbilityAlphaSwitchTimerMax
self.showingInvAlpha = false
self.invicbilityAlpha = 0.4

--magic/charge
self.weaponChargeCurrent = 0
self.weaponChargeMax = 250


self.subweaponUseTimer = 0
self.subweaponUseTimerMax = 0.6
self.subweaponUseLevel = 0
self.canChargeWeapon = true

self.rotate = 0
self.rotateMax = 0

self.prevX = self.x
self.prevY = self.y

self.coins = 0

self.hasBossKey = true

self.mx = 0
self.my = 0
self.prevMx = 0
self.prevMy = 0

self.mouseresettimer = 0.2

self.leftmbpressed = false
self.body, self.shape = physics.new_rectangle_collider(world, 'dynamic', self.x, self.y, 8, 8)
self.shape:setUserData(self)
end

function Player:TakeDamage(amt)
    local damageToTake = math.ceil(amt - self.defenseStat)
    if damageToTake < 1 then damageToTake = 1 end
    self.currentHp = self.currentHp - damageToTake

    self.invicbility = self.invicbility + self.invicbilityMax
end

local filter = function(item, other)
    if item:is(Bullet) then
        return 'cross'
    end

    if item:is(Player) then
        return nil
    end

    return 'cross'


end

function Player:releaseSword()
    self.resumesword = Resumesword(self.x, self.y, self.boxX, self.boxY)
    self.boxX = 0
    self.boxY = 0
end

function Player:keypressed(key, scancode, isrepeat)
    local items = self.activeItems


    --[[
        if key == 'x' then
            if self.consumableItems[1] ~= nil then
                if self.consumableItems[1].Use ~= nil then
                    self.consumableItems[1]:Use()
                end
            end
        end
    --]]


    if _G.debug == true then
        if key == 'h' then
            self:ChargeHealing(100)
        end

        if key == "j" then
            self.currentHp = self.currentHp - 1
        end
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

function Player:addToWeaponCharge(amt)
    self.weaponChargeCurrent = self.weaponChargeCurrent + amt
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

end

function Player:ChargeHealing(charge)
    self.equippedHealing:AddToCharge(charge)
end

local function ScaleMousePosToScreen()
    local scaledScreenX, scaledScreenY = love.graphics.getWidth() / _G.screenScale, love.graphics.getHeight() / _G.screenScale
    local screenX, screenY = 640, 360
    local mouseOffX = (screenX - scaledScreenX) / 2
    local mouseOffY = (screenY - scaledScreenY) / 2

    return (love.mouse.getX() / _G.screenScale) + mouseOffX, (love.mouse.getY() / _G.screenScale) + mouseOffY
end


function Player:update(dt)

    --RESET VARIABLES
    --self.highlightedEnemy = nil



    self:updateRotate(dt)
    self:updatePrevPos()
    self:itemsUpdate(dt)
    self.equippedHealing:update(dt)

    if self.currentHp > self.maxHp then
        self.currentHp = self.maxHp
    end

    if input:pressed('heal') then
        if self.equippedHealing ~= nil then
            if self.equippedHealing.Use ~= nil then
                self.equippedHealing:Use()
            end
        end
    end




    if self.state == 1 then
        local maxLevelOfChargePossible = 0
        local level = self.subweaponUseLevel


        if self.weaponChargeCurrent >= self.equippedSubweapon.level1ChargeCost then
            maxLevelOfChargePossible = 1
        end
        if self.weaponChargeCurrent >= self.equippedSubweapon.level2ChargeCost then
            maxLevelOfChargePossible = 2
        end
        if self.weaponChargeCurrent >= self.equippedSubweapon.level3ChargeCost then
            maxLevelOfChargePossible = 3
        end
        local funlittlevalue = self.equippedSubweapon["level"..level.."ChargeCost"]


        if input:down('attack') then
            if self.activeItems[1] ~= nil then
                if level < maxLevelOfChargePossible and self.canChargeWeapon then
                    if self.subweaponUseTimer <= self.subweaponUseTimerMax and self.subweaponUseLevel < 3 then
                        self.subweaponUseTimer = self.subweaponUseTimer + dt    
                    end
                end

                if self.subweaponUseTimer >= self.subweaponUseTimerMax then
                    if self.subweaponUseLevel < 3 then
                        
                        self.subweaponUseTimer = 0
                        self.subweaponUseLevel = self.subweaponUseLevel + 1
                        local sound = love.audio.newSource('/aud/hitmark.mp3/', 'static')
                        love.audio.play(sound)
                    end
                end

                if self.subweaponUseLevel == 3 then
                    self.subweaponUseTimer = self.subweaponUseTimerMax
                end
            end
        end

        if input:pressed('subweapon') then
            self.subweaponUseLevel = 0
            self.subweaponUseTimer = 0
            self.canChargeWeapon = false
        end

        if self.currentHp < self.prevHp then
            local sound = require'assets'.sounds.hurt1UT
            sound.volume = 0.7
            sound:play()
        end

        self.prevHp = self.currentHp
    end

    local speed = 200
    local mouseSpeed = 1
    if love.keyboard.isDown('lshift') then
        speed = 100
        mouseSpeed = 0.5
    end

    --EXTRA MOVEMENT
    if input:down('left') then
        self.x = self.x - speed * dt
    end
    if input:down('right') then
        self.x = self.x + speed * dt
    end
    if input:down('up') then
        self.y = self.y - speed * dt
    end
    if input:down('down') then
        self.y = self.y + speed * dt
    end



    if love.window.hasFocus() then
        self.x = self.x + (self.mx - self.prevMx) * mouseSpeed
        self.y = self.y + (self.my - self.prevMy) * mouseSpeed

        self.prevMx = self.mx
        self.prevMy = self.my

        if (math.floor(self.mx) == math.floor(self.prevMx)) then
            self.mouseresettimer = self.mouseresettimer - dt

        end

        if self.mouseresettimer <= 0 then
            love.mouse.setPosition( love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5 )
            self.mx, self.my = ScaleMousePosToScreen()
            self.prevMx, self.prevMy = ScaleMousePosToScreen()
            self.mouseresettimer = 0.2
        end
    end
    flux.to(self, dt, { rotate = 0})

    --subtract invicbility
    if self.invicbility >= 0 then
        self.invicbility = self.invicbility - dt
        self.invicbilityAlphaSwitchTimer = self.invicbilityAlphaSwitchTimer - dt
    else
        self.showingInvAlpha = false
    end

    if self.invicbilityAlphaSwitchTimer <= 0 then
        self.invicbilityAlphaSwitchTimer = self.invicbilityAlphaSwitchTimerMax
        if self.showingInvAlpha == false then
            self.showingInvAlpha = true
        elseif self.showingInvAlpha == true then
            self.showingInvAlpha = false
        end

    end

    if self.currentHp <= 0 then
        self.state = 2 --Die but not really for now
        goToGameOverScreen()
    end

    local sx, sy = self:getCenter()
    

    --get if button is clicked



        --MOVE
        self.body:setInertia(0)
        self.shape:setFriction(0)



    local check1, check2, check3, check4 = true, true, true, true
        --clamp
        if self.x < battleBox.x then
            self.x = battleBox.x
            check1 = false
        end
        if self.x + self.width > battleBox.x + battleBox.width then
            self.x = (battleBox.x + battleBox.width) - self.width
            check2 = false
        end
        if self.y < battleBox.y then
            self.y = battleBox.y
            check3 = false
        end
        if self.y + self.height > battleBox.y + battleBox.height then
            self.y = (battleBox.y + battleBox.height) - self.height
            check4 = false
        end

        self.body:setX(self.x)
        self.body:setY(self.y)




    --INTERACT WITH GAINED COLLISIONS
    if self.highlightedEnemy ~= nil then
        if self.highlightedEnemy:is(Enemy) then
                battlemanager:ChangeHighlightedEnemy(self.highlightedEnemy)
                if input:pressed('attack') then
                    print("ATTACK PRESSED")
                    --Damage targeted enemy using current equippedWeapon
                    if self.equippedWeapon:use(self, self.highlightedEnemy) == true then
                        if self.equippedWeapon.canChargeWeapon == true then
                            self:addToWeaponCharge(self.equippedWeapon.chargeAmount)
                        end
                    end
                end
                if input:released('attack') then
                    print("ATTACK RELEASED")
                    --Damage targeted enemy using current equippedWeapon
                    if self.subweaponUseLevel > 0 then
                        if self.equippedSubweapon:use(self, self.highlightedEnemy, self.subweaponUseLevel) == true then

                        end
                        self:addToWeaponCharge(self.equippedSubweapon["level"..self.subweaponUseLevel.."ChargeCost"] * -1)
                    end
                end
        end
    end

    if not input:down('attack') then
        self.canChargeWeapon = true
        self.subweaponUseLevel = 0
        self.subweaponUseTimer = 0
    end

end

function Player:drawItems()
    if self.equippedWeapon.draw ~= nil then 
    self.equippedWeapon:draw()
    end
end


function Player:draw()
    --physics.draw_body(self.body)

    if self.state == 1 then
        --local x,y,w,h = self.world:getRect(self)
        love.graphics.setColor(0,1,0)
       --love.graphics.rectangle('line', x, y, w, h)
        love.graphics.setColor(1,1,1)

        --draw image


        if self.subweaponUseTimer > self.subweaponUseTimerMax * 0.5 or self.subweaponUseLevel > 0 then
            --Draw attack ready

            local attackBarHeight = 8
            local attackBarLength = 4
            local attackBarX = self.x - 8
            local attackBarY = self.y
            local barheight = (self.subweaponUseTimer / self.subweaponUseTimerMax ) * attackBarHeight

            --love.graphics.rectangle('line', attackBarX, attackBarY, attackBarLength, -attackBarHeight)

            if self.subweaponUseLevel == 1 then
                love.graphics.setColor(1, 1, 0)
            end
            if self.subweaponUseLevel == 2 or self.subweaponUseLevel == 3 then
                love.graphics.setColor(1, 0, 0)
            end

            love.graphics.rectangle('fill', attackBarX + 2, attackBarY + 2, 2, -barheight - 4)

            love.graphics.setColor(1, 1, 1)

        end

        local invAlpha = 1
        if self.showingInvAlpha == true then
            invAlpha = self.invicbilityAlpha
        end
        love.graphics.setColor(1,1,1, invAlpha)
        love.graphics.draw(self.image, self.x + 4, self.y + 4, self.rotate, 1, 1, 8, 8)
        love.graphics.setColor(1,1,1,1)

        self:drawItems()


        --DEBUG
        self.equippedHealing:draw()
    end

    if self.state == 2 then

        love.graphics.draw(self.image, self.x + 4, self.y + 4, 0, 1, 1, 8, 8)
    end

end


function Player.on_collision_start(self, other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()


    print("IS TOUCHING SOMETHING")
    local item = other
            if item.is then
                if item:is(Enemy) then
                    if item.isPlaying and item.state ~= item.STATES.DEAD then
                        self.highlightedEnemy = item
                    end
                end
            end

            if item.is then
                if item:is(Collectible) then
                    if item.state == item.states[1] then
                        if item.isActive == true then
                            item:collect()
                        end
                    end
                end
            end

end



function Player.on_collision_exit(self, other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

    if other == self.highlightedEnemy or other:is(Enemy) then
        self.highlightedEnemy = nil
    end

end

function Player:collision_presolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end

function Player:collision_postsolve(other, normal_x, normal_y, x1, y1, x2, y2)
    -- handler logic here, 
    local body_a = self:get_body() -- love.physics.Body
    local body_b = other:get_body() -- love.physics.Body
    local ax, ay = body_a:getPosition()
    local bx, by = body_b:getPosition()

end

return Player

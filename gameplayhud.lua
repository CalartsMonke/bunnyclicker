local player = require ('gameStats').player
local game = require ('gameStats')
local dungeon = _G.dungeon
local assets = require 'assets'
local coinTextOffX = 40
local coinTextOffY = 10
local hpOffX = 20
local hpOffY = 40

local extraAngleIncrease = 1

local gameplayHud = {

    heartIconPosX = 20,
    heartIconPosY = 300,
    weaponIconPosX = 20,
    weaponIconPosY = 60,
    coinIconPosX = 20,
    coinIconPosY = 20,
    keyIconPosX = 5,
    keyIconPosY = 310,

    activeItemsPosX = game.gameWidth/2 + 96,
    activeItemsPosY = game.gameHeight - 64,
    activeItemsPosSep = 80,

    consumableItemsPosX = game.gameWidth - 96,
    consumableItemsPosY = game.gameHeight - 64,

    coinIconImage = require 'assets'.images.hudCoin,
    keyIconImage = require 'assets'.images.keyIcon,
    keyIconImageDotted = require 'assets'.images.keyIconDotted,

    showExtraInfo = false,

    MODES = {
        NORMAL = 1,
        SHOP = 2,
    },
}
    gameplayHud.mode = gameplayHud.MODES.NORMAL



function gameplayHud:update(dt)
    extraAngleIncrease = extraAngleIncrease + dt * 50
end

function gameplayHud:drawNormalHud()
    if love.keyboard.isDown('lshift') then
        self.showExtraInfo = true
    else
        self.showExtraInfo = false
    end

    --draw empty health
    love.graphics.setColor(0, 0, 0, 1)
    for i = 1, player.maxHp do
        love.graphics.circle('fill', self.heartIconPosX + ((i - 1) * hpOffX), self.heartIconPosY, 5)
    end

    love.graphics.setColor(1, 1, 1, 1)
    for i = 1, player.currentHp do
        love.graphics.circle('fill', self.heartIconPosX + ((i - 1) * hpOffX), self.heartIconPosY, 5)
    end
    love.graphics.setColor(1, 1, 1, 1)


    --Draw coins and number of coins
    love.graphics.draw(self.coinIconImage, self.coinIconPosX, self.coinIconPosY)
    love.graphics.setFont(require'assets'.fonts.dd16)
    love.graphics.print(player.coins, math.floor(self.coinIconPosX + coinTextOffX), math.floor(self.coinIconPosY + coinTextOffY))
    love.graphics.setFont(assets.fonts.ns13)


    --Draw boss key
    if player.hasBossKey == true then
        love.graphics.draw(self.keyIconImage, self.keyIconPosX, self.keyIconPosY, 0, 2, 2)
    else
        love.graphics.draw(self.keyIconImageDotted, self.keyIconPosX, self.keyIconPosY, 0, 2, 2)
    end

    --Draw player weapon and text
    local playerweapon = player.equippedWeapon
    if playerweapon ~= nil then
        love.graphics.draw(playerweapon.image, self.weaponIconPosX, self.weaponIconPosY)

        if self.showExtraInfo then
            love.graphics.setFont(assets.fonts.dd16)
            love.graphics.print(playerweapon.name, self.weaponIconPosX + 100, self.weaponIconPosY)
            love.graphics.setFont(assets.fonts.ns13)
        end
    end


    --DRAWING ITEMS
        local item = player.activeItems[1]
        
        if item ~= nil then
            love.graphics.draw(item.image, self.activeItemsPosX, self.activeItemsPosY)
            local number = math.ceil(item.rechargeTimeMax - item.rechargeTime)
            if number > 0 then
                love.graphics.setFont(assets.fonts.dd16)
                love.graphics.print(number, math.floor(380), math.floor(320))
                love.graphics.setFont(assets.fonts.ns13)
            end

            local angleIncrease = 360/item.currentCharges

            for i=1, item.currentCharges do
                

                local distance = 16
                local angle = (0 + angleIncrease * i-1) + extraAngleIncrease
                local tp = self.trianglePoints
                local dx = self.activeItemsPosX + item.image:getWidth()/2 + math.cos(math.rad(90 + angle)) * distance;
                local dy = self.activeItemsPosY + item.image:getHeight()/2 + math.sin(math.rad(90 + angle)) * distance;

                love.graphics.draw(assets.images.star, dx, dy)
            end





        end
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.draw(assets.images.hud.itemFrame, self.activeItemsPosX, self.activeItemsPosY)
        love.graphics.draw(assets.images.hud.activePaper, self.activeItemsPosX - 64, self.activeItemsPosY)
        love.graphics.setColor(1, 1, 1, 1)
    --DRAWING CONSUMABLES
    if player.consumableItems[1] ~= nil then
        local item = player.consumableItems[1]
        love.graphics.draw(item.image, self.consumableItemsPosX, self.consumableItemsPosY)
    end
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.draw(assets.images.hud.itemFrame, self.consumableItemsPosX, self.consumableItemsPosY)
    love.graphics.draw(assets.images.hud.consumablePaper, self.consumableItemsPosX - 64, self.consumableItemsPosY)
    love.graphics.setColor(1, 1, 1, 1)
end

function gameplayHud:drawShopHud()

end



function gameplayHud:draw()



    if self.mode == self.MODES.NORMAL then
        self:drawNormalHud()
    end

    if self.mode == self.MODES.SHOP then
        self:drawShopHud()
    end




    
end

return gameplayHud
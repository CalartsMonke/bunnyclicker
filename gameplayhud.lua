local player = require ('gameStats').player
local game = require ('gameStats')
local assets = require 'assets'
local coinTextOffX = 40
local coinTextOffY = 10
local hpOffX = 20
local hpOffY = 40


local gameplayHud = {
    heartIconPosX = 20,
    heartIconPosY = 300,
    weaponIconPosX = 20,
    weaponIconPosY = 60,
    coinIconPosX = 20,
    coinIconPosY = 20,
    keyIconPosX = 5,
    keyIconPosY = 310,

    activeItemsPosX = game.gameWidth - 300,
    activeItemsPosY = game.gameHeight - 75,
    activeItemsPosSep = 80,

    coinIconImage = require 'assets'.images.hudCoin,
    keyIconImage = require 'assets'.images.keyIcon,
    keyIconImageDotted = require 'assets'.images.keyIconDotted,
}



function gameplayHud:update()

end

function gameplayHud:draw()

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
    end


    --DRAWING ITEMS
    for i = 1, #player.activeItems, 1 do
        local item = player.activeItems[i]
        
        love.graphics.draw(item.image, self.activeItemsPosX + (i - 1) * self.activeItemsPosSep, self.activeItemsPosY)
        local number = math.ceil(item.rechargeTimeMax - item.rechargeTime)
        if number > 0 then
            love.graphics.setFont(assets.fonts.dd16)
            love.graphics.print(number, math.floor(350 + (i - 1) * 80), math.floor(270))
            love.graphics.setFont(assets.fonts.ns13)
        end
    end
end

return gameplayHud
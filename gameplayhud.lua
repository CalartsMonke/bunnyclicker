local player = require ('gameStats').player
local game = require ('gameStats')
local coinTextOffX = 40
local coinTextOffY = 10
local hpOffX = 20
local hpOffY = 40


local gameplayHud = {
    heartIconPosX = 20,
    heartIconPosY = 300,
    coinIconPosX = 20,
    coinIconPosY = 20,
    keyIconPosX = 5,
    keyIconPosY = 310,

    activeItemsPosX = game.gameWidth - 300,
    activeItemsPosY = game.gameHeight - 75,
    activeItemsPosSep = 32,

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

    love.graphics.draw(self.coinIconImage, self.coinIconPosX, self.coinIconPosY)
    love.graphics.print(player.coins, self.coinIconPosX + coinTextOffX, self.coinIconPosY + coinTextOffY)

    if player.hasBossKey == true then
        love.graphics.draw(self.keyIconImage, self.keyIconPosX, self.keyIconPosY, 0, 2, 2)
    else
        love.graphics.draw(self.keyIconImageDotted, self.keyIconPosX, self.keyIconPosY, 0, 2, 2)
    end


    --DRAWING ITEMS
    for i = 1, #player.activeItems, 1 do
        local item = player.activeItems[i]
        
        love.graphics.draw(item.image, self.activeItemsPosX + (i - 1) * self.activeItemsPosSep, self.activeItemsPosY)
        local number = math.ceil(item.reloadTimeMax - item.reloadTime)
        if number > 0 then
            love.graphics.print(number, 200, 250)
        end
    end
end

return gameplayHud
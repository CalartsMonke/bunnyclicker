local player = require ('gameStats').player
local coinTextOffX = 40
local coinTextOffY = 10
local hpOffX = 20
local hpOffY = 40


local gameplayHud = {
    heartIconPosX = 20,
    heartIconPosY = 300,
    coinIconPosX = 20,
    coinIconPosY = 20,

    coinIconImage = require 'assets'.images.hudCoin
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
end

return gameplayHud
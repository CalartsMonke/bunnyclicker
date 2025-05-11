local player = require ('gameStats').player
local coinTextOffX = 40
local coinTextOffY = 10


local gameplayHud = {
    coinIconPosX = 20,
    coinIconPosY = 20,

    coinIconImage = require 'assets'.images.hudCoin
}



function gameplayHud:update()

end

function gameplayHud:draw()
    
    love.graphics.draw(self.coinIconImage, self.coinIconPosX, self.coinIconPosY)
    love.graphics.print(player.coins, self.coinIconPosX + coinTextOffX, self.coinIconPosY + coinTextOffY)
end

return gameplayHud
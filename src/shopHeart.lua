local shopItem = require('src.shopItem')
local player = require('gameStats').player
local entities = require ('roomEntities')

shopHeart = shopItem:extend()


function shopHeart:new(x, y)
    self.super.new(self)
    self.x = x
    self.y = y
    self.name = "Recovery Heart"
    self.desc = "Restores 1 HP"
    self.price = 10
    self.image = require('assets').images.heartDrop
    self:addToGame(self.image, self.x, self.y)
    self.isPlaying = false
    self.isActive = false
    self.displayAlpha = 0
end

function shopHeart:buy()
    if self.isActive == true then
        if player.currentHp < player.maxHp then
            player.currentHp = player.currentHp + 1
            player.coins = player.coins - self.price
            self:Destroy()
        end
    end
end

function shopHeart:update(dt)
    self:decreaseAlpha(dt)
    print(self.displayAlpha)
end

function shopHeart:draw()
    if self.isActive == true then
        love.graphics.draw(self.image, self.x, self.y)
        love.graphics.print(self.price, self.x, self.y + self.height + 4)

        local x,y,w,h = self.world:getRect(self)
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle('line', x, y, w, h)
        love.graphics.setColor(1,1,1)

        self:displayInfo()
    end


end

return shopHeart
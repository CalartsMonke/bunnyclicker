
local Entity = require('src.entity')
shopItem = Entity:extend()

function shopItem:new()
    self.image = nil
    self.price = 1

    self.displayAlpha = 0
end


function shopItem:buy()

end

function shopItem:displayInfo()
    local string = self.name.."\n"..self.desc
    love.graphics.setColor(1, 1, 1, self.displayAlpha)

    love.graphics.print(string, self.x, self.y + self.height + 20)
    love.graphics.setColor(1, 1, 1, 1)
end

function shopItem:decreaseAlpha(dt)
    if self.displayAlpha > 0 then
    self.displayAlpha = self.displayAlpha - dt
    print(self.displayAlpha)
    end
end

function shopItem:update(dt)
    self:decreaseAlpha(dt)
end

function shopItem:draw()

end

return shopItem
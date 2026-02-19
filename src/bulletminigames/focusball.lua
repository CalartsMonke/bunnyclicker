

FocusBall = require 'src.entity':extend()

function FocusBall:new(x, y) 
    self.x = x or 200
    self.y = y or 200
    self.image = nil

    self.chargeToGIve = 2
    
end

function FocusBall:update(dt)

end

function FocusBall:draw()
    love.graphics.circle('fill', self.x, self.y, 30)
end

return FocusBall
local partTable = require 'particletable'

local Particlestation = Object:extend()

function Particlestation:new(x, y, partSystem, emitNum)

    self.lifetime = 10
    self.x = x
    self.y = y
    self.partSystem = partSystem:clone()
    self.emitNum = emitNum

    self:emit(emitNum)
end

function Particlestation:decreaseLife(dt)
    if self.lifetime >= 0 then
        self.lifetime = self.lifetime - dt
    else
        for i = 1, #partTable do
            local tab = partTable
            if tab[i] == self then
                print('FOUND THE PART SYSTEM')
                table.remove(tab, i)
            end
        end
    end
end

function Particlestation:update(dt)
    self.partSystem:update(dt)
    self:decreaseLife(dt)
end

function Particlestation:emit(emitNum)
    self.partSystem:emit(emitNum)
end

function Particlestation:draw(dt)
    love.graphics.draw(self.partSystem, self.x, self.y)
end

return Particlestation


local entity = require 'src.entity'
local world = require 'world'

Resumesword = entity:extend()


function Resumesword:new(x, y)
 self.x, self.y = x, y
 self.image = love.graphics.newImage('/img/idlesword.png/')

 self.width, self.height = self.image:getWidth(), self.image:getHeight()

 self.world = world

 world:add(self, self.x, self.y, self.width, self.height)
end

function Resumesword:update()

end

function Resumesword:draw()
    love.graphics.draw(self.image, self.x, self.y)
end



return Resumesword
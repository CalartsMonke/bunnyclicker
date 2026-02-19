Ladder = Object:extend()

local world = require 'world'
local physics = require 'physics'

function Ladder:new(x,y, w,h)
    self.body, self.shape = physics.new_rectangle_collider(world, 'static', x, y, w, h)
    self.shape:setUserData(self)
    self.shape:setSensor(true)
end

function Ladder.get_shape(item)
    return item.shape
end


function Ladder.get_body(item)
    return item.body
end

return Ladder
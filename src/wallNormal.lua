local world = require 'world'
local physics = require 'physics'

WallNormal = Object:extend()

function WallNormal:new(x, y, w, h)
    self.body, self.shape = physics.new_rectangle_collider(world, 'static', x, y, w, h)
    self.shape:setUserData(self)
end

function WallNormal.get_shape(item)
    return item.shape
end


function WallNormal.get_body(item)
    return item.body
end

return WallNormal
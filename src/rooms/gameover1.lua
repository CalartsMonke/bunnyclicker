local entities = require 'roomEntities'
local player = _G.player





local room = Object:extend()
room.name = "battletestroom_01"
room.id = 2
room.roomObjects = {}
local roomObjects = room.roomObjects

local function spawnBunnyBody()
    local bunnyBody = {}
    bunnyBody.x = player.x
    bunnyBody.y = player.y
    bunnyBody.image = require 'assets'.images.deadBunner
    local py = player.y
    bunnyBody.vsp = 0

        bunnyBody.vsp = player.y * -1 - 200



    bunnyBody.type = "DeadBunner"

    table.insert(roomObjects, bunnyBody)
    

    function bunnyBody:update(dt)
        flux.to(self, 1, {x = 330})

        self.vsp = self.vsp + 600 * dt

        self.y = self.y + self.vsp * dt


    end

    function bunnyBody:draw()

        love.graphics.draw(self.image, self.x, self.y)
    end


    return bunnyBody
end

function room:enter()

    return self
end

function room:exit()

end



function room:update(dt)

    if input:pressed('subweapon') then 
        spawnBunnyBody()
    end

    for i=#roomObjects, 1, -1 do
        local item = roomObjects[i]
        item:update(dt)
    end

    player:update(dt)
end

function room:draw()



    player:draw()

    for i=#roomObjects, 1, -1 do
        local item = roomObjects[i]
        item:draw()
    end
    love.graphics.print("GAME OVER", 200, 200)
end

return room

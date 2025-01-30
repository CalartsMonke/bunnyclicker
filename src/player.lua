local object = require 'lib.classic'
local world = require 'world'
local Resumesword = require 'src.resumesword'

Player = object:extend();

function Player:new()
self.x, self.y = 1, 1
self.width, self.height = 16, 16
self.boxX, self.boxY = self.x, self.y
self.insideBox = false
self.resumesword = nil
self.world = world

--spawn inital sword
self.resumesword = Resumesword(love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 50)
self.boxX = 0
self.boxY = 0


--damage stats
self.baseDamage = 1



self.leftmbpressed = false
print("THE PLAYER IS MADE")
world:add(self, self.x, self.y, self.width, self.height)
end

function Player:update(dt)


    --get if button is clicked


    if self.insideBox == true and self.resumesword == nil then
        self.boxX, self.boxY = self.x, self.y


        --get items to interact with
        local items, len = self.world:queryRect(self.x - 16, self.y - 16, self.x + self.width + 16, self.y + self.height + 16)

        for i = 1, len do
            local item = items[i]
            if item:is(Enemy) then
                if (self.x > item.x and self.x < item.x + item.width) and (self.y > item.y and self.y < item.y + item.height) then
                    if self.leftmbpressed then
                        item:TakeDamage(self.baseDamage)

                    end
                end
            end
        end

    elseif self.insideBox == false and (self.boxX > 0 or self.boxY > 0) then

        self.resumesword = Resumesword(self.boxX, self.boxY)
        self.boxX = 0
        self.boxY = 0
    end

    local sword = self.resumesword
    if sword ~= nil then
        if (self.x > sword.x and self.x < sword.x + sword.width) and (self.y > sword.y and self.y < sword.y + sword.height) and self.insideBox == true then
            if love.mouse.isDown('1') then
                sword:Destroy()
                self.resumesword = nil
                sword = nil
            end
        end
    end



    --reset button clicked
    self.leftmbpressed = false
end

function Player:draw()

end

return Player

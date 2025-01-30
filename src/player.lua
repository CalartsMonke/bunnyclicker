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


print("THE PLAYER IS MADE")
world:add(self, self.x, self.y, self.width, self.height)
end

function Player:update(dt)

    if self.insideBox == true and self.resumesword == nil then
        self.boxX, self.boxY = self.x, self.y

    elseif self.insideBox == false and (self.boxX > 0 or self.boxY > 0) then

        self.resumesword = Resumesword(self.boxX, self.boxY)
        self.boxX = 0
        self.boxY = 0
    end

    local sword = self.resumesword
    if sword ~= nil then
        if (self.x > sword.x and self.x < sword.x + sword.width) and (self.y > sword.y and self.y < sword.y + sword.height) then
            if love.mouse.isDown('1') then
                sword:Destroy()
                self.resumesword = nil
                sword = nil
            end
        end
    end
end

function Player:draw()

end

return Player

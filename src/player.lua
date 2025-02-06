local entity = require 'src.entity'
local world = require 'world'
local Resumesword = require 'src.resumesword'

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local sparklePart = require 'src.part.sparklepart'

local chart = require 'src.debugchart'

Player = Entity:extend()

function Player:new()
self.states = {1, 2}
self.state = 1


self.x, self.y = 1, 1
self.width, self.height = 16, 16
self.boxX, self.boxY = self.x, self.y
self.insideBox = false
self.resumesword = nil
self.world = world

--IMAGES
self.image = love.graphics.newImage('/img/cursor.png/')

--spawn inital sword
self.resumesword = Resumesword(love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 50, love.graphics.getHeight()/2, love.graphics.getWidth()/2)
self.resumesword.state = 2
self.boxX = 0
self.boxY = 0

--damage stats
self.baseDamage = 1

--hp
self.maxHp = 3
self.currentHp = self.maxHp
self.invicbilityMax = 1.5
self.invicbility = self.invicbilityMax



self.leftmbpressed = false
print("THE PLAYER IS MADE")
world:add(self, self.x, self.y, self.width, self.height)
end

function Player:TakeDamage(amt)
    self.currentHp = self.currentHp - amt

    self.invicbility = self.invicbility + self.invicbilityMax
end

local filter = function(item, other)
    if item:is(Bullet) then
        print("RETURNING NIL")
        return 'cross'
    end

    if item:is(Player) then
        return nil
    end
end

function Player:update(dt)

    --subtract invicbility
    if self.invicbility >= 0 then
        self.invicbility = self.invicbility - dt
    end

    if self.currentHp <= 0 then
        self.state = 2
    end

    local hpString = 'HP: '..self.currentHp
    local invString = 'INV: '..self.invicbility
    chart:AddToChart(hpString)
    chart:AddToChart(invString)


    local sx, sy = self:getCenter()
    

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
                        local spark = sparklePart()
                        table.insert(partTable ,partStation(self.x, self.y, spark.part, 6))

                    end
                end
            end
        end

    elseif self.insideBox == false and (self.boxX > 0 or self.boxY > 0) then

        self.resumesword = Resumesword(self.x, self.y, self.boxX, self.boxY)
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

    self.world:move(self, self.x, self.y, filter)




    --reset button clicked
    self.leftmbpressed = false
end

function Player:draw()
    if self.state == 1 then
        local x,y,w,h = self.world:getRect(self)
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle('fill', x, y, w, h)
        love.graphics.setColor(1,1,1)

        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 0, -0)
    end

end

return Player

local world = require 'world'
local player = require 'gameStats'.player
local hud = require 'gameplayhud'
local entities = require 'roomEntities'
local coinDrop = require 'src.collectible.coinDrop'
local gameStats= require 'gameStats'

bagDrop = Collectible:extend()

function bagDrop:new(x, y)
    self.parentRoom = nil
    self.image = require 'assets'.images.coinBag
    self.isActive = false

    self:addToGame(self.image, x, y)

    self.travelTime = 0.4
    self.currentTime = 0
    self.coinSpawnDelay = 0.4
    self.spawnStartDelay = 0.3
    self.spawnEndDelay = 1
    self.spawnTime = 0
    self.coins = {
        coinDrop(999, 999),
        coinDrop(999, 999),
        coinDrop(999, 999),
        coinDrop(999, 999),
        coinDrop(999, 999)
    }



    self.states = {1, 2, 3, 4, 5}
    self.state = self.states[1]


end

function bagDrop:collect()
    if self.isActive == nil or self.isActive == true then
    self.state = self.states[2]
    print("THIS ITEM WAS COLLECTED")
    end
end


function bagDrop:update(dt)
if self.isActive == true then
    require('world'):update(self, self.x, self.y)
    self.spawnTime = self.spawnTime + dt

    if self.state == self.states[2] then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.travelTime then
            self.state = self.states[3]
        end
        flux.to(self, self.travelTime, {x = gameStats.gameWidth/2})
        flux.to(self, self.travelTime, {y = gameStats.gameHeight/2})
    end

    if self.state == self.states[3] then
        if self.spawnTime >= self.spawnStartDelay then
            self.state = self.states[4]
            self.spawnTime = 0
        end
    end

    if self.state == self.states[4] then
        if self.spawnTime >= self.coinSpawnDelay and #self.coins > 0 then
            local coin = table.remove(self.coins, 1)
            coin.x = self.x
            coin.y = self.y
            coin:collect()
            self.spawnTime = 0
        end
        if self.spawnTime >= self.spawnEndDelay and #self.coins <= 0 then
            self.parentRoom:EndLevel()
        end
    end


end
end

function bagDrop:draw()
    if self.isActive == true then
    love.graphics.draw(self.image, self.x, self.y)
    local x,y,w,h = self.world:getRect(self)
    love.graphics.setColor(0,1,0)
   love.graphics.rectangle('line', x, y, w, h)
    love.graphics.setColor(1,1,1)
    end
end

return bagDrop
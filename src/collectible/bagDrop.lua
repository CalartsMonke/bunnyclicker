local world = require 'world'
local player = require 'gameStats'.player
local hud = require 'gameplayhud'
local entities = require 'roomEntities'
local coinDrop = require 'src.collectible.coinDrop'
local gameStats= require 'gameStats'

BagDrop = Collectible:extend()

function BagDrop:new(x, y, amountToSpawn)
    self.super.new(self)
    self.parentRoom = nil
    self.image = require 'assets'.images.coinBag
    self.isActive = false

    self:addToGame(self.image, x, y)

    self.travelTime = 0.4
    self.currentTime = 0
    self.coinSpawnDelay = 0.7
    self.spawnStartDelay = 0.3
    self.spawnEndDelay = 1
    self.spawnTime = 0
    self.coinsToSpawn = amountToSpawn or 3
    self.coinsSpawned = 0
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

function BagDrop:collect()
    if self.isActive == true then
    self.state = self.states[2]
    print("THIS ITEM WAS COLLECTED AND IS A COIN BAG")
    end
end


function BagDrop:update(dt)

if self.isActive == true then

    if self.state == self.states[1] then
        self:MoveWithSpeed(dt)
        self:updateBounce(dt)
    end

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
        if self.spawnTime >= self.coinSpawnDelay and self.coinsSpawned < self.coinsToSpawn then
            local coin = coinDrop(self.x, self.y)
            coin.isActive = true
            coin.x = self.x
            coin.y = self.y
            coin:collect()
            self.spawnTime = 0
            self.coinsSpawned = self.coinsSpawned + 1
        end
        if self.spawnTime >= self.spawnEndDelay and self.coinsToSpawn <= self.coinsSpawned then
            self.parentRoom:EndLevel()
        end
    end


end
end

return BagDrop
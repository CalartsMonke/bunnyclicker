local world = require 'world'
local collectible = require ('src.collectible.collectible')
local player = require 'gameStats'.player
local hud = require 'gameplayhud'
local entities = require 'roomEntities'

CoinDrop = collectible:extend()

function CoinDrop:new(x, y)
    self.super.new(self)

    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.travelTime = 0.4
    self.currentTime = 0
    self.value = 1
    self.isActive = true

    self.image = require 'assets'.images.coinSpin
    self.animFrames = {}
    self.frameWidth = 16
    self.frameHeight = 16
    self.frameToDraw = 1
    self.currentFrame = 1

    for i=0,5 do
        table.insert(self.animFrames, love.graphics.newQuad(i * self.frameWidth, 0, self.frameWidth, self.frameHeight, self.image:getWidth(), self.image:getHeight()))
    end

    self.states = {1, 2}
    self.state = self.states[1]

    table.insert(entities, self)
    world:add(self, self.x, self.y, self.frameWidth, self.frameHeight)
end

function CoinDrop:collect()
    if self.isActive == nil or self.isActive == true then
    self.state = self.states[2]
    print("THIS ITEM WAS COLLECTED")
    end
end

function CoinDrop:update(dt)
    if self.state == self.states[2] then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.travelTime * 1.5 then
            player.coins = player.coins + self.value
            self:Destroy()
        end
        flux.to(self, self.travelTime, {x = hud.coinIconPosX})
        flux.to(self, self.travelTime, {y = hud.coinIconPosY})
    end

    self.currentFrame = (self.currentFrame + 12 * dt)
    if self.currentFrame > #self.animFrames then
        self.currentFrame = 1
    end

    self.frameToDraw = math.floor(self.currentFrame)

end

function CoinDrop:draw()
    love.graphics.draw(self.image, self.animFrames[self.frameToDraw], self.x, self.y)
end

return CoinDrop
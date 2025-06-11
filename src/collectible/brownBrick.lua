local world = require 'world'
local collectible = require ('src.collectible.collectible')
local player = require 'gameStats'.player
local hud = require 'gameplayhud'
local entities = require 'roomEntities'

BrownBrickDrop = collectible:extend()

function BrownBrickDrop:new(x, y)

    self.x = x
    self.y = y
    self.width = 32
    self.height = 32
    self.travelTime = 0.05
    self.currentTime = 0
    self.isActive = true

    self.image = require 'assets'.images.brownBrick
    self.animFrames = {}
    self.frameWidth = 32
    self.frameHeight = 32
    self.frameToDraw = 1
    self.currentFrame = 1


    self.states = {1, 2}
    self.state = self.states[1]

    table.insert(entities, self)
    world:add(self, self.x, self.y, self.frameWidth, self.frameHeight)
end

function BrownBrickDrop:collect()
    if self.isActive == nil or self.isActive == true then
    self.state = self.states[2]
    print("THIS ITEM WAS COLLECTED")
    end
end

function BrownBrickDrop:update(dt)
    if self.state == self.states[2] then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.travelTime * 1.5 then
            _G.player:addItemToConsumables(require 'src.items.brownBrick'())
            self:Destroy()
        end
        flux.to(self, self.travelTime, {x = hud.coinIconPosX})
        flux.to(self, self.travelTime, {y = hud.coinIconPosY})
    end

end

function BrownBrickDrop:draw()
    love.graphics.draw(self.image, self.x, self.y, 0,  0.5, 0.5)
end

return BrownBrickDrop
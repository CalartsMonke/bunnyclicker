

local ProgressBar = {}
local PB = ProgressBar

function ProgressBar.new(x, y, maxValue, incrementValue)

    local PB = {}


    function PB:update(dt)
        if self.currentValue <= self.maxValue then
            self.currentValue = self.currentValue + self.incrementValue * dt
        end
        self.frameToDraw = math.ceil(self:getPercent()/100 * #self.animFrames)

        if self.frameToDraw > #self.animFrames then
            self.frameToDraw = #self.animFrames
        end
    
    end
    
    function PB:getPercent()
    
        return math.floor((self.currentValue/self.maxValue) * 100)
    end
    
    function PB:draw()
        love.graphics.draw(self.image, self.animFrames[math.floor(self.frameToDraw)], self.x, self.y)
    end

    PB.maxValue = maxValue or 100
    PB.currentValue = 0
    PB.incrementValue = incrementValue or 1
    PB.image = require 'assets'.images.hud.progressBar

    PB.x = x
    PB.y = y

    PB.animFrames = {}
    PB.frameWidth = 32
    PB.frameHeight = 16
    PB.frameToDraw = 1
    PB.currentFrame = 1

    for i=0,12 do
        table.insert(PB.animFrames, love.graphics.newQuad(i * PB.frameWidth, 0, PB.frameWidth, PB.frameHeight, PB.image:getWidth(), PB.image:getHeight()))
    end

    return PB
end




return ProgressBar
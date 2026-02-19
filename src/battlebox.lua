local battlebox = {
    x = 10,
    y = 10,
    width = 620,
    height = 300,
    hspeed = 75,
    vspeed = 0,

    isDraw = true
}

function battlebox:update(dt)

end

function battlebox:TravelToX(x, time)
    local time = time or 0.5
    flux.to(self, time, {x = x} )
end

function battlebox:TravelToY(y, time)
    local time = time or 0.5
    flux.to(self, time, {y = y} )
end

function battlebox:TravelToWidth(width, time)
    local time = time or 0.5
    flux.to(self, time, {width = width} )
end

function battlebox:TravelToHeight(height, time)
    local time = time or 0.5
    flux.to(self, time, {height = height} )
end


function battlebox:ShowBox(bool)
    if bool == false then
        self.isDraw = false
    end
    if bool == true then
        self.isDraw = true
    end
end

function battlebox:draw()
    if self.isDraw == true then
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    end
end

return battlebox
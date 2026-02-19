local number = {}

function number.new(num, x, y, col)

    local floatingNumber = {}
    floatingNumber.number = num or 10
    floatingNumber.x = x or 10
    floatingNumber.y = y or 10
    floatingNumber.color = col or {1, 1, 1}
    floatingNumber.alpha = 2

    function floatingNumber:update(dt)
        self.y = self.y - dt * 100
        self.alpha = self.alpha - dt * 3
    end

    function floatingNumber:draw()
        love.graphics.setFont(require'assets'.fonts.dd16)
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
        love.graphics.print(num, self.x, self.y)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(require'assets'.fonts.ns13)
    end

    return floatingNumber

end

return number
local battlemanager = require'src.battlemanager'
local battlebox = require 'src.battlebox'
local bullet = require 'src.bullet'

local bulletspawner = {
    bullets = {},
    bulletsMax = 255,
    attackFunction = nil,

    delayUntillNextAttack = 2,
    delayUntillNextAttackMax = 2,
    battlebox = battlebox,

    funvar1 = 0,
    funvar2 = 0,
    funvar3 = 0,

    funtimer = 0,
    funtimer2 = 0,
    funtimer3 = 0,
}

function bulletspawner:createBullet(x, y, rotation, image, behavior)
    local bullet = bullet(x, y, rotation)
    bullet.x = x
    bullet.y = y
    bullet.rotation = rotation
    bullet:changeImage(image)
    bullet.behavior = behavior or 0

    table.insert(self.bullets, bullet)
end

function bulletspawner:Reset()
    self.funvar1 = 0
    self.funvar2 = 0
    self.funvar3 = 0

    self.funtimer = 0
    self.funtimer2 = 0
    self.funtimer3 = 0

    for i = #self.bullets, 1, -1 do
        local item = table.remove(self.bullets, i)
    end

end

function bulletspawner:changeFunction(fn)
    self.attackFunction = fn
end

function bulletspawner:update(dt)
    self.delayUntillNextAttack = self.delayUntillNextAttack - dt
        self:attackFunction(dt)
    for i=1, #self.bullets do
        local bullet = self.bullets[i]
        bullet:update(dt)
    end
end

function bulletspawner:draw()
    for i=1, #self.bullets do
        local bullet = self.bullets[i]
        bullet:draw()
    end
end

return bulletspawner
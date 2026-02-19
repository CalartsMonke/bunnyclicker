local TriBulletsAtSides = function(self, dt)
    
    if self.delayUntillNextAttack <= 0 then
        self.funvar1 = self.funvar1 + 1
        self.delayUntillNextAttack = self.delayUntillNextAttackMax

        local bulletImage = require 'assets'.images.projectiles.whiteBullet

        local angle = 0

        if self.funvar1 == 1 then
            angle = 0
        end
        if self.funvar1 == 2 then
            angle = 90
        end
        if self.funvar1 == 3 then
            angle = 180
        end
        if self.funvar1 == 4 then
            angle = 270
        end
        local battleBoxCenX = _G.battlebox.x + (_G.battlebox.width/2)
        local battleBoxCenY = _G.battlebox.y + (_G.battlebox.height/2)

        local newX = battleBoxCenX + math.cos(math.rad(angle)) * 130
        local newY = battleBoxCenY + math.sin(math.rad(angle)) * 130
        local attackAngle = angle + 180

        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle), bulletImage)
        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle + 10), bulletImage)
        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle - 10), bulletImage)

        if self.funvar1 >= 4 then
            self.funvar1 = 1
        end
        
    end
end

local TriBulletsAtSides2 = function(self, dt)
    
    if self.delayUntillNextAttack <= 0 then
        self.funvar1 = self.funvar1 + 1
        self.delayUntillNextAttack = self.delayUntillNextAttackMax

        local bulletImage = require 'assets'.images.projectiles.whiteBullet

        local angle = 0

        if self.funvar1 == 1 then
            angle = 0
        end
        if self.funvar1 == 2 then
            angle = 90
        end
        if self.funvar1 == 3 then
            angle = 180
        end
        if self.funvar1 == 4 then
            angle = 270
        end
        local battleBoxCenX = _G.battlebox.x + (_G.battlebox.width/2)
        local battleBoxCenY = _G.battlebox.y + (_G.battlebox.height/2)

        local newX = battleBoxCenX + math.cos(math.rad(angle)) * 130
        local newY = battleBoxCenY + math.sin(math.rad(angle)) * 130

        local newX2 = battleBoxCenX + math.cos(math.rad(angle + 45)) * 130
        local newY2 = battleBoxCenY + math.sin(math.rad(angle + 45)) * 130

        local attackAngle = angle + 180

        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle), bulletImage)
        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle + 10), bulletImage)
        self:createBullet(newX - 8, newY - 8, math.rad(attackAngle - 10), bulletImage)

        self:createBullet(newX2 - 8, newY2 - 8, math.rad(attackAngle + 45), bulletImage)
        self:createBullet(newX2 - 8, newY2 - 8, math.rad(attackAngle + 10 + 45), bulletImage)
        self:createBullet(newX2 - 8, newY2 - 8, math.rad(attackAngle - 10 + 45), bulletImage)

        if self.funvar1 >= 4 then
            self.funvar1 = 1
        end
        
    end
end



--fn is the attack function, enemies is a table of enemy id's
local function NewAttack(fn, enemies)
    local newAttack = {}
    newAttack.fn = fn
    newAttack.enemiesNeeded = enemies --table of id
    
    return newAttack
end



local e = require 'src.enemyid'


local attacks = {
    TriBulletsAtSides = NewAttack(TriBulletsAtSides, {e.dasherbun}),
    TriBulletsAtSides2 = NewAttack(TriBulletsAtSides2, {e.dasherbun, e.dasherbun})
}





return attacks
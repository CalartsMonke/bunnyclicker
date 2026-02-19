local healingitem = require('src.equip.healing.healingItem')
local player

local healSound = require 'assets'.sounds.heal1UT
healSound.volume = 1

local partStation = require 'src.particlestation'
local partTable = require 'particletable'
local lifePart = require 'src.part.lifepart'

HealingCowboyFood = healingitem:extend()

function HealingCowboyFood:new()
    self.baseFlatHealing = 5
    self.basePercentToHeal = 0
    self.charge = 0
    self.chargeMax = 300

    self.displayName = "Cowkid Meal"
    self.displayDesc = "A kids meal from the local fast food joint. Chock-full of overpriced health issues"
    self.usefulDesc = "Heals 5 HP"
end

function HealingCowboyFood:Use()
    if self.charge >= self.chargeMax then
        self:Heal()


        return true
    end
end


function HealingCowboyFood:update(dt)
    --quick fix for post creation
    if player ~= _G.player then
        player = _G.player
    end

    if self.charge > self.chargeMax then
        self.charge = self.chargeMax
    end
end

function HealingCowboyFood:Heal()
    local prevHp = player.currentHp
    player.currentHp = player.currentHp + self.baseFlatHealing
    if player.currentHp >= player.maxHp then
        player.currentHp = player.maxHp
    end
    healSound:play()
    self.charge = self.charge - self.chargeMax

    for i=1, player.currentHp - prevHp do
        local life = lifePart()
        table.insert(partTable ,partStation(player.x, player.y, life.part, 1))
    end


end

function HealingCowboyFood:draw()

end

return HealingCowboyFood
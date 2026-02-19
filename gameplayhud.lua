local player = require ('gameStats').player
local game = require ('gameStats')
local dungeon = _G.dungeon
local assets = require 'assets'
local coinTextOffX = 40
local coinTextOffY = 10
local hpOffX = 20
local hpOffY = 40
local segmentFilled = assets.images.hud.lifebarSegmentFilled
local segmentEmpty = assets.images.hud.lifebarSegmentEmpty

local bunnyblue = require'colors'.bunnyblue

local extraAngleIncrease = 1

local gameplayHud = {

    heartIconPosX = 120,
    heartIconPosY = 330,
    weaponIconPosX = 20,
    weaponIconPosY = 60,
    coinIconPosX = 20,
    coinIconPosY = 20,
    keyIconPosX = 999,
    keyIconPosY = 310,

    healChargeX = 6,
    healChargeY = 360 - 10,
    healBarHeight = 2,
    healBarLength = 292,
    
    healBarWidth = 30,
    healBarOffset = 2,

    activeItemsPosX = game.gameWidth/2 + 96,
    activeItemsPosY = game.gameHeight - 64,
    activeItemsPosSep = 80,

    consumableItemsPosX = game.gameWidth - 96,
    consumableItemsPosY = game.gameHeight - 64,

    coinIconImage = require 'assets'.images.hudCoin,
    keyIconImage = require 'assets'.images.keyIcon,
    keyIconImageDotted = require 'assets'.images.keyIconDotted,

    showExtraInfo = false,

    MODES = {
        NORMAL = 1,
        SHOP = 2,
    },
}
    gameplayHud.mode = gameplayHud.MODES.NORMAL



function gameplayHud:update(dt)
    extraAngleIncrease = extraAngleIncrease + dt * 50
end

function gameplayHud:drawNormalHud()
    if love.keyboard.isDown('lshift') then
        self.showExtraInfo = true
    else
        self.showExtraInfo = false
    end

    local segmentWidth = 4
    local segmentHeight = 18
    local spacing = segmentWidth + 2
    local hp = player.currentHp
    local maxhp = player.maxHp
    local letterLength

    --draw empty health
    love.graphics.setFont(require'assets'.fonts.dd16)
    love.graphics.setColor(bunnyblue)
    love.graphics.print('LIFE '..hp..'/'..maxhp, 4, self.heartIconPosY)
    local String = 'LIFE '..hp..'/'..maxhp
    letterLength = string.len(String)
    local letterSep = require'assets'.fonts.dd16:getWidth(String)

    love.graphics.setFont(require'assets'.fonts.ns13)
    love.graphics.setColor(1, 1, 1, 1)

    for i = 1, player.maxHp do
        love.graphics.draw(segmentEmpty, 6 + letterSep + ((i - 1) * spacing), self.heartIconPosY)
    end

    for i = 1, player.currentHp do
        love.graphics.draw(segmentFilled, 6 + letterSep + ((i - 1) * spacing), self.heartIconPosY)
    end
    love.graphics.setColor(1, 1, 1, 1)


    local healitem = player.equippedHealing

    local charge = healitem.charge
    if charge > healitem.chargeMax then
        charge = healitem.chargeMax
    end

    local barLength = ((charge / healitem.chargeMax ) * self.healBarLength)

    local color = require'colors'.lifegreen
    love.graphics.setColor(color, 1)
    love.graphics.setLineStyle("rough")
    love.graphics.rectangle('line', self.healChargeX, self.healChargeY, self.healBarLength + 4, 6)
    love.graphics.rectangle('fill', self.healChargeX + 1, self.healChargeY + 1, barLength, 3)

    love.graphics.setFont(assets.fonts.dd16)
    local percent = math.floor((charge / healitem.chargeMax ) * 100)
    --love.graphics.print('%'..percent, self.healChargeX + 20, self.healChargeY + 8)
    love.graphics.setFont(assets.fonts.ns13)
    love.graphics.setColor(1, 1, 1, 1)



    --DRAWING ITEMS
        local totalChargeLength = 250
        local barSepLength = 8
        local currentBarLength = 0
        local bonusSep = 0
        local barLength = ((player.weaponChargeCurrent / player.weaponChargeMax ) * totalChargeLength)

        for i=1 , totalChargeLength, 1 do

            if i == 125 or i == 200 then
                bonusSep = bonusSep + barSepLength
                print(bonusSep)
            end

            love.graphics.rectangle('fill', (620 - bonusSep) - (i - 1), 350, 1, 6 )
        end

        bonusSep = 0

        love.graphics.setColor(1,0,1)
        for i=1 , math.floor(barLength), 1 do

            if i == 125 or i == 200 then
                bonusSep = bonusSep + barSepLength
                print(bonusSep)
            end

            love.graphics.rectangle('fill', (620 - bonusSep) - (i - 1), 350, 1, 6 )
        end
        love.graphics.setColor(1,1,1)
       
      
end

function gameplayHud:drawShopHud()

end

function gameplayHud:draw()
    if self.mode == self.MODES.NORMAL then
        self:drawNormalHud()
    end

    if self.mode == self.MODES.SHOP then
        self:drawShopHud()
    end
end

return gameplayHud
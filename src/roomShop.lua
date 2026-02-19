local entities = require('roomEntities')
local object = require('lib.classic')
local gameStats = require('gameStats')
local gameItems = require('src.items.brownBrick')
local gameItems1 = require('src.items.assaultgun')
local gameItems2 = require('src.items.goldgun')
local gameItems3 = require('src.items.brokenbottle')
local progBar = require('src.progressBar')

local shopNone = {
    price = 0
}

RoomShop = object:extend()

function RoomShop:new()
    self.parentDungeon = nil
    self.isCleared = false
    self.displayName = 'THIS IS A FLIPPING SHOP'
    self.items = {gameItems(), gameItems(), gameItems1(), gameItems2(), gameItems3()}
    self.itemsMax = 5 --should be the height of self.items normally, but is 5 for debug
    self.itemsInRow = self.itemsMax

    self.buyTimeMax = 1
    self.buyTimeCurrent = 0
    self.buyingItem = false
    self.buyIndex = nil
    self.buyBar = nil

    self.setSelected = nil
    self.previewIndex = nil
    self.selectedItems = nil
    
    self.image = require 'assets'.images.hud.shopkeeper.talk
    self.animFrames = {}
    self.frameWidth = 140
    self.frameHeight = 300
    self.frameToDraw = 1
    self.currentFrame = 1

    for i=0,1 do
        table.insert(self.animFrames, love.graphics.newQuad(i * self.frameWidth, 0, self.frameWidth, self.frameHeight, self.image:getWidth(), self.image:getHeight()))
    end



    self.boxPosX = 150
    self.boxPosY = 20
    self.boxWidth = 80
    self.boxHeight = 160
    self.itemImageX = 8
    self.itemImageY = 10
    self.boxXSep = self.boxWidth + 10
    self.boxYSep = 10



    --TEXT BOX
    self.textWrapLimit = 400
    self.textBoxY = 100
    self.textBoxX = 100
    self.textX = 140
    self.textY = 200
    self.currentText = ""
    self.textTable = {
        autotags = "[]", -- This string is added at the start of every textbox, can include tags.
        font = require'assets'.fonts.dd16, -- Default font for the textbox, love font object.
        color = {1,1,1,1}, -- Default text color.
        shadow_color = {1,1,1,1}, -- Default Drop Shadow Color.
        print_speed = 0.05, -- How fast text prints.
        adjust_line_height = 4, -- Adjust the default line spacing.
        default_strikethrough_position = 0, -- Adjust the position of the strikethough line.
        default_underline_position = 0, -- Adjust the position of the underline line.
        character_sound = true, -- Use a voice when printing characters? True or false.
        sound_number = 1, -- What voice to use when printing characters.
        sound_every = 1, -- How many characters to wait before making another noise when printing text.
        default_warble = 0 -- How much to adjust the voice when printing each character. 
    }

    self.lettersToDisplay = 1
    self.isLeaving = false
    self.leaveTime = 1.5

    self.textBox = require'textbox'.new('left', self.textTable)
end

function RoomShop:keypressed(key, scancode, isrepeat)

    if self.previewIndex == nil then
        self.previewIndex = 1
    end

    if key == 'space' then
        self.buyingItem = true
        self.buyIndex = self.items[self.previewIndex]
        self.buyBar = progBar.new(0, 0, self.buyTimeMax, 1)
    end

    if key == 'a' then
        self.previewIndex = self.previewIndex - 1
    end

    if key == 'd' then
        self.previewIndex = self.previewIndex + 1
    end

    if key == 'w' then
        self.previewIndex = self.previewIndex - self.itemsInRow
    end

    if key == 's' then
        self.previewIndex = self.previewIndex + self.itemsInRow
    end

    if key == 'return' then
        self.isLeaving = true
        self.textBox:send(require'src.textStrings'.shopnormal.leave)
    end

    if key == 'u' then
        --self.lettersToDisplay = 1
    end

    if key == 'p' then
       -- textspeed = textspeed + 1
    end

    if key == 'o' then
        --textspeed = textspeed - 1
    end
    
end

function RoomShop:enter()

    self.lettersToDisplay = 1
    self.previewIndex = nil
    self.textBox:send(require'src.textStrings'.shopnormal.welcome, self.textWrapLimit)

end

function RoomShop:exit()
    for i=#entities, 1, -1 do
        local item = entities[i]

        if item:is(shopItem) then
            local shopitem = table.remove(entities, i)
            shopitem.isActive = false
            table.insert(self.items, shopitem)
        end
    end
    self.parentDungeon:returnToRoomSelect()
end

local player = require ('gameStats').player
local world = require ('world')

function RoomShop:buySlot(index)
    if self.items[index] ~= nil then
        if _G.player.coins >= self.items[index].price then
            local item = self.items[index]
            self.items[index] = nil
            _G.player:addToItems(item)
            self.buyIndex = nil
            self.buyBar = nil
            self.buyingItem = false

            _G.player.coins = _G.player.coins - item.price
        end

    end
end

function RoomShop:update(dt)
    self.textBox:update(dt)

    if self.buyingItem == true then
        
        if love.keyboard.isDown('space') then
            self.buyTimeCurrent = self.buyTimeCurrent + dt
            self.buyBar:update(dt)
            self.buyBar.x = _G.player.x
            self.buyBar.y = _G.player.y - 20
        else
            self.buyingItem = false
            self.buyBar = nil
            self.buyIndex = nil
        end
        if self.buyTimeCurrent >= self.buyTimeMax then
            local bindex = self.previewIndex
            self:buySlot(bindex)
        end

    else
        self.buyTimeCurrent = 0
    end

    if self.isLeaving == true then
        self.leaveTime = self.leaveTime - dt

        if self.leaveTime <= 0 then
            self.leaveTime = 1.5
            self.isLeaving = false
            self:exit()
        end
    end


    if self.previewIndex ~= nil then
        if self.previewIndex > self.itemsMax then
            self.previewIndex = self.itemsMax
        end
        if self.previewIndex < 1 then
            self.previewIndex = 1
        end
    end


    if self.textBox:is_finished() == false then
        self.currentFrame = self.currentFrame + dt * 15
    end

    if self.currentFrame > #self.animFrames + 1  then
        self.currentFrame = 1
    end

    self.frameToDraw = math.floor(self.currentFrame)




end

function RoomShop:draw()
    self.textBox:draw(self.textX, self.textY)


    --BUY BAR
    if self.buyBar ~= nil then
        self.buyBar:draw()
    end

    --love.graphics.draw(require 'assets'.images.hud.shopkeeper.idle1, 0,80)
    love.graphics.draw(self.image, self.animFrames[(self.frameToDraw)], 0, 80)
    for i=1, self.itemsMax do
        if i == self.previewIndex then
            love.graphics.setColor(1, 1, 0, 1)
        end
        love.graphics.rectangle('line', self.boxPosX + (i-1) * self.boxXSep, self.boxPosY, self.boxWidth, self.boxHeight)
        love.graphics.setColor(1, 1, 1, 1)


        if self.items[i]~= nil then
            --DRAW ITEM IMAGE
            love.graphics.draw(self.items[i].image, (self.boxPosX + (i-1) * self.boxXSep) + self.itemImageX, self.boxPosY + self.itemImageY)
            --DRAW COIN
            love.graphics.draw(require'assets'.images.hudCoin, (self.boxPosX + (i-1) * self.boxXSep) + self.itemImageX - 0, self.boxPosY + self.itemImageY + 90)
            love.graphics.setFont(require'assets'.fonts.dd16)
            --DRAW ITEM PRICE
            love.graphics.print(self.items[i].price, (self.boxPosX + (i-1) * self.boxXSep) + self.itemImageX + 40, self.boxPosY + self.itemImageY + 95)
            love.graphics.setFont(require'assets'.fonts.ns13)
        end
    end

    --Draw items im too lazy to sort rn
    local worldItems, worldLen = world:getItems()
    for i = 1, worldLen do
        local item = worldItems[i]
      if item:is(Player) then
        item:draw()
      end
    end

end

return RoomShop
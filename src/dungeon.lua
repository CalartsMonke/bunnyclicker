Dungeon = Object:extend()
local Room = require('src.room')
local bossKey = require('src.collectible.keyBoss')

local assets = require('assets')

local blueSquare = require('assets').images.blueRoomSquare

local NAMES = {
    "BACK ALLEY",
    "DRUG STREET",
}

function Dungeon:new()

    self.confirm = 0

    self.cellWidth = 32
    self.cellHeight = 32
    self.cellsHorizontal = 14
    self.cellsVertical = 8
    self.cellStartX = self.cellWidth * 3
    self.cellStartY = self.cellHeight

    self.name = NAMES[math.floor(love.math.random(1, #NAMES))]
    self.level = 1

    self.STATES =
 {
    SELECTING = 1,
    PREVIEWING = 2,
    ACTIVE = 3,
 }
    self.state = self.STATES.SELECTING
    self.rooms = {}
    self.roomsDisplay = {}
    self.roomlimit = 10
    self.roommin = 6

    self.eRoomMax = 5
    self.eRoomMin = 2

    self.activeRoom = 0 --index of room that is being played
    self.previewRoom = 1 --index of room to show when selecting room
    self.currentRoom = nil

    self.textAlpha = 0

    self:generateNew()
end


function Dungeon:generateNew()
    local hasGivenKey = false
    local maxNormalRooms = 7
    local BossKey = bossKey
    for i = 1, maxNormalRooms do
        local newroom = Room
        local newRoom = newroom(1, self)

        local num = love.math.random(1, 3)
        if num > 2 and hasGivenKey == false then
            newRoom.prizeItem:Destroy()
            newRoom.prizeItem = BossKey(200, 200)
            newRoom.prizeItem.parentRoom = newRoom
            hasGivenKey = true
        end
        if hasGivenKey == false and i == maxNormalRooms then
            newRoom.prizeItem:Destroy()
            newRoom.prizeItem = BossKey(200, 200)
            newRoom.prizeItem.parentRoom = newRoom
            hasGivenKey = true
        end

        newRoom.parentDungeon = self
        table.insert(self.rooms, newRoom)

    end
    local shopRoom = require('src.roomShop')
    shopRoom.parentDungeon = self
    table.insert(self.rooms, shopRoom())

    local bossRoom = require('src.roomBoss')
    local BossRoom = bossRoom
    bossRoom.parentDungeon = self
    table.insert(self.rooms, BossRoom())


    --DO ROOM HEIGHT TABLES
    for i=1, #self.rooms do
        local heightTable = {height = 0}
        table.insert(self.roomsDisplay, heightTable)
    end
end

function Dungeon:returnToRoomSelect()
    self.activeRoom = 0
    self.state = self.STATES.SELECTING
end

function Dungeon:previewIncrement()
    self.previewRoom = self.previewRoom + 1
    if self.previewRoom >= #self.rooms + 1 then
        self.previewRoom = 1
    end
end

function Dungeon:previewDecrement()
    self.previewRoom = self.previewRoom - 1
    if self.previewRoom <= 0 then
        self.previewRoom = #self.rooms
    end
end

function Dungeon:keypressed(key, scancode, isrepeat)
    if key == 'a' then
        self:previewDecrement()
    end

    if key == 'd' then
        self:previewIncrement()
    end

    if key == 'space' then

    end
    if self.state == self.STATES.ACTIVE then
    self.currentRoom:keypressed(key, scancode, isrepeat)
    end

end

function Dungeon:confirmRoomChoice(dt)

    if love.keyboard.isDown('space') then
        self.confirm = self.confirm + dt
    else
        self.confirm = 0
    end

    if self.confirm > 0.6 then
        local roomToEnter = self.rooms[self.previewRoom]
        if not self.rooms[self.previewRoom].isCleared then
            if roomToEnter:is(RoomBoss) then
                if _G.player.hasBossKey == true then
                    _G.player.hasBossKey = false
                    self.activeRoom = self.previewRoom
                    self.state = self.STATES.ACTIVE
                    self.rooms[self.activeRoom]:enter()
                else
                    self.textAlpha = 1.5
                end
            end

            if self.rooms[self.previewRoom]:is(RoomShop) then
                self.activeRoom = self.previewRoom
                self.state = self.STATES.ACTIVE
                self.rooms[self.activeRoom]:enter()
            end

            if roomToEnter:is(Room) then
            self.activeRoom = self.previewRoom
            self.state = self.STATES.ACTIVE
            end
        end
        self.confirm = 0
    end
end

function Dungeon:update(dt)
    if self.state == self.STATES.ACTIVE then
    self.currentRoom = self.rooms[self.activeRoom]
    --Confirm a room to enter
    end



    if self.state == self.STATES.SELECTING then
        self:confirmRoomChoice(dt)
        self.textAlpha = self.textAlpha - dt

        for i = 1, #self.roomsDisplay do
           room = self.roomsDisplay[i]
           
           if self.previewRoom == i then
                if room.height < 8 then
                    room.height = room.height + 2
                end
            else
                room.height = room.height - 1
            end

            if room.height < 0 then
                room.height = 0
            end

            if room.height > 8 then
                room.height = 8
            end

        end
    end

    if self.state == self.STATES.ACTIVE then
        self.rooms[self.activeRoom]:update(dt)
    end


end

function Dungeon:draw()

    love.graphics.setColor(1, 1, 1, self.textAlpha)
    love.graphics.setFont(require'assets'.fonts.dd16)
    love.graphics.print("NEED KEY!", 200, 250)
    love.graphics.setFont(require'assets'.fonts.ns13)
    love.graphics.setColor(1, 1, 1, 1)

    if self.state == self.STATES.SELECTING then
        --DRAW BACKGROUND BASED ON CURRENT LEVEL
        love.graphics.setColor(1, 1, 1, 0.6)
        love.graphics.draw(assets.images.backgrounds.dungeon.backalley1, 0, 0)
        love.graphics.setColor(1, 1, 1, 1)



        --love.graphics.print("ROOM NAME: "..self.rooms[self.previewRoom].displayName, 200, 200)
        local roomToEnter = self.rooms[self.previewRoom]
        if roomToEnter.prizeItem ~= nil then
            if roomToEnter.prizeItem:is(KeyBoss) then
            --    love.graphics.print("BOSS KEY", 200, 300)
            end
            if roomToEnter.prizeItem:is(BagDrop) then
            --    love.graphics.print("COIN BAG", 200, 300)
            end
        end

        love.graphics.setFont(require'assets'.fonts.dd16)
        love.graphics.print(self.name, 460, 40)
        love.graphics.print("LEVEL - "..self.level, 470, 10)
        love.graphics.setFont(require'assets'.fonts.ns13)

        

        local imageToDraw = blueSquare
        for i=1, #self.rooms do
            local index = i
            local heightSep = 0
            local roomToDraw = self.rooms[i]
            if roomToDraw:is(Room) and roomToDraw.isCleared == true then
                imageToDraw = require('assets').images.grayRoomSquare
            end
            if roomToDraw:is(Room) and roomToDraw.isCleared == false then
                imageToDraw = require('assets').images.blueRoomSquare
            end
            if roomToDraw:is(RoomShop) then
                imageToDraw = require('assets').images.shopRoomSquare
            end
            if roomToDraw:is(RoomBoss) then
                imageToDraw = require('assets').images.bossRoomSquare
            end

            if index == self.previewRoom then
                heightSep = -8
            end

            love.graphics.draw(imageToDraw, 100 + i * 32, 10 + self.roomsDisplay[i].height)
        end

        --DEBUG
       -- love.graphics.print(self.previewRoom, 300, 100)
       -- love.graphics.print(self.activeRoom, 200, 100)
    end

    
    local function ScaleMousePosToScreen()
        local scaledScreenX, scaledScreenY = love.graphics.getWidth() / _G.screenScale, love.graphics.getHeight() / _G.screenScale
        local screenX, screenY = 640, 360
        local mouseOffX = (screenX - scaledScreenX) / 2
        local mouseOffY = (screenY - scaledScreenY) / 2
    
        return (love.mouse.getX() / _G.screenScale) + mouseOffX, (love.mouse.getY() / _G.screenScale) + mouseOffY
    end

    if self.state == self.STATES.ACTIVE then
                --DRAW BACKGROUND BASED ON CURRENT LEVEL
                love.graphics.setColor(1, 1, 1, 0.6)
                love.graphics.draw(assets.images.backgrounds.rooms.backalley.backalley1, 0, 0)
                love.graphics.setColor(1, 1, 1, 1)

                local csx, csy = self.cellStartX, self.cellStartY

                --debug
                local mx, my = _G.scaledMX, _G.scaledMY
                local cx, cy = self:ConvertPositionToCell(mx, my)

                love.graphics.setColor(1, 1, 1, 0.2)
                love.graphics.circle('fill', cx + 16, cy + 16, 10)
                for i = 1, 14 do
                    love.graphics.line(csx + (i-1) * self.cellWidth, csy, csx + (i-1) * self.cellWidth, (self.cellHeight * self.cellsVertical) + self.cellStartY)
                end
                for  i = 1, 10 do
                    love.graphics.line(csx, csy + (i-1) * self.cellHeight, self.cellStartX + self.cellsHorizontal * self.cellWidth , csy + (i-1) * self.cellHeight)
                end
                love.graphics.setColor(1, 1, 1, 1)

        self.rooms[self.activeRoom]:draw()
    end
end

function Dungeon:ConvertPositionToCell(x, y)
    local cellwidth = 32
    local cellheight = 32

    local nx =  (math.floor((x / cellwidth)) * cellwidth) / _G.screenScale
    local ny =  (math.floor((y / cellheight)) * cellheight) / _G.screenScale
    print("CELLX "..nx / 32)
    print("CELLY "..ny / 32)
    return nx, ny
end

function Dungeon:InstanceCreateOnCell(list, instance, cx, cy)
    local cxOff = 3
    local cyOff = 1
    local xOff = cxOff * 32
    local yOff = cyOff * 32


    instance.x = (cx * 32) + xOff
    instance.y = (cy * 32) + yOff
    local list = list
    table.insert(list, instance)
    print(instance.x)
    print(instance.y)
end




return Dungeon
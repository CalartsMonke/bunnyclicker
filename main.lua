require 'love'
love.graphics.setDefaultFilter("nearest", "nearest")


local world = require 'world'
local Player = require 'src.player'
local Enemy = require 'src.enemy.enemy'

local game = require 'gameStats'

local debugChart = require 'src.debugchart'

--require images
local textureCursor = love.graphics.newImage('/img/cursor.png/')

--Define game width and height, and battle box width and height
local gameWidth = 640
local gameHeight = 360

local distToSubtract = 220
local gameBoxStart = (gameWidth/2) - distToSubtract
local gameBoxWidth = gameBoxStart + (distToSubtract * 1.5)

local gameBoxStartY = 20
local gameBoxHeight = 230

local mx, my


    --make a new canvas
    local canvas = love.graphics.newCanvas(640, 360)

    --Canvas scaling
    local maxScaleX 
    local maxScaleY 
    
    local scale = 1





--turn off mouse cursor (which will have a a sprite drawn at it instead
love.mouse.setVisible(true) -- set cursor to false


local player = game.player

local listOfEnemies = {}

function InstanceCreate(x, y, obj)
    local objectToSpawn = 'src.'..tostring(obj)
    local object = require(objectToSpawn)
    object(x, y)
    object.x = x
    object.y = y

    return object
 end

function love.load()
    

    --add enemies to list
    table.insert(listOfEnemies, Enemy(gameBoxWidth*0.5, gameBoxHeight* 0.2))

end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
        player.leftmbpressed = true
    end
 end

 --TEST




function love.update(dt)


    --get scaled mx and my
    local scaledScreenX, scaledScreenY = love.graphics.getWidth() / scale, love.graphics.getHeight() / scale
    local screenX, screenY = gameWidth, gameHeight
    local mouseOffX = (screenX - scaledScreenX) / 2
    local mouseOffY = (screenY - scaledScreenY) / 2
    --alt
    --local mouseOffX = (scaledScreenX - screenX) / 2
    --local mouseOffY = (scaledScreenY - screenY) / 2


    debugChart:AddToChart(tostring(scaledScreenX))
    debugChart:AddToChart(tostring(screenX))

    debugChart:AddToChart(tostring(mouseOffX))
    debugChart:AddToChart(tostring(mouseOffY))
    

    mx, my = (love.mouse.getX() / scale) + mouseOffX, (love.mouse.getY() / scale) + mouseOffY




    local boxcheck
    if (mx > gameBoxStart and mx < gameBoxStart + gameBoxWidth) and (my > gameBoxStartY and my < gameBoxStartY + gameBoxHeight) then
        boxcheck = "YOU ARE IN BOX"
        player.insideBox = true
    else
        boxcheck = 'YOU ARE NOT IN BOX'
        player.insideBox = false
    end
    debugChart:AddToChart("insidebox: "..tostring(player.insideBox))


    local worldItems, worldLen = world:getItems()
    for i = 1, worldLen do
        local item = worldItems[i]
        item:update(dt)
    end



    --Update player
    world:update(player, player.x, player.y)
    player.x = mx
    player.y = my
 

    local playerx = tostring(player.x)
    local playery = tostring(player.y)
    
    debugChart:AddToChart(player.boxX)
    debugChart:AddToChart(player.boxY)

end

function love.keypressed(key, scancode, isrepeat)
    if key == "f4" then
        if love.window.getFullscreen() == false then
            love.window.setFullscreen(true, 'desktop')
        else
            love.window.setFullscreen(false)
        end
    end
 end




function love.draw()
    --init canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    --draw a bg
    love.graphics.setColor(85/255, 65/255, 102/255)
    love.graphics.rectangle('fill', 0, 0, gameWidth, gameHeight)
    love.graphics.setColor(1,1,1)




    love.graphics.print("Center", gameWidth/2, gameHeight/2)
    if player.state ~= 2 then
    love.graphics.draw(textureCursor, mx, my, 0, 1, 1, 0, -0)
    end
    --Draw debug rectangle box
    love.graphics.rectangle('line', gameBoxStart, gameBoxStartY, gameBoxWidth, gameBoxHeight)


    --draw debug chart
    debugChart:DrawDebugMessage(10, 10, 0, 16)


    --Draw items im too lazy to sort rn
    local worldItems, worldLen = world:getItems()
    for i = 1, worldLen do
        local item = worldItems[i]
        item:draw()
    end

    --return canvas to normal
    love.graphics.setCanvas()

    --Canvas scaling
    maxScaleX = love.graphics.getWidth() / canvas:getWidth()
    maxScaleY = love.graphics.getHeight() / canvas:getHeight()
    scale = math.min(maxScaleX, maxScaleY)
    debugChart:AddToChart(tostring(scale))


    love.graphics.draw(canvas, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, scale, scale, canvas:getWidth() / 2, canvas:getHeight() / 2)
end
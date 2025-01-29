require 'love'
love.graphics.setDefaultFilter("nearest", "nearest")


local world = require 'world'
local Player = require 'src.player'

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
    local maxScaleX = love.graphics.getWidth() / canvas:getWidth()
    local maxScaleY = love.graphics.getHeight() / canvas:getHeight()
    local scale = math.min(maxScaleX, maxScaleY)





--turn off mouse cursor (which will have a a sprite drawn at it instead
love.mouse.setVisible(false) -- set cursor to false


local player = Player()

function love.load()
    
end

function love.update()


    --get scaled mx and my
    local scaledScreenX, scaledScreenY = love.graphics.getWidth() * scale, love.graphics.getHeight() * scale
    local screenX, screenY = love.graphics.getWidth(), love.graphics.getHeight()
    local mouseOffX = (screenX - scaledScreenX) / 2
    local mouseOffY = (screenY - scaledScreenY) / 2

    mx, my = (love.mouse.getX() / scale) - mouseOffX, (love.mouse.getY() / scale) - mouseOffY




    print("MX: "..mx)
    print("MY: "..my)
    local boxcheck
    if (mx > gameBoxStart and mx < gameBoxStart + gameBoxWidth) and (my > gameBoxStartY and my < gameBoxStartY + gameBoxHeight) then
        print('you are in the box')
        boxcheck = "YOU ARE IN BOX"
    else
        print('you are not in the box and need to get in it')
        boxcheck = 'YOU ARE NOT IN BOX'
    end
    debugChart:AddToChart(boxcheck)

    --Update player
    player:update(dt)
    world:update(player, player.x, player.y)
    print(player.x)
    print(player.y)

    local playerx = tostring(player.x)
    local playery = tostring(player.y)
    local testmsg = "This is a test message"
    debugChart:AddToChart(playerx)
    debugChart:AddToChart(playery)
    debugChart:AddToChart(testmsg)

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

    love.graphics.draw(textureCursor, mx *scale, my*scale, 0, 1, 1, -8, -8)
    --Draw debug rectangle box
    love.graphics.rectangle('line', gameBoxStart, gameBoxStartY, gameBoxWidth, gameBoxHeight)


    --draw debug chart
    debugChart:DrawDebugMessage(10, 10, 0, 16)

    --return canvas to normal
    love.graphics.setCanvas()

    --Canvas scaling
    local maxScaleX = love.graphics.getWidth() / canvas:getWidth()
    local maxScaleY = love.graphics.getHeight() / canvas:getHeight()
    local scale = math.min(maxScaleX, maxScaleY)


    love.graphics.draw(canvas, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, scale, scale, canvas:getWidth() / 2, canvas:getHeight() / 2)
end
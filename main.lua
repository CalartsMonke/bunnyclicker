require 'love'
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

--turn off mouse cursor (which will have a a sprite drawn at it instead
love.mouse.setVisible(false) -- set cursor to false


local player = Player()

function love.load()
    
end

function love.update()
    local mx, my = love.mouse.getPosition()
    print("MX: "..mx)
    print("MY: "..my)
    if (mx > gameBoxStart and mx < gameBoxStart + gameBoxWidth) and (my > gameBoxStartY and my < gameBoxStartY + gameBoxHeight) then
        print('you are in the box')
    else
        print('you are not in the box and need to get in it')
    end

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
    love.graphics.print("Center", gameWidth/2, gameHeight/2)

    local mx, my = love.mouse.getPosition()
    love.graphics.draw(textureCursor, mx - 8, my - 8)
    --Draw debug rectangle box
    love.graphics.rectangle('line', gameBoxStart, gameBoxStartY, gameBoxWidth, gameBoxHeight)


    --draw debug chart
    debugChart:DrawDebugMessage(10, 10, 0, 16)
end
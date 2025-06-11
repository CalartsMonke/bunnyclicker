require 'love'
love.graphics.setDefaultFilter("nearest", "nearest")
Object = require 'lib.classic'



flux = require 'lib.flux'
local roomy = require 'lib.roomy'

love.hasDeprecationOutput(false)
local world = require 'world'
local assets = require 'assets'
local Enemy = require 'src.enemy.enemy'

local game = require 'gameStats'
_G.game = game


local rManager = require 'lib.roomy'.new()

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

local partTable = require 'particletable'

local dungeon = require 'dungeonFile'
_G.dungeon = dungeon
local gameHud = require 'gameplayhud'
_G.gameHud = gameHud


local entities = require 'roomEntities'

local player = game.player
_G.player = player
table.insert(entities, player)



local mx, my


    --make a new canvas
    local canvas = love.graphics.newCanvas(640, 360)

    --Canvas scaling
    local maxScaleX 
    local maxScaleY 
    
    local scale = 1
    _G.screenScale = scale

--turn off mouse cursor (which will have a a sprite drawn at it instead
    love.mouse.setVisible(false) -- set cursor to false please



function InstanceCreate(x, y, obj)
    local objectToSpawn = 'src.'..tostring(obj)
    local object = require(objectToSpawn)
    object(x, y)
    object.x = x
    object.y = y

    return object
 end

 local state = {}



function love.load()

    --TITLE SCREEN
    rManager:hook()
    rManager:enter(state.title)

end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
        player.leftmbpressed = true
    end
 end

function love.update(dt)
    flux.update(dt)

    --update particle table
    local partTab = partTable
    for i = 1, #partTab do
        if i <= #partTable then
        partTab[i]:update(dt)
        end
    end

end

function love.draw()


    maxScaleX = love.graphics.getWidth() / canvas:getWidth()
    maxScaleY = love.graphics.getHeight() / canvas:getHeight()
    scale = math.min(maxScaleX, maxScaleY)
 end

function love.keypressed(key, scancode, isrepeat)
    if key == "f4" then
        if love.window.getFullscreen() == false then
            love.window.setFullscreen(true, 'desktop')
        else
            love.window.setFullscreen(false)
        end
    end
    --Debug
    if key == 'f5' then
        love.event.restart()
    end

    if key == "tab" then
        local state = not love.mouse.isVisible()   -- the opposite of whatever it currently is
        love.mouse.setVisible(state)
     end

     --DUNGEON FUNCTIONS
     dungeon:keypressed(key, scancode, isrepeat)

     player:keypressed(key, scancode, isrepeat)
 end

 --TITLE SCREEN
 state.title = {}

 function state.title:enter(previous, ...)
     -- set up the level
 end
 
 function state.title:update(dt)
     -- update entities
 end
 
 function state.title:leave(next, ...)
     -- destroy entities and cleanup resources
 end
 
 function state.title:draw()
     love.graphics.draw(assets.images.titlelogo)
 end

 function state.title:keypressed(key)
    if key == 'space' then
        rManager:enter(state.gameplay)
    end
 end

--GAMEPLAY
 state.gameplay = {}

 function state.gameplay:enter(previous, ...)
     -- set up the level
         --add enemies to list
 end
 
 function state.gameplay:update(dt)
     -- update entities
       --get scaled mx and my
    local scaledScreenX, scaledScreenY = love.graphics.getWidth() / scale, love.graphics.getHeight() / scale
    local screenX, screenY = gameWidth, gameHeight
    local mouseOffX = (screenX - scaledScreenX) / 2
    local mouseOffY = (screenY - scaledScreenY) / 2

    
    mx, my = (love.mouse.getX() / scale) + mouseOffX, (love.mouse.getY() / scale) + mouseOffY
    _G.scaledMX = mx
    _G.scaledMY = my

    local boxcheck
    if (mx > gameBoxStart and mx < gameBoxStart + gameBoxWidth) and (my > gameBoxStartY and my < gameBoxStartY + gameBoxHeight) then
        boxcheck = "YOU ARE IN BOX"
        player.insideBox = true
    else
        boxcheck = 'YOU ARE NOT IN BOX'
        player.insideBox = true
    end


    local worldItems, worldLen = world:getItems()
    for i = 1, worldLen do
        local item = worldItems[i]

    end

    dungeon:update(dt)

    
    
    --Update player
    player.x = mx - player.mOffX/2
    player.y = my - player.mOffY/2
 
    local playerx = tostring(player.x)
    local playery = tostring(player.y)
    
    debugChart:AddToChart(player.boxX)
    debugChart:AddToChart(player.boxY)
 end
 
 function state.gameplay:leave(next, ...)
     -- destroy entities and cleanup resources
 end
 
 function state.gameplay:draw()
   


    --ROOM DRAWING CODE PLACEHOLDER
      -- draw the level
      --init canvas
      love.graphics.setCanvas(canvas)
      love.graphics.clear()
      canvas:setFilter("nearest")
  
  
      --draw debug chart
     -- debugChart:DrawDebugMessage(10, 10, 0, 16)
  
    dungeon:draw()
    gameHud:draw()

    --Draw particles
    local partTab = partTable
    for i = 1, #partTab do
        partTab[i]:draw()
    end

    --return canvas to normal
    love.graphics.setCanvas()


    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(canvas, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, scale, scale, canvas:getWidth() / 2, canvas:getHeight() / 2)
    love.graphics.setBlendMode("alpha")
 end

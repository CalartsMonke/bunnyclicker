require 'love'
love.math.setRandomSeed(love.timer.getTime())
love.graphics.setDefaultFilter("nearest", "nearest")
Object = require 'lib.classic'

ripple = require 'lib.ripple'
sti = require 'lib.sti'

_G.debug = true --TODO REMOVE AT GAMERELEASE


--PLACE ROOM MAKING CODE BACK HERE IF IT DOESNT WORK


local baton = require 'lib.baton'

_G.battleBox = require 'src.battlebox'

local inputControls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right =  {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
    attack = {'mouse:1', 'key:z', 'button:a'},
    subweapon = {'mouse:2', 'key:x', 'button:rightshoulder'},
    heal = {'key:c', 'mouse:3', 'mouse:4', 'button:leftshoulder'},
}
input = baton.new {
    controls = inputControls,
    joystick = love.joystick.getJoysticks()[1],
}

local text = require 'textbox'
text.configure.audio_table(require'assets'.sounds)
text.configure.add_text_sound(require'assets'.sounds.text1, 0.2) 

local textTextbox = text.new('center',{
     color = {1,1,1,1},
    shadow_color = {0.5,0.5,1,0.4},
    font = require'assets'.fonts.dd16,
    character_sound = true, 
    sound_every = 1, 
    sound_number = 1,
    adjust_line_height = 0
    }
)
    textTextbox:send("GEE I SURE DO [color=#ff0000]LOVE[/color][rainbow][bounce] FRESH [u] FLY[/u] [shake]SOUP[/shake]![/rainbow]")

flux = require 'lib.flux'
local roomy = require 'lib.roomy'

local bool = false
love.setDeprecationOutput(bool)
local world = require 'world'
local assets = require 'assets'
local Enemy = require 'src.enemy.enemy'


local battlemanager = require 'src.battlemanager'
_G.battlemanager = battlemanager
_G.bulletspawner = require 'src.bulletspawner'
_G.battlebox = require 'src.battlebox'
local prevMx, prevMy = 0, 0
local game = require 'gameStats'
_G.game = game


local player = game.player
local worldPlayer = require'src.playerOverworld'(100, 32*8)
_G.player = player
_G.worldPlayer = worldPlayer

rManager = require 'lib.roomy'.new()
local testRoom = require 'src.rooms.test.testroom_01'
local battletestRoom = require 'src.rooms.battletestroom_01'


currentRoom = testRoom

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


--table.insert(entities, player)
--table.insert(entities, worldPlayer)




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

    player:mousepressed(x, y, button, istouch)
    textTextbox:continue()
    if textTextbox:is_finished() then
        textTextbox:send("[textspeed=0.3][warble=-5]THIS IS A EXTRA MESSAGE... STRANGE ISINT IT?[/warble][/textspeed]", 256)
    end
 end

function love.update(dt)

    flux.update(dt)
    input:update(dt)

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

     if key == 'r' then
        love.event.quit('restart')
     end

     --DUNGEON FUNCTIONS
     --dungeon:keypressed(key, scancode, isrepeat)

     player:keypressed(key, scancode, isrepeat)
 end

 --TITLE SCREEN
 state.title = {}

local anim8 = require 'lib.anim8'
local titlechoicePosX = 200
local titlechoicePosY = 200
state.title.choices = {
    "START",
    "OPTIONS (NOT IMPLMENTED)",
    "EXIT",
}
state.title.titleYOff = 0
state.title.showChoices = false
state.title.choiceSelected = 1
state.title.titleImage = require ('assets').images.titlelogo

local g = anim8.newGrid(640, 720, state.title.titleImage:getWidth(), state.title.titleImage:getHeight())
state.title.animation = anim8.newAnimation(g('1-2',1), 0.3)



 function state.title:enter(previous, ...)
     -- set up the level
 end
 
 function state.title:update(dt)
    if self.showChoices then
        flux.to(self, 1, {titleYOff = 360})
    end
    self.animation:update(dt)
 end
 
 function state.title:leave(next, ...)
     -- destroy entities and cleanup resources
 end
 
 function state.title:draw()



     love.graphics.setCanvas({canvas, stencil=true})
     love.graphics.clear()
     canvas:setFilter("nearest")
 

    self.animation:draw(self.titleImage, 0, self.titleYOff * -1)

    if self.showChoices == true then
        for i = 1, #self.choices do

            if self.choiceSelected == i then
                love.graphics.setColor(1, 1, 0)
            else
                love.graphics.setColor(1, 1, 1)
            end

            love.graphics.print(self.choices[i], titlechoicePosX, (titlechoicePosY + (i-1) * 32) - self.titleYOff + 360)

            love.graphics.setColor(1, 1, 1)
        end
    end
   --return canvas to normal
   love.graphics.setCanvas()


   love.graphics.setBlendMode("alpha", "premultiplied")
   love.graphics.draw(canvas, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, scale, scale, canvas:getWidth() / 2, canvas:getHeight() / 2)
   love.graphics.setBlendMode("alpha")
 end

 function state.title:keypressed(key)

    if self.showChoices == true then

        if key == 'space' then
            if self.choiceSelected == 1 then
                rManager:enter(state.gameplay)
            end
            if self.choiceSelected == 2 then
                rManager:enter(state.gameplay)
            end
            if self.choiceSelected == 3 then
                love.event.quit()
            end
        end

        if key == 'w' then
            local sound = ripple.newSound(require'assets'.sounds.text1)
            sound:play()
            self.choiceSelected = self.choiceSelected - 1

            if self.choiceSelected <= 0 then
                self.choiceSelected = #self.choices
            end
        end

        if key == 's' then
            local sound = ripple.newSound(require'assets'.sounds.text1)
            sound:play()
            self.choiceSelected = self.choiceSelected + 1

            if self.choiceSelected >= #self.choices + 1 then
                self.choiceSelected = 1
            end
        end
    else
        if key == 'space' then
            self.showChoices = true
        end
    end
 end


 local gameDrawAlpha = 0
--GAMEPLAY
 state.gameplay = {}

 function state.gameplay:enter(previous, ...)
    gameDrawAlpha = 1
    currentRoom:enter()
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
    
    --player.x = player.x + (mx- prevMx)
    --player.y = player.y + (my - prevMy)
    player.mx = mx
    player.my = my


    world:update(dt)
    currentRoom:update(dt)
    gameHud:update(dt)

    if gameDrawAlpha > 0 then
        gameDrawAlpha = gameDrawAlpha - dt
    end

    
    
    --Update player
    --player.x = mx - player.mOffX/2
    --player.y = my - player.mOffY/2

    prevMx = mx
    prevMy = my
 
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
      love.graphics.setCanvas({canvas, stencil=true})
      love.graphics.clear()
      canvas:setFilter("nearest")


    currentRoom:draw()
    
    --Draw particles
    local partTab = partTable
    for i = 1, #partTab do
        partTab[i]:draw()
    end

    love.graphics.setColor(0, 0, 0, gameDrawAlpha)
    love.graphics.rectangle('fill', 0, 0, 1000, 1000)
    love.graphics.setColor(1, 1, 1, 1)

    local fps = love.timer.getFPS()
    love.graphics.print(fps)

    --return canvas to normal
    love.graphics.setCanvas()


    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(canvas, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, scale, scale, canvas:getWidth() / 2, canvas:getHeight() / 2)
    love.graphics.setBlendMode("alpha")

 end



 --COLLISION CALLBACKS

 local on_collision_start_handler = function(shape_a, shape_b, contact)
    local normal_x, normal_y = contact:getNormal()
    local x1, y1, x2, y2 = contact:getPositions()
    local object_a = shape_a:getUserData()
    local object_b = shape_b:getUserData()

    if object_a == nil or object_b == nil then

        print("A OBJECT NOT FOUND, ADD THEIR USER DATA")
         return

    end -- no userdata

    if object_a.on_collision_start ~= nil then
        assert(type(object_a.on_collision_start) == "function")
        object_a.on_collision_start(object_a, object_b, normal_x, normal_y, x1, y1, x2, y2)
    end

    if object_b.on_collision_start ~= nil then
        assert(type(object_b.on_collision_start) == "function")
        object_b.on_collision_start(object_b, object_a, normal_x, normal_y, x1, y1, x2, y2)
    end
end

local on_collision_exit_handler = function(shape_a, shape_b, contact)
    local normal_x, normal_y = contact:getNormal()
    local x1, y1, x2, y2 = contact:getPositions()
    local object_a = shape_a:getUserData()
    local object_b = shape_b:getUserData()

    if object_a == nil or object_b == nil then

        print("A OBJECT NOT FOUND, ADD THEIR USER DATA")
         return

    end -- no userdata

    if object_a.on_collision_exit ~= nil then
        assert(type(object_a.on_collision_exit) == "function")
        object_a.on_collision_exit(object_a, object_b, normal_x, normal_y, x1, y1, x2, y2)
    end

    if object_b.on_collision_exit ~= nil then
        assert(type(object_b.on_collision_exit) == "function")
        object_b.on_collision_exit(object_b, object_a, normal_x, normal_y, x1, y1, x2, y2)
    end
end

local collision_presolve_handler = function(shape_a, shape_b, contact)
    local normal_x, normal_y = contact:getNormal()
    local x1, y1, x2, y2 = contact:getPositions()
    local object_a = shape_a:getUserData()
    local object_b = shape_b:getUserData()

    if object_a == nil or object_b == nil then

        print("A OBJECT NOT FOUND, ADD THEIR USER DATA")
         return

    end -- no userdata

    if object_a.collision_presolve ~= nil then
        assert(type(object_a.collision_presolve) == "function")
        object_a.collision_presolve(object_a, object_b, normal_x, normal_y, x1, y1, x2, y2)
    end

    if object_b.collision_presolve ~= nil then
        assert(type(object_b.collision_presolve) == "function")
        object_b.collision_presolve(object_b, object_a, normal_x, normal_y, x1, y1, x2, y2)
    end
end

local collision_postsolve_handler = function(shape_a, shape_b, contact, normalimpulse, tangentimpulse)
    local normal_x, normal_y = contact:getNormal()
    local x1, y1, x2, y2 = contact:getPositions()
    local object_a = shape_a:getUserData()
    local object_b = shape_b:getUserData()

    if object_a == nil or object_b == nil then

        print("A OBJECT NOT FOUND, ADD THEIR USER DATA")
         return

    end -- no userdata

    if object_a.collision_postsolve ~= nil then
        assert(type(object_a.collision_postsolve) == "function")
        object_a.collision_postsolve(object_a, object_b, normal_x, normal_y, x1, y1, x2, y2)
    end

    if object_b.collision_postsolve ~= nil then
        assert(type(object_b.collision_postsolve) == "function")
        object_b.collision_postsolve(object_b, object_a, normal_x, normal_y, x1, y1, x2, y2)
    end
end

world:setCallbacks(on_collision_start_handler, on_collision_exit_handler, collision_presolve_handler, collision_postsolve_handler)


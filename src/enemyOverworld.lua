
local assets = require 'assets'
local encounters = require 'src.encounters'
local battlemanager = require 'src.battlemanager'
local physics = require 'physics'

EnemyOverworld = require 'src.entity':extend()

function EnemyOverworld:new(x, y, id)
    self.x = x
    self.y = y
    self.id = id
    self.image = assets.images.enemies.talkerBun.talkerbun_idle
    self.encounter = battlemanager:NewEncounter(id or 1)
    self.world = require 'world'
    self.body, self.shape = physics.new_rectangle_collider(self.world, 'dynamic', x, y, 16, 16)
    self.shape:setUserData(self)
end

function EnemyOverworld:update()

end

function EnemyOverworld:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return EnemyOverworld
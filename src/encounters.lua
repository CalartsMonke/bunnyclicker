local encounter = {}
local music1 = require 'assets'.music.wegatheme

function encounter.new(id)
    local id = id or 1
    local e = {}
    e.music = nil
        --ENEMY TURNS
        e.possibleAttacks = {}
        e.currentFocusAttack = nil
        e.currentAttackingEnemies = {}
        e.waitingEnemies = {}
        e.enemyAttackTime = 10
        e.enemyAttackTimeMax = 10
        e.timeUntillEnemyAttack = 15
        e.timeUntillEnemyAttackMax = 15
        e.transitionTimeMax = 2
        e.transitionTime = e.transitionTimeMax
        e.detransitionTimeMax = 0.5
        e.detransitionTime = e.detransitionTimeMax


    if id == 1 then

        --TalkerBun(3)
        local e1 = require 'src.enemy.enemyHorizontal'
        local e2 = require 'src.enemy.dasherBun'
        local e3 = require 'src.enemy.hopperBun'
        
        e.enemies = {
            e2(9*32, 5*32, {bulletX = 50, bulletY = 180}),
            e2(12*32, 5*32, {bulletX = 580, bulletY = 180}),
        }
        e.music = music1
    end




    return e
end


return encounter
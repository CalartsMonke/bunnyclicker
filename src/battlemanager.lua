local battlemanager = {
    currentEncounter = {},

    battleActions = {},

    isActive = false,

    highlightedEnemy = nil,
    highlightedEnemyDrawAlpha = 0,

    floatingNumbers = {},

    state = 1,
    states = {
        all = 1,
        focus = 2,
        transition = 3,
        detransition = 4,
    },




}
local pendingWaitingEnemies = {}

local attacks = require 'src.attacks'
local battleRoom = require 'src.rooms.battletestroom_01'
local bulletspawner = _G.bulletspawner
local encounterlist = require 'src.encounters'

function battlemanager:ChangeHighlightedEnemy(enemy)
    if enemy.is then
        if enemy:is(Enemy) then
            self.highlightedEnemyDrawAlpha = 1.5
            self.highlightedEnemy = enemy
        end
    end
end

function battlemanager:NewEncounter(id)
    _G.bulletspawner = require 'src.bulletspawner'

    local encounter = encounterlist.new(id or 1)
    encounter.activeEnemies = encounter.enemies
    encounter.actions = {}
    encounter.manager = self




    --BATTLE LOOP


    --Update status effects
    function encounter:UpdateStatusEffects(dt)


        for i=#self.activeEnemies, 1, -1 do
            local item = self.activeEnemies[i]
        end
    end

    --Update entities
    function encounter:UpdateEntities(dt)


        for i=#self.activeEnemies, 1, -1 do
            local item = self.activeEnemies[i]
            item:update(dt)
        end
        for i=#self.manager.floatingNumbers, 1, -1 do
            local item = self.manager.floatingNumbers[i]
            item:update(dt)
        end
    end
    
    --Process entity action list




    function encounter:update(dt)



        if self.manager.state == self.manager.states.detransition then
            _G.battlebox:TravelToX(10)
            _G.battlebox:TravelToY(10)
            _G.battlebox:TravelToWidth(620)
            _G.battlebox:TravelToHeight(300)
            
            for i=#self.currentAttackingEnemies, 1, -1 do
                local item = table.remove(self.currentAttackingEnemies, i)
                table.insert(self.activeEnemies, item)
            end
            for i=#self.waitingEnemies, 1, -1 do
                local item = table.remove(self.waitingEnemies, i)
                table.insert(self.activeEnemies, item)
            end

            self.detransitionTime = self.detransitionTime - dt

            for i = #self.activeEnemies, 1, -1 do
                local enemy = self.activeEnemies[i]
                flux.to(enemy, 0.2, {x = enemy.fieldX})
                flux.to(enemy, 0.2, {y = enemy.fieldY})
            end

            if self.detransitionTime <= 0 then
                self.detransitionTime = self.detransitionTimeMax
                self.manager.state = self.manager.states.all
                for i = #self.activeEnemies, 1, -1 do
                    local enemy = self.activeEnemies[i]
                    enemy.fieldMode = true
                    enemy.state = enemy.STATES.IDLE
                end
                
            end

        end



        if self.manager.state == self.manager.states.all then
            self.manager.highlightedEnemyDrawAlpha = self.manager.highlightedEnemyDrawAlpha - dt
            self.timeUntillEnemyAttack = self.timeUntillEnemyAttack - dt



            self:UpdateStatusEffects(dt)
            self:UpdateEntities(dt)
        end

        if self.timeUntillEnemyAttack <= 0 then
            self.timeUntillEnemyAttack = self.timeUntillEnemyAttackMax

            --Throw all enemies into a table for waitingEnemies
            for i=#self.activeEnemies, 1, -1 do
                local item = table.remove(self.activeEnemies, i)
                table.insert(self.waitingEnemies, item)
            end


            --MAKE A COUNT VAR
            local ranCount = 0
            repeat
                    --Add enemies to the attacking enemies table from the waitingEnemies table based on a attack that gets chosen from the encounters attack pool (wip)
                local attacknum = math.floor(love.math.random(#self.possibleAttacks)) + ranCount


                if attacknum > #self.possibleAttacks then
                    attacknum = #self.possibleAttacks
                end

                print(attacknum)



                local attackToUse = self.possibleAttacks[attacknum]
                self.currentFocusAttack = attackToUse.attack.fn
                
                local foundRequirements = false
                --Grab enemies from table based on attack requirements
                for i= #attackToUse.attack.enemiesNeeded, 1, -1 do
                    local idneeded = attackToUse.attack.enemiesNeeded[i]

                    local foundItemCheck = false
                    for j = #self.waitingEnemies, 1, -1 do
                        local enemytocheck = self.waitingEnemies[j]

                        if enemytocheck.enemyid == idneeded and enemytocheck.state ~= enemytocheck.STATES.DEAD and foundItemCheck == false then
                            foundItemCheck = true
                            local enemyToAdd = table.remove(self.waitingEnemies, j)
                            enemyToAdd.battleX = enemyToAdd.x
                            enemyToAdd.battleY = enemyToAdd.y
                            table.insert(pendingWaitingEnemies, enemyToAdd)
                        end

                    end

                    if #pendingWaitingEnemies == #attackToUse.attack.enemiesNeeded then
                        foundRequirements = true
                    end
                end
                    ranCount = ranCount + 1
            until foundRequirements == true
            print('RAN COUNT: '..ranCount)

            for i=#pendingWaitingEnemies, 1, -1 do
                local itemToAdd = table.remove(pendingWaitingEnemies, i)

                table.insert(self.currentAttackingEnemies, itemToAdd)
            end
           


            local num = math.ceil(love.math.random(0.1, #self.waitingEnemies))

            
            self.manager.state = self.manager.states.transition
        end

        if self.manager.state == self.manager.states.transition then
            _G.battlebox:TravelToX(200)
            _G.battlebox:TravelToY(100)
            _G.battlebox:TravelToWidth(200)
            _G.battlebox:TravelToHeight(200)
            for i = #self.currentAttackingEnemies, 1, -1 do
                local enemy = self.currentAttackingEnemies[i]
                flux.to(enemy, 0.2, {x = enemy.bulletX})
                flux.to(enemy, 0.2, {y = enemy.bulletY})
            end

            local item = self.currentAttackingEnemies[1]
            item.state = item.STATES.ATTACKING
            self.transitionTime = self.transitionTime - dt

            if self.transitionTime <= 0 then

                for i = #self.currentAttackingEnemies, 1, -1 do
                    local enemy = self.currentAttackingEnemies[i]
                    enemy.fieldMode = false
                end
                self.transitionTime = self.transitionTimeMax
                self.manager.state = self.manager.states.focus
                _G.bulletspawner.attackFunction = self.currentFocusAttack
            end
        end

        if self.manager.state == self.manager.states.focus then
            self.enemyAttackTime = self.enemyAttackTime - dt

            for i=1, #self.currentAttackingEnemies do
                local item = self.currentAttackingEnemies[i]
                item:update(dt)
            end
            _G.bulletspawner:update(dt)

            if self.enemyAttackTime <= 0 then
                self.manager.state = self.manager.states.detransition
                self.enemyAttackTime = self.enemyAttackTimeMax
                _G.bulletspawner:Reset()
            end

        end

        _G.battlebox:update(dt)
    end

    function encounter:draw()
        for i=#self.activeEnemies, 1, -1 do
            local item = self.activeEnemies[i]

            local barlength = (item.hp / item.hpMax ) * 32
    
            if item.hp > 0 then
                if item == self.manager.highlightedEnemy then
                    love.graphics.setFont(require'assets'.fonts.m5x7)
                    love.graphics.setColor(1, 1, 1, self.manager.highlightedEnemyDrawAlpha)
                    love.graphics.print("H:", item.x - 9, item.y - 16)
                    love.graphics.setColor(0.2, 0.2 , 0.2, self.manager.highlightedEnemyDrawAlpha)
                    love.graphics.rectangle('fill', item.x, item.y - 9, 32, 4)
                    love.graphics.setColor(1,1,1, self.manager.highlightedEnemyDrawAlpha)
                    love.graphics.rectangle('fill', item.x, item.y - 9, barlength, 4)
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.setFont(require'assets'.fonts.ns13)
                end
            end

            love.graphics.setFont(require'assets'.fonts.ns13)
            item:draw()
        end

        for i=#self.currentAttackingEnemies, 1, -1 do
            local item = self.currentAttackingEnemies[i]
            item:draw()
        end

        for i=#self.manager.floatingNumbers, 1, -1 do
            local item = self.manager.floatingNumbers[i]
            item:draw()
        end
        _G.battlebox:draw()
        _G.bulletspawner:draw()
    end
    

    return encounter

end

function battlemanager:AddToActions(action)
    local actions = self.battleActions
end

function battlemanager:NewAction()
    local action = {
        damage = 1,
        heal = 0,
        status = nil,
        owner = nil,
        target = nil,
        fn = nil,
    }

    return action
end

function battlemanager:GetCurrentEncounter()
    return self.currentEncounter
end

function battlemanager:LoadEncounter(encounter)
    self.currentEncounter = encounter

    --ADD ENEMY ATTACKS TO THE POOL
    for i = #encounter.enemies, 1, -1 do
        local enemy = encounter.enemies[i]
        local list = encounter.possibleAttacks

        for j = #enemy.attacks, 1, -1 do
            local attack = enemy.attacks[j]
            table.insert(list, attack)
            print(attack.name)
        end
    end



    currentRoom:leave()
    currentRoom = battleRoom
    currentRoom:enter()

    self.currentPlayingMusic = self.currentEncounter.music:play()
    self.currentPlayingMusic.volume = 0.7
    self.currentPlayingMusic.loop = true



end

return battlemanager
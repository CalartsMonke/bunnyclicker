

Collectible = Entity:extend()

function Collectible:new()
    
end


function Collectible:collect()
    if self.isActive == nil or self.isActive == true then
    self.state = self.states[2]
    print("THIS ITEM WAS COLLECTED")
    end
end

return Collectible
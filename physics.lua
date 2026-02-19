local physics = {}


function physics.newWorld(xgrav, ygrav)

    local world = love.physics.newWorld(
    xgrav or 0,  -- x-gravity
    ygrav or 0   -- y-gravity
)

    return world
end

--- @brief create body with polygon shape
--- @param world love.physics.World
--- @param type love.physics.BodyType
--- @param center_x number
--- @param center_y number
--- @param local_vertices Table<number> vertex x and y coordinates, flat, local coordinates
--- @return love.physics.Body, love.physics.Shape
function physics.new_polygon_collider(world, type, center_x, center_y, local_vertices)
    -- create body
    local body = love.physics.newBody(world, center_x, center_y, type)

    -- create shape, this attaches the shape to the body
    local shape = love.physics.newPolygonShape(body, local_vertices)

    return body, shape
end

--- @brief create body with rect shape (shorthand for polygon with just width and height)
--- @param world love.physics.World
--- @param type love.physics.BodyType
--- @param originx number 
--- @param originy number
--- @param width number --width of the rectangle rightwards
--- @param height number --height of the rectangle downwards
--- @return love.physics.Body, love.physics.Shape
function physics.new_rectangle_collider(world, type, originx, originy, width, height)

    local x, y, w, h = 0, 0, width, height -- local coordinates, not world coordinates
    local polygon = {
        x + 0, y + 0,
        x + w, y + 0,
        x + w, y + h,
        x + 0, y + h
    }

    -- create body
    local body = love.physics.newBody(world, originx, originy, type)

    -- create shape, this attaches the shape to the body
    local shape = love.physics.newPolygonShape(body, polygon)

    return body, shape
end

--- @brief create body with perfect circle shape
--- @param world love.physics.World
--- @param type love.physics.BodyType
--- @param center_x number
--- @param center_y number
--- @param radius number
--- @return love.physics.Body, love.physics.Shape
function physics.new_circle_collider(world, type, center_x, center_y, radius, data)
    local userdata = data or nil

    local body = love.physics.newBody(world, center_x, center_y, type)
    body:setUserData(userdata)
    local shape = love.physics.newCircleShape(body, radius)
    return body, shape
end

--- @brief debug drawing for bodies, requires them to have been created using physics.new_*_collider
function physics.draw_body(body)
    local x, y = body:getPosition()

    love.graphics.push()
    love.graphics.translate(x, y)
    for _, shape in pairs(body:getShapes()) do
        if shape:type() == "CircleShape" then
            local radius = shape:getRadius()
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.circle("line", 0, 0, radius)
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.circle("fill", 0, 0, radius)
        elseif shape:type() == "PolygonShape" then
            local vertices = { shape:getPoints() }
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.polygon("line", vertices)
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.polygon("fill", vertices)
        end
    end
    love.graphics.pop()
end

return physics
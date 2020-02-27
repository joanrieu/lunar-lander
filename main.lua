local entities = {
    ship = {
        ship = {
            x = 0.5,
            y = 0.9,
            vx = 0,
            vy = 0,
            ax = 0,
            ay = 0
        }
    },
    wall = {
        id = "wall",
        wall = {
            x0 = 0,
            y0 = 0,
            x1 = 1,
            y1 = 0.5
        }
    }
}

local systems = {
    ship = {
        update = function(dt)
            for id, e in pairs(entities) do
                if e.ship then
                    local booster
                    if love.keyboard.isDown("space") then booster = 1 else booster = 0 end
                    e.ship.ax = 0
                    e.ship.ay = (-0.002 + booster * 0.004) * dt
                    e.ship.vx = e.ship.vx + e.ship.ax
                    e.ship.vy = e.ship.vy + e.ship.ay
                    e.ship.x = e.ship.x + e.ship.vx
                    e.ship.y = e.ship.y + e.ship.vy
                end
            end
        end,
        draw = function()
            for id, e in pairs(entities) do
                if e.ship then
                    love.graphics.push()
                    love.graphics.translate(size * e.ship.x, -size * (e.ship.y - 1))
                    love.graphics.line(0, 0, 10, 10, 0, 10, 0, 0)
                    love.graphics.pop()
                end
            end
        end
    },
    wall = {
        update = function(dt)
            for id, e in pairs(entities) do
                if e.wall then
                    local dx = e.wall.x1 - e.wall.x0
                    if dx > 0.03 then
                        entities[e.id] = nil
                        local dy = e.wall.y1 - e.wall.y0
                        local xm = (e.wall.x0 + e.wall.x1) / 2
                        local ym = (e.wall.y0 + e.wall.y1) / 2 + (math.random() - 0.5) * 0.5 * dy
                        local left = {
                            id = e.id .. 0,
                            wall = {
                                x0 = e.wall.x0,
                                y0 = e.wall.y0,
                                x1 = xm,
                                y1 = ym
                            }
                        }
                        entities[left.id] = left
                        local right = {
                            id = e.id .. 1,
                            wall = {
                                x0 = xm,
                                y0 = ym,
                                x1 = e.wall.x1,
                                y1 = e.wall.y1
                            }
                        }
                        entities[right.id] = right
                    end
                end
            end
        end,
        draw = function()
            for id, e in pairs(entities) do
                if e.wall then
                    love.graphics.push()
                    love.graphics.line(size * e.wall.x0, -size * (e.wall.y0 - 1), size * e.wall.x1, -size * (e.wall.y1 - 1))
                    love.graphics.pop()
                end
            end
        end
    },
    quit = {
        update = function()
            if love.keyboard.isDown("escape") then
                love.event.quit()
            end
        end
    }
}

function love.load()
    size = love.graphics.getDimensions()
    math.randomseed(os.time())
end

function love.update(dt)
    for k, v in pairs(systems) do
        if v.update then
            v.update(dt)
        end
    end
end

function love.draw()
    for k, v in pairs(systems) do
        if v.draw then
            v.draw()
        end
    end
end

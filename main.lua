local entities = {
    ship = {
        transform = {
            x = 0.5,
            y = 0.9
        },
        body = {
            vx = 0,
            vy = 0,
            ax = 0,
            ay = 0
        },
        ship = {}
    },
    wall = {
        id = "wall",
        transform = {
            x = 0,
            y = 0,
            w = 1,
            h = 0.5
        },
        wall = {}
    }
}

local systems = {
    ship = {
        update = function(dt)
            for id, e in pairs(entities) do
                if e.ship then
                    local booster
                    if love.keyboard.isDown("space") then booster = 1 else booster = 0 end
                    e.body.ax = 0
                    e.body.ay = -0.2 + booster * 0.4
                end
            end
        end,
        draw = function()
            for id, e in pairs(entities) do
                if e.ship then
                    love.graphics.push()
                    love.graphics.translate(e.transform.x, e.transform.y)
                    love.graphics.line(0, 0, 0.05, 0.05, 0, 0.05, 0, 0)
                    love.graphics.pop()
                end
            end
        end
    },
    body = {
        update = function(dt)
            for id, e in pairs(entities) do
                if e.body then
                    e.body.vx = e.body.vx + e.body.ax * dt
                    e.body.vy = e.body.vy + e.body.ay * dt
                    e.transform.x = e.transform.x + e.body.vx * dt
                    e.transform.y = e.transform.y + e.body.vy * dt
                end
            end
        end
    },
    wall = {
        update = function(dt)
            for id, e in pairs(entities) do
                if e.wall then
                    if e.transform.w > 1 / size then
                        entities[e.id] = nil
                        local hw = e.transform.w / 2
                        local hh = e.transform.h / 2 * (1 + (math.random() - 0.5) / 2)
                        local left = {
                            id = e.id .. 0,
                            transform = {
                                x = e.transform.x,
                                y = e.transform.y,
                                w = hw,
                                h = hh
                            },
                            wall = {}
                        }
                        entities[left.id] = left
                        local right = {
                            id = e.id .. 1,
                            transform = {
                                x = e.transform.x + hw,
                                y = e.transform.y + hh,
                                w = e.transform.w - hw,
                                h = e.transform.h - hh
                            },
                            wall = {}
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
                    love.graphics.line(
                        e.transform.x,
                        e.transform.y,
                        e.transform.x + e.transform.w,
                        e.transform.y + e.transform.h
                    )
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
    love.graphics.scale(size, -size)
    love.graphics.translate(0, -1)
    love.graphics.setLineWidth(1 / size)
    for k, v in pairs(systems) do
        if v.draw then
            v.draw()
        end
    end
end

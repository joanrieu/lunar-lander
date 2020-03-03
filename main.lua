local entities = {
    ship = {
        transform = {
            x = 0.5,
            y = 0.9,
            w = .05,
            h = .07
        },
        body = {
            vx = 0,
            vy = 0,
            ax = 0,
            ay = 0
        },
        ship = {
            fuel = 3,
            fuelMax = 3,
            booster = false
        }
    },
    booster1 = {
        booster = {
            throttle = 0,
            ax = 0,
            ay = 0.4,
            key = "up"
        }
    },
    booster2 = {
        booster = {
            throttle = 0,
            ax = 0.1,
            ay = 0,
            key = "right"
        }
    },
    booster3 = {
        booster = {
            throttle = 0,
            ax = -0.1,
            ay = 0,
            key = "left"
        }
    },
    fuelGauge = {
        transform = {
            x = 0.02,
            y = 0.94,
            w = 0.2,
            h = 0.04
        },
        fuelGauge = {}
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
                    local gravity = -0.2
                    e.body.ax = 0
                    e.body.ay = gravity
                    for i = 1, 3 do
                        local booster = entities["booster" .. i].booster
                        e.body.ax = e.body.ax + booster.throttle * booster.ax
                        e.body.ay = e.body.ay + booster.throttle * booster.ay
                    end
                end
            end
        end,
        draw = function()
            for id, e in pairs(entities) do
                if e.ship then
                    love.graphics.push()
                    love.graphics.translate(e.transform.x, e.transform.y)
                    local hw = e.transform.w / 2
                    local hh = e.transform.h / 2
                    love.graphics.line(
                        -hw, -hh,
                        -hw, 0,
                        -hw / 2, hh,
                        hw / 2, hh,
                        hw, 0,
                        hw, -hh,
                        -hw, -hh
                    )
                    if entities.booster1.booster.throttle > 0 then
                        love.graphics.line(
                            -hw / 2, -hh,
                            -hw / 3, -hh * 1.5,
                            -hw / 4, -hh,
                            0, -hh * 2,
                            hw / 4, -hh,
                            hw / 3, -hh * 1.5,
                            hw / 2, -hh
                        )
                    end
                    love.graphics.pop()
                end
            end
        end
    },
    booster = {
        update = function(dt)
            for id, e in pairs(entities) do
                if e.booster then
                    if love.keyboard.isDown(e.booster.key) then
                        e.booster.throttle = 1
                        local consumption = math.abs(e.booster.ax) + math.abs(e.booster.ay)
                        entities.ship.ship.fuel = entities.ship.ship.fuel - consumption * dt
                        if entities.ship.ship.fuel < 0 then
                            entities.ship.ship.fuel = 0
                            e.booster.throttle = 0
                        end
                    else
                        e.booster.throttle = 0
                    end
                end
            end
        end
    },
    fuelGauge = {
        draw = function()
            for id, e in pairs(entities) do
                if e.fuelGauge then
                    love.graphics.rectangle(
                        "line",
                        e.transform.x,
                        e.transform.y,
                        e.transform.w,
                        e.transform.h
                    )
                    local padding = e.transform.h / 6
                    local ratio = entities.ship.ship.fuel / entities.ship.ship.fuelMax
                    love.graphics.rectangle(
                        "fill",
                        e.transform.x + padding,
                        e.transform.y + padding,
                        (e.transform.w - 2 * padding) * ratio,
                        e.transform.h - 2 * padding
                    )
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
                        local hh = e.transform.h / 2 * (1 + (math.random() - 0.5))
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

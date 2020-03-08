function titleScreen()
    return {
        titleScreen = {
            titleScreen = {}
        }
    }
end

function newGame()
    return {
        ship = {
            transform = {
                x = 0.5,
                y = 0.9,
                w = 0.05,
                h = 0.07
            },
            body = {
                vx = 0,
                vy = 0,
                ax = 0,
                ay = 0
            },
            ship = {
                fuel = 3,
                fuelMax = 3
            }
        },
        booster1 = {
            transform = {
                x = 0,
                y = -0.023,
                w = 0.025,
                h = 0.035,
                angle = 0
            },
            booster = {
                throttle = 0,
                ax = 0,
                ay = 0.4,
                key = "up",
                main = true
            }
        },
        booster2 = {
            transform = {
                x = -0.025,
                y = 0.003,
                w = 0.015,
                h = 0.020,
                angle = -math.pi / 2
            },
            booster = {
                throttle = 0,
                ax = 0.1,
                ay = 0,
                key = "right",
                main = false
            }
        },
        booster3 = {
            transform = {
                x = 0.025,
                y = 0.003,
                w = 0.015,
                h = 0.020,
                angle = math.pi / 2
            },
            booster = {
                throttle = 0,
                ax = -0.1,
                ay = 0,
                key = "left",
                main = false
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
        ground = {
            ground = {
                created = false
            }
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
        },
        starField = {
            stars = {
                count = 100,
                points = {}
            }
        }
    }
end

local entities = titleScreen()

local systems = {
    titleScreen = {
        updateAll = function(id, e, dt)
            if love.keyboard.isDown("return") then
                entities = newGame()
            end
        end,
        draw = function(id, e)
            if e.titleScreen then
                love.graphics.push()
                love.graphics.scale(1 / 16, 1 / 12)
                love.graphics.translate(1.5, 8)
                -- L
                love.graphics.line(0, 1, 0, 0, 1, 0)
                love.graphics.translate(2, 0)
                -- U
                love.graphics.line(0, 1, 0, 0, 1, 0, 1, 1)
                love.graphics.translate(2, 0)
                -- N
                love.graphics.line(0, 0, 0, 1, 1, 1, 1, 0)
                love.graphics.translate(2, 0)
                -- A
                love.graphics.line(0, 0, 0, 0.5, 0.2, 1, 0.8, 1, 1, 0.5, 1, 0)
                love.graphics.line(0.3, 0.5, 0.7, 0.5)
                love.graphics.translate(2, 0)
                -- R
                love.graphics.line(0, 0, 0, 1, 1, 1, 1, 0.7, 0, 0.5)
                love.graphics.line(0.5, 0.6, 1, 0)
                love.graphics.translate(-6, -2)
                -- L
                love.graphics.line(0, 1, 0, 0, 1, 0)
                love.graphics.translate(2, 0)
                -- A
                love.graphics.line(0, 0, 0, 0.5, 0.2, 1, 0.8, 1, 1, 0.5, 1, 0)
                love.graphics.line(0.3, 0.5, 0.7, 0.5)
                love.graphics.translate(2, 0)
                -- N
                love.graphics.line(0, 0, 0, 1, 1, 1, 1, 0)
                love.graphics.translate(2, 0)
                -- D
                love.graphics.line(0, 1, 1, 1, 1, 0, 0, 0)
                love.graphics.line(0.2, 0, 0.2, 1)
                love.graphics.translate(2, 0)
                -- E
                love.graphics.line(1, 1, 0, 1, 0, 0, 1, 0)
                love.graphics.line(0, 0.5, 0.4, 0.5)
                love.graphics.translate(2, 0)
                -- R
                love.graphics.line(0, 0, 0, 1, 1, 1, 1, 0.7, 0, 0.5)
                love.graphics.line(0.5, 0.6, 1, 0)
                love.graphics.pop()
            end
        end
    },
    ship = {
        update = function(id, e, dt)
            if e.ship then
                e.body.ax = 0
                e.body.ay = 0
                for i = 1, 3 do
                    local booster = entities["booster" .. i].booster
                    e.body.ax = e.body.ax + booster.throttle * booster.ax
                    e.body.ay = e.body.ay + booster.throttle * booster.ay
                end
                if e.collision then
                    entities.ship = nil
                    entities.booster1 = nil
                    entities.booster2 = nil
                    entities.booster3 = nil
                    entities.fuelGauge = nil
                    local t = e.collision.target.transform
                    entities.explosion = {
                        transform = {
                            x = t.x,
                            y = t.y
                        },
                        explosion = {
                            time = 0
                        }
                    }
                end
            end
        end,
        draw = function(id, e)
            if e.ship then
                local t = e.transform
                love.graphics.push()
                love.graphics.translate(t.x, t.y)
                local oldColorR, oldColorG, oldColorB, oldColorA = love.graphics.getColor()
                -- guides
                local xx = t.w / 12
                local yy = t.h / 12
                local xTop = 3 * xx
                local xBottom = 6 * xx
                local xLegStart = 4 * xx
                local xLegEnd = 5 * xx -- reused in shipPadCollider.update
                local yTop = 6 * yy
                local yAngle = yy
                local yBottom = -4 * yy -- reused in booster1.transform
                local yLeg = -6 * yy
                -- body
                local body = {
                    -xBottom, yBottom, -- bottom left
                    -xBottom, yAngle, -- angle left
                    -xTop, yTop, -- top left
                    xTop, yTop, -- top right
                    xBottom, yAngle, -- angle right
                    xBottom, yBottom, -- bottom right
                }
                love.graphics.setColor(0, 0, 0)
                love.graphics.polygon("fill", body)
                love.graphics.setColor(1, 1, 1)
                love.graphics.polygon("line", body)
                -- leg left
                love.graphics.line(
                    -xLegStart, yBottom,
                    -xLegEnd, yLeg
                )
                -- leg right
                love.graphics.line(
                    xLegStart, yBottom,
                    xLegEnd, yLeg
                )
                love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
                love.graphics.pop()
            end
        end
    },
    booster = {
        update = function(id, e, dt)
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
        end,
        draw = function(id, e)
            if e.booster and e.booster.throttle > 0 then
                love.graphics.push()
                love.graphics.translate(entities.ship.transform.x, entities.ship.transform.y)
                local t = e.transform
                love.graphics.translate(t.x, t.y)
                love.graphics.rotate(t.angle)
                local oldColorR, oldColorG, oldColorB, oldColorA = love.graphics.getColor()
                love.graphics.setColor(1, math.random(), 0)
                local rand = math.random() * 0.5 + 0.5
                if e.booster.main then
                    love.graphics.polygon(
                        "fill",
                        -t.w / 2, 0,
                        -t.w / 3, -t.h / 2 * rand,
                        -t.w / 4, 0
                    )
                    love.graphics.polygon(
                        "fill",
                        -t.w / 4, 0,
                        0, -t.h * rand,
                        t.w / 4, 0
                    )
                    love.graphics.polygon(
                        "fill",
                        t.w / 4, 0,
                        t.w / 3, -t.h / 2 * rand,
                        t.w / 2, 0
                    )
                else
                    love.graphics.polygon(
                        "fill",
                        -t.w / 2, 0,
                        0, -t.h / 2 * rand,
                        t.w / 2, 0
                    )
                end
                love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
                love.graphics.pop()
            end
        end
    },
    fuelGauge = {
        draw = function(id, e)
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
    },
    body = {
        update = function(id, e, dt)
            if e.body then
                local gravity = e.body.grounded and 0 or -0.2
                e.body.vx = e.body.vx + e.body.ax * dt
                e.body.vy = e.body.vy + (e.body.ay + gravity) * dt
                if e.body.grounded then
                    if e.body.vy <= 0 then
                        e.body.vx = 0
                        e.body.vy = 0
                    else
                        e.body.grounded = false
                    end
                end
                e.transform.x = e.transform.x + e.body.vx * dt
                e.transform.y = e.transform.y + e.body.vy * dt
            end
        end
    },
    shipWallCollider = {
        update = function(id, e, dt)
            if e.ship then
                local t = e.transform
                local distanceMax = 1 / 0
                local targetMax = nil
                for id2, e2 in pairs(entities) do
                    if e2.wall then
                        local t2 = e2.transform
                        local distance = math.sqrt((t.x - t2.x) ^ 2 + (t.y - t2.y) ^ 2)
                        if distance < distanceMax then
                            distanceMax = distance
                            targetMax = e2
                        end
                    end
                end
                if distanceMax < math.sqrt(t.w ^ 2 + t.h ^ 2) / 2 then
                    e.collision = {
                        target = targetMax
                    }
                end
            end
        end
    },
    shipPadCollider = {
        updateAll = function(dt)
            if entities.ship and entities.pad then
                local s = entities.ship.transform
                local p = entities.pad.transform

                -- landing conditions
                local dx = math.abs(s.x - p.x)
                local dy = math.abs((s.y - s.h / 2) - p.y)
                local v = math.sqrt(entities.ship.body.vx ^ 2 + entities.ship.body.vy ^ 2)
                local offsetOkay = dx < (p.w - s.w * 10 / 12) / 2
                local altitudeOkay = dy < 0.001
                local speedOkay = v < 0.08 and entities.ship.body.vy <= 0
                local isLanding = offsetOkay and altitudeOkay and speedOkay

                -- rectangle collision check
                local dx = math.abs(s.x - p.x)
                local dy = math.abs(s.y - (p.y - p.h / 2))
                local isColliding = dx < (s.w + p.w) / 2 and dy < (s.h + p.h) / 2

                if isLanding then
                    entities.ship.body.grounded = true
                    entities.ship.transform.y = s.h / 2 + entities.pad.transform.y
                elseif isColliding then
                    entities.ship.collision = {
                        target = entities.pad
                    }
                end
            end
        end
    },
    wall = {
        updateAll = function(dt)
            if entities.ground and not entities.ground.ground.created then
                entities.ground.ground.created = true
                for id, e in pairs(entities) do
                    local t = e.transform
                    if e.wall and t.w > 1 / size then
                        entities.ground.ground.created = false
                        entities[e.id] = nil
                        local hw = t.w / 2
                        local hh = t.h / 2 * (1 + (math.random() - 0.5))
                        local left = {
                            id = e.id .. 0,
                            transform = {
                                x = t.x,
                                y = t.y,
                                w = hw,
                                h = hh
                            },
                            wall = {}
                        }
                        entities[left.id] = left
                        local right = {
                            id = e.id .. 1,
                            transform = {
                                x = t.x + hw,
                                y = t.y + hh,
                                w = t.w - hw,
                                h = t.h - hh
                            },
                            wall = {}
                        }
                        entities[right.id] = right
                    end
                end
            end
        end,
        draw = function(id, e)
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
    },
    explosion = {
        update = function(id, e, dt)
            if e.explosion then
                e.explosion.time = e.explosion.time + dt
                if (e.explosion.time > 2) then
                    entities = titleScreen()
                end
            end
        end,
        draw = function(id, e)
            if e.explosion then
                local oldLineWidth = love.graphics.getLineWidth()
                local t = e.transform
                love.graphics.setLineWidth(0.5)
                local oldColorR, oldColorG, oldColorB, oldColorA = love.graphics.getColor()
                love.graphics.setColor(1, 2 * e.explosion.time, 0)
                love.graphics.circle("line", t.x, t.y, 3 * e.explosion.time)
                love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
                love.graphics.setLineWidth(oldLineWidth)
            end
        end
    },
    pad = {
        updateAll = function()
            if not entities.pad and entities.ground and entities.ground.ground.created then
                local ground = {}
                for id, e in pairs(entities) do
                    local t = e.transform
                    if e.wall and t.x > 0.2 and t.x < 0.8 then
                        ground[#ground + 1] = e
                    end
                end
                local t = ground[math.random(1, #ground)].transform
                entities.pad = {
                    transform = {
                        x = t.x,
                        y = t.y + 0.05,
                        w = 0.07,
                        h = 0.05
                    },
                    pad = {}
                }
            end
        end,
        draw = function(id, e)
            if e.pad then
                local t = e.transform
                local oldLineWidth = love.graphics.getLineWidth()
                love.graphics.setLineWidth(2 * oldLineWidth)
                love.graphics.line(t.x - t.w / 2, t.y, t.x + t.w / 2, t.y)
                love.graphics.line(t.x, t.y, t.x, t.y - t.h)
                love.graphics.setLineWidth(oldLineWidth)
            end
        end
    },
    stars = {
        update = function(id, e, dt)
            if e.stars and entities.ground.ground.created then
                while #e.stars.points < e.stars.count do
                    local x = math.random()
                    local y = math.random()
                    local distanceMin = 1 / 0
                    local heightMin = 0
                    for id2, e2 in pairs(entities) do
                        if e2.wall then
                            local distance = math.abs(e2.transform.x - x)
                            if distance < distanceMin then
                                distanceMin = distance
                                heightMin = e2.transform.y
                            end
                        end
                    end
                    y = y + heightMin
                    e.stars.points[#e.stars.points + 1] = { x, y }
                end
            end
        end,
        draw = function(id, e)
            if e.stars then
                love.graphics.points(e.stars.points)
            end
        end
    },
    quit = {
        updateAll = function()
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
        if v.updateAll then
            v.updateAll(dt)
        elseif v.update then
            for id, e in pairs(entities) do
                v.update(id, e, dt)
            end
        end
    end
end

function love.draw()
    love.graphics.scale(size, -size)
    love.graphics.translate(0, -1)
    love.graphics.setLineWidth(1 / size)
    for k, v in pairs(systems) do
        if v.drawAll then
            v.drawAll()
        elseif v.draw then
            for id, e in pairs(entities) do
                v.draw(id, e)
            end
        end
    end
end

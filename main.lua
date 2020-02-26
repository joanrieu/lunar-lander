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

function love.load()
    size = love.graphics.getDimensions()
    math.randomseed(os.time())
end

function love.update(dt)
    for k, v in pairs(entities) do
        if v.ship then update_ship(v, dt) end
        if v.wall then update_wall(v, dt) end
    end
end

function love.draw()
    for k, v in pairs(entities) do
        if v.ship then render_ship(v) end
        if v.wall then render_wall(v) end
    end
end

function update_ship(self, dt)
    local booster
    if love.keyboard.isDown("space") then booster = 1 else booster = 0 end
    self.ship.ax = 0
    self.ship.ay = (-0.002 + booster * 0.004) * dt
    self.ship.vx = self.ship.vx + self.ship.ax
    self.ship.vy = self.ship.vy + self.ship.ay
    self.ship.x = self.ship.x + self.ship.vx
    self.ship.y = self.ship.y + self.ship.vy
end

function render_ship(self)
    love.graphics.push()
    love.graphics.translate(size * self.ship.x, -size * (self.ship.y - 1))
    love.graphics.line(0, 0, 10, 10, 0, 10, 0, 0)
    love.graphics.pop()
end

function update_wall(self)
    local dx = self.wall.x1 - self.wall.x0
    if dx > 0.03 then
        entities[self.id] = nil
        local dy = self.wall.y1 - self.wall.y0
        local xm = (self.wall.x0 + self.wall.x1) / 2
        local ym = (self.wall.y0 + self.wall.y1) / 2 + (math.random() - 0.5) * 0.5 * dy
        local left = {
            id = self.id .. 0,
            wall = {
                x0 = self.wall.x0,
                y0 = self.wall.y0,
                x1 = xm,
                y1 = ym
            }
        }
        entities[left.id] = left
        local right = {
            id = self.id .. 1,
            wall = {
                x0 = xm,
                y0 = ym,
                x1 = self.wall.x1,
                y1 = self.wall.y1
            }
        }
        entities[right.id] = right
    end
end

function render_wall(self)
    love.graphics.push()
    love.graphics.line(size * self.wall.x0, -size * (self.wall.y0 - 1), size * self.wall.x1, -size * (self.wall.y1 - 1))
    love.graphics.pop()
end

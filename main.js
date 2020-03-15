const love = new Love();

const size = 600;

function titleScreen() {
  return {
    titleScreen: {
      titleScreen: {
        time: 0
      }
    },
    starField: {
      stars: {
        count: 100,
        points: []
      }
    }
  };
}

function newGame() {
  return {
    ship: {
      transform: {
        x: 0.5,
        y: 0.9,
        w: 0.05,
        h: 0.07
      },
      body: {
        vx: 0,
        vy: 0,
        ax: 0,
        ay: 0
      },
      ship: {
        fuel: 3,
        fuelMax: 3
      }
    },
    booster1: {
      transform: {
        x: 0,
        y: -0.023,
        w: 0.025,
        h: 0.035,
        angle: 0
      },
      booster: {
        throttle: 0,
        ax: 0,
        ay: 0.4,
        key: "ArrowUp",
        main: true
      }
    },
    booster2: {
      transform: {
        x: -0.025,
        y: 0.003,
        w: 0.015,
        h: 0.02,
        angle: -Math.PI / 2
      },
      booster: {
        throttle: 0,
        ax: 0.1,
        ay: 0,
        key: "ArrowRight",
        main: false
      }
    },
    booster3: {
      transform: {
        x: 0.025,
        y: 0.003,
        w: 0.015,
        h: 0.02,
        angle: Math.PI / 2
      },
      booster: {
        throttle: 0,
        ax: -0.1,
        ay: 0,
        key: "ArrowLeft",
        main: false
      }
    },
    fuelGauge: {
      transform: {
        x: 0.02,
        y: 0.94,
        w: 0.2,
        h: 0.04
      },
      fuelGauge: {}
    },
    ground: {
      ground: {
        created: false
      }
    },
    wall: {
      id: "wall",
      transform: {
        x: 0,
        y: 0,
        w: 1,
        h: 0.5
      },
      wall: {}
    },
    starField: {
      stars: {
        count: 100,
        points: []
      }
    }
  };
}

let entities = titleScreen();

const font = {
  A() {
    love.graphics.line(0, 0, 0, 0.5, 0.2, 1, 0.8, 1, 1, 0.5, 1, 0);
    love.graphics.line(0.3, 0.5, 0.7, 0.5);
    love.graphics.translate(2, 0);
  },
  B() {
    love.graphics.line(0.5, 0.5, 0.8, 1, 0, 1, 0, 0, 1, 0, 0.5, 0.5);
    love.graphics.translate(2, 0);
  },
  C() {
    love.graphics.line(1, 1, 0, 1, 0, 0, 1, 0);
    love.graphics.translate(2, 0);
  },
  D() {
    love.graphics.line(0, 1, 1, 1, 1, 0, 0, 0);
    love.graphics.line(0.2, 0, 0.2, 1);
    love.graphics.translate(2, 0);
  },
  E() {
    love.graphics.line(1, 1, 0, 1, 0, 0, 1, 0);
    love.graphics.line(0, 0.5, 0.4, 0.5);
    love.graphics.translate(2, 0);
  },
  H() {
    love.graphics.line(0, 0, 0, 1);
    love.graphics.line(1, 1, 1, 0);
    love.graphics.line(0, 0.5, 1, 0.5);
    love.graphics.translate(2, 0);
  },
  I() {
    love.graphics.line(0, 1, 1, 1);
    love.graphics.line(0.5, 1, 0.5, 0);
    love.graphics.line(0, 0, 1, 0);
    love.graphics.translate(2, 0);
  },
  L() {
    love.graphics.line(0, 1, 0, 0, 1, 0);
    love.graphics.translate(2, 0);
  },
  N() {
    love.graphics.line(0, 0, 0, 1, 1, 1, 1, 0);
    love.graphics.translate(2, 0);
  },
  O() {
    love.graphics.line(0, 0, 1, 0, 1, 1, 0, 1, 0, 0);
    love.graphics.translate(2, 0);
  },
  P() {
    love.graphics.line(0, 0, 0, 1, 1, 1, 1, 0.7, 0, 0.5);
    love.graphics.translate(2, 0);
  },
  R() {
    love.graphics.line(0, 0, 0, 1, 1, 1, 1, 0.7, 0, 0.5);
    love.graphics.line(0.5, 0.6, 1, 0);
    love.graphics.translate(2, 0);
  },
  S() {
    love.graphics.line(1, 1, 0, 1, 0, 0.5, 1, 0.5, 1, 0, 0, 0);
    love.graphics.translate(2, 0);
  },
  T() {
    love.graphics.line(0, 1, 1, 1);
    love.graphics.line(0.5, 0, 0.5, 1);
    love.graphics.translate(2, 0);
  },
  U() {
    love.graphics.line(0, 1, 0, 0, 1, 0, 1, 1);
    love.graphics.translate(2, 0);
  },
  W() {
    love.graphics.line(0, 1, 0, 0, 0.5, 0.5, 1, 0, 1, 1);
    love.graphics.translate(2, 0);
  },
  Y() {
    love.graphics.line(0, 1, 0.5, 0.5, 1, 1);
    love.graphics.line(0.5, 0, 0.5, 0.5);
    love.graphics.translate(2, 0);
  },
  space() {
    love.graphics.translate(2, 0);
  }
};

const systems = {
  titleScreen: {
    updateAll(id, e, dt) {
      if (love.keyboard.isDown("Enter")) {
        entities = newGame();
      }
    },
    update(id, e, dt) {
      if (e.titleScreen) {
        e.titleScreen.time = e.titleScreen.time + dt;
      }
    },
    draw(id, e) {
      if (e.titleScreen) {
        love.graphics.push();
        love.graphics.scale(1 / 16, 1 / 12);
        love.graphics.translate(1.5, 9);
        font.L();
        font.U();
        font.N();
        font.A();
        font.R();
        love.graphics.translate(-8, -2);
        font.L();
        font.A();
        font.N();
        font.D();
        font.E();
        font.R();
        love.graphics.pop();

        const [
          oldColorR,
          oldColorG,
          oldColorB,
          oldColorA
        ] = love.graphics.getColor();
        const alpha = 0.5 + 0.3 * Math.sin(2 * e.titleScreen.time);
        love.graphics.setColor(oldColorR, oldColorG, oldColorB, alpha);
        love.graphics.push();
        love.graphics.scale(1 / 64, 1 / 48);
        love.graphics.translate(13, 17);
        font.P();
        font.R();
        font.E();
        font.S();
        font.S();
        font.space();
        font.E();
        font.N();
        font.T();
        font.E();
        font.R();
        font.space();
        font.T();
        font.O();
        font.space();
        font.P();
        font.L();
        font.A();
        font.Y();
        love.graphics.pop();
        love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA);

        love.graphics.push();
        love.graphics.scale(1 / 64, 1 / 48);
        love.graphics.translate(11, 8);
        font.U();
        font.S();
        font.E();
        font.space();
        font.A();
        font.R();
        font.R();
        font.O();
        font.W();
        font.S();
        font.space();
        font.T();
        font.O();
        font.space();
        font.C();
        font.O();
        font.N();
        font.T();
        font.R();
        font.O();
        font.L();
        love.graphics.translate(-35, -2);
        font.S();
        font.H();
        font.I();
        font.P();
        font.space();
        font.B();
        font.O();
        font.O();
        font.S();
        font.T();
        font.E();
        font.R();
        font.S();
        love.graphics.pop();
      }
    }
  },
  stars: {
    update(id, e, dt) {
      if (e.stars && (!entities.ground || entities.ground.ground.created)) {
        while (e.stars.points.length < e.stars.count) {
          const x = Math.random();
          let y = Math.random();
          let distanceMin = 1 / 0;
          let heightMin = 0;
          for ([id2, e2] of Object.entries(entities)) {
            if (e2.wall) {
              const distance = Math.abs(e2.transform.x - x);
              if (distance < distanceMin) {
                distanceMin = distance;
                heightMin = e2.transform.y;
              }
            }
          }
          y = y + heightMin;
          e.stars.points.push([x, y]);
        }
      }
    },
    draw(id, e) {
      if (e.stars) {
        love.graphics.points(e.stars.points);
      }
    }
  },
  ship: {
    update(id, e, dt) {
      if (e.ship) {
        e.body.ax = 0;
        e.body.ay = 0;
        for (i of [1, 2, 3]) {
          const booster = entities["booster" + i].booster;
          e.body.ax = e.body.ax + booster.throttle * booster.ax;
          e.body.ay = e.body.ay + booster.throttle * booster.ay;
        }
        if (e.collision) {
          delete entities.ship;
          delete entities.booster1;
          delete entities.booster2;
          delete entities.booster3;
          delete entities.fuelGauge;
          const t = e.collision.target.transform;
          entities.explosion = {
            transform: {
              x: t.x,
              y: t.y
            },
            explosion: {
              time: 0
            }
          };
        }
      }
    },
    draw(id, e) {
      if (e.ship) {
        const t = e.transform;
        love.graphics.push();
        love.graphics.translate(t.x, t.y);
        const [
          oldColorR,
          oldColorG,
          oldColorB,
          oldColorA
        ] = love.graphics.getColor();
        // guides
        const xx = t.w / 12;
        const yy = t.h / 12;
        const xTop = 3 * xx;
        const xBottom = 6 * xx;
        const xLegStart = 4 * xx;
        const xLegEnd = 5 * xx; // reused in shipPadCollider.update
        const yTop = 6 * yy;
        const yAngle = yy;
        const yBottom = -4 * yy; // reused in booster1.transform
        const yLeg = -6 * yy;
        // body
        const body = [
          -xBottom,
          yBottom, // bottom left
          -xBottom,
          yAngle, // angle left
          -xTop,
          yTop, // top left
          xTop,
          yTop, // top right
          xBottom,
          yAngle, // angle right
          xBottom,
          yBottom // bottom right
        ];
        love.graphics.setColor(0, 0, 0);
        love.graphics.polygon("fill", body);
        love.graphics.setColor(1, 1, 1);
        love.graphics.polygon("line", body);
        // leg left
        love.graphics.line(-xLegStart, yBottom, -xLegEnd, yLeg);
        // leg right
        love.graphics.line(xLegStart, yBottom, xLegEnd, yLeg);
        love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA);
        love.graphics.pop();
      }
    }
  },
  booster: {
    update(id, e, dt) {
      if (e.booster) {
        if (love.keyboard.isDown(e.booster.key)) {
          e.booster.throttle = 1;
          const consumption = Math.abs(e.booster.ax) + Math.abs(e.booster.ay);
          entities.ship.ship.fuel = entities.ship.ship.fuel - consumption * dt;
          if (entities.ship.ship.fuel < 0) {
            entities.ship.ship.fuel = 0;
            e.booster.throttle = 0;
          }
        } else {
          e.booster.throttle = 0;
        }
      }
    },
    draw(id, e) {
      if (e.booster && e.booster.throttle > 0) {
        love.graphics.push();
        love.graphics.translate(
          entities.ship.transform.x,
          entities.ship.transform.y
        );
        const t = e.transform;
        love.graphics.translate(t.x, t.y);
        love.graphics.rotate(t.angle);
        const [
          oldColorR,
          oldColorG,
          oldColorB,
          oldColorA
        ] = love.graphics.getColor();
        love.graphics.setColor(1, Math.random(), 0);
        const rand = Math.random() * 0.5 + 0.5;
        if (e.booster.main) {
          love.graphics.polygon(
            "fill",
            -t.w / 2,
            0,
            -t.w / 3,
            (-t.h / 2) * rand,
            -t.w / 4,
            0
          );
          love.graphics.polygon(
            "fill",
            -t.w / 4,
            0,
            0,
            -t.h * rand,
            t.w / 4,
            0
          );
          love.graphics.polygon(
            "fill",
            t.w / 4,
            0,
            t.w / 3,
            (-t.h / 2) * rand,
            t.w / 2,
            0
          );
        } else {
          love.graphics.polygon(
            "fill",
            -t.w / 2,
            0,
            0,
            (-t.h / 2) * rand,
            t.w / 2,
            0
          );
        }
        love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA);
        love.graphics.pop();
      }
    }
  },
  fuelGauge: {
    draw(id, e) {
      if (e.fuelGauge) {
        love.graphics.rectangle(
          "line",
          e.transform.x,
          e.transform.y,
          e.transform.w,
          e.transform.h
        );
        const padding = e.transform.h / 6;
        const ratio = entities.ship.ship.fuel / entities.ship.ship.fuelMax;
        love.graphics.rectangle(
          "fill",
          e.transform.x + padding,
          e.transform.y + padding,
          (e.transform.w - 2 * padding) * ratio,
          e.transform.h - 2 * padding
        );
      }
    }
  },
  body: {
    update(id, e, dt) {
      if (e.body) {
        const gravity = -0.2;
        e.body.vx = e.body.vx + e.body.ax * dt;
        e.body.vy = e.body.vy + (e.body.ay + gravity) * dt;
        if (e.body.grounded) {
          if (e.body.vy <= 0) {
            e.body.vx = 0;
            e.body.vy = 0;
          } else {
            e.body.grounded = false;
          }
        }
        e.transform.x = e.transform.x + e.body.vx * dt;
        e.transform.y = e.transform.y + e.body.vy * dt;
      }
    }
  },
  shipWallCollider: {
    update(id, e, dt) {
      if (e.ship) {
        const t = e.transform;
        let distanceMax = 1 / 0;
        let targetMax;
        for ([id2, e2] of Object.entries(entities)) {
          if (e2.wall) {
            const t2 = e2.transform;
            const distance = Math.sqrt((t.x - t2.x) ** 2 + (t.y - t2.y) ** 2);
            if (distance < distanceMax) {
              distanceMax = distance;
              targetMax = e2;
            }
          }
        }
        if (distanceMax < Math.sqrt(t.w ** 2 + t.h ** 2) / 2) {
          e.collision = {
            target: targetMax
          };
        }
      }
    }
  },
  shipPadCollider: {
    updateAll(dt) {
      if (entities.ship && entities.pad) {
        const s = entities.ship.transform;
        const p = entities.pad.transform;

        // landing conditions
        let isLanding;
        {
          const dx = Math.abs(s.x - p.x);
          const dy = Math.abs(s.y - s.h / 2 - p.y);
          const v = Math.sqrt(
            entities.ship.body.vx ** 2 + entities.ship.body.vy ** 2
          );
          const offsetOkay = dx < (p.w - (s.w * 10) / 12) / 2;
          const altitudeOkay = dy < 0.001;
          const speedOkay = v < 0.08 && entities.ship.body.vy <= 0;
          isLanding = offsetOkay && altitudeOkay && speedOkay;
        }

        // rectangle collision check
        let isColliding;
        {
          const dx = Math.abs(s.x - p.x);
          const dy = Math.abs(s.y - (p.y - p.h / 2));
          isColliding = dx < (s.w + p.w) / 2 && dy < (s.h + p.h) / 2;
        }

        if (isLanding) {
          entities.ship.body.grounded = true;
          entities.ship.transform.y = s.h / 2 + entities.pad.transform.y;
        } else if (isColliding) {
          entities.ship.collision = {
            target: entities.pad
          };
        }
      }
    }
  },
  wall: {
    updateAll(dt) {
      if (entities.ground && !entities.ground.ground.created) {
        entities.ground.ground.created = true;
        for ([id, e] of Object.entries(entities)) {
          const t = e.transform;
          if (e.wall && t.w > 1 / size) {
            entities.ground.ground.created = false;
            delete entities[e.id];
            const hw = t.w / 2;
            const hh = (t.h / 2) * (1 + (Math.random() - 0.5));
            const left = {
              id: e.id + 0,
              transform: {
                x: t.x,
                y: t.y,
                w: hw,
                h: hh
              },
              wall: {}
            };
            entities[left.id] = left;
            const right = {
              id: e.id + 1,
              transform: {
                x: t.x + hw,
                y: t.y + hh,
                w: t.w - hw,
                h: t.h - hh
              },
              wall: {}
            };
            entities[right.id] = right;
          }
        }
      }
    },
    draw(id, e) {
      if (e.wall) {
        love.graphics.push();
        love.graphics.line(
          e.transform.x,
          e.transform.y,
          e.transform.x + e.transform.w,
          e.transform.y + e.transform.h
        );
        love.graphics.pop();
      }
    }
  },
  explosion: {
    update(id, e, dt) {
      if (e.explosion) {
        e.explosion.time = e.explosion.time + dt;
        if (e.explosion.time > 2) {
          entities = titleScreen();
        }
      }
    },
    draw(id, e) {
      if (e.explosion) {
        const oldLineWidth = love.graphics.getLineWidth();
        const t = e.transform;
        love.graphics.setLineWidth(0.5);
        const [
          oldColorR,
          oldColorG,
          oldColorB,
          oldColorA
        ] = love.graphics.getColor();
        love.graphics.setColor(1, 2 * e.explosion.time, 0);
        love.graphics.circle("line", t.x, t.y, 3 * e.explosion.time);
        love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA);
        love.graphics.setLineWidth(oldLineWidth);
      }
    }
  },
  pad: {
    updateAll() {
      if (!entities.pad && entities.ground && entities.ground.ground.created) {
        const ground = [];
        for ([id, e] of Object.entries(entities)) {
          const t = e.transform;
          if (e.wall && t.x > 0.2 && t.x < 0.8) {
            ground.push(e);
          }
        }
        const t =
          ground[Math.round(Math.random() * (ground.length - 1))].transform;
        entities.pad = {
          transform: {
            x: t.x,
            y: t.y + 0.05,
            w: 0.07,
            h: 0.05
          },
          pad: {}
        };
      }
    },
    draw(id, e) {
      if (e.pad) {
        const t = e.transform;
        const oldLineWidth = love.graphics.getLineWidth();
        love.graphics.setLineWidth(2 * oldLineWidth);
        love.graphics.line(t.x - t.w / 2, t.y, t.x + t.w / 2, t.y);
        love.graphics.line(t.x, t.y, t.x, t.y - t.h);
        love.graphics.setLineWidth(oldLineWidth);
      }
    }
  }
};

love.conf = function(t) {
  t.window.width = size;
  t.window.height = size;
};

love.update = function(dt) {
  for ([k, v] of Object.entries(systems)) {
    if (v.updateAll) {
      v.updateAll(dt);
    }
    if (v.update) {
      for ([id, e] of Object.entries(entities)) {
        v.update(id, e, dt);
      }
    }
  }
};

love.draw = function() {
  love.graphics.scale(size, -size);
  love.graphics.translate(0, -1);
  love.graphics.setLineWidth(1 / size);
  for ([k, v] of Object.entries(systems)) {
    if (v.drawAll) {
      v.drawAll();
    }
    if (v.draw) {
      for ([id, e] of Object.entries(entities)) {
        v.draw(id, e);
      }
    }
  }
};

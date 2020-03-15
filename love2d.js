class Love {
  constructor() {
    setTimeout(() => {
      const t = { window: {} };
      this.conf(t);
      this.conf = t;

      this.graphics.canvas = document.createElement("canvas");
      this.graphics.ctx = this.graphics.canvas.getContext("2d");
      this.graphics.canvas.width = this.conf.window.width;
      this.graphics.canvas.height = this.conf.window.height;
      document.body.appendChild(this.graphics.canvas);

      let lastTime = Date.now();
      const draw = () => {
        const time = Date.now();
        const dt = time - lastTime;
        lastTime = time;
        this.graphics._reset();
        love.update(dt / 1000);
        love.draw();
        requestAnimationFrame(draw);
      };
      requestAnimationFrame(draw);

      const keys = {};
      window.addEventListener("keydown", e => (keys[e.key] = true));
      window.addEventListener("keyup", e => (keys[e.key] = false));
      this.keyboard._keys = keys;
    });
  }

  graphics = {
    _reset() {
      this.transforms = [[1, 0, 0, 0, 1, 0, 0, 0, 1]];
      this.setColor(1, 1, 1, 1);
      this.setLineWidth(1);
      this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    },
    _transform(matrix) {
      const [a1, a2, a3, a4, a5, a6, a7, a8, a9] = this.transforms.pop();
      const [b1, b2, b3, b4, b5, b6, b7, b8, b9] = matrix;
      this.transforms.push([
        a1 * b1 + a2 * b4 + a3 * b7,
        a1 * b2 + a2 * b5 + a3 * b8,
        a1 * b3 + a2 * b6 + a3 * b9,
        a4 * b1 + a5 * b4 + a6 * b7,
        a4 * b2 + a5 * b5 + a6 * b8,
        a4 * b3 + a5 * b6 + a6 * b9,
        a7 * b1 + a8 * b4 + a9 * b7,
        a7 * b2 + a8 * b5 + a9 * b8,
        a7 * b3 + a8 * b6 + a9 * b9
      ]);
    },
    _apply(point) {
      const [a1, a2, a3, a4, a5, a6, a7, a8, a9] = this.transforms[
        this.transforms.length - 1
      ];
      const [b1, b2] = point;
      const b3 = 1;
      const [x, y, s] = [
        a1 * b1 + a2 * b2 + a3 * b3,
        a4 * b1 + a5 * b2 + a6 * b3,
        a7 * b1 + a8 * b2 + a9 * b3
      ];
      return [x / s, y / s];
    },
    push() {
      this.transforms.push(this.transforms[this.transforms.length - 1]);
    },
    pop() {
      this.transforms.pop();
    },
    rotate(angle) {
      const c = Math.cos(angle);
      const s = Math.sin(angle);
      this._transform([c, -s, 0, s, c, 0, 0, 0, 1]);
    },
    scale(x, y) {
      this._transform([x, 0, 0, 0, y, 0, 0, 0, 1]);
    },
    translate(x, y) {
      this._transform([1, 0, x, 0, 1, y, 0, 0, 1]);
    },
    getColor() {
      return this._color;
    },
    setColor(r, g, b, a) {
      this._color = [r, g, b, a];
      this._colorHex =
        "#" +
        ((r * 255) | 0).toString(16) +
        ((g * 255) | 0).toString(16) +
        ((b * 255) | 0).toString(16) +
        ((a * 255) | 0).toString(16);
    },
    getLineWidth() {
      return this._lineWidth;
    },
    setLineWidth(lineWidth) {
      this._lineWidth = lineWidth;
      const point = this._apply([1, 0]);
      this.ctx.lineWidth = lineWidth * Math.sqrt(point[0] ** 2 + point[1] ** 2);
    },
    circle(mode, x, y, radius) {},
    line(...coords) {
      let created = false;
      let x;
      for (let y of coords) {
        if (x == undefined) {
          x = y;
        } else {
          const point = this._apply([x, y]);
          x = point[0];
          y = point[1];
          if (!created) {
            this.ctx.beginPath();
            this.ctx.moveTo(x, y);
            created = true;
          } else {
            this.ctx.lineTo(x, y);
          }
          x = undefined;
        }
      }
      this.ctx.strokeStyle = this._colorHex;
      this.ctx.stroke();
      this.ctx.closePath();
    },
    points(points) {
      this.ctx.fillStyle = this._colorHex;
      for (const point of points) {
        const [x, y] = this._apply(point);
        this.ctx.fillRect(x | 0, y | 0, 1, 1);
      }
    },
    polygon(mode, ...coords) {
      if (coords.length === 1) coords = coords[0];
      let created = false;
      let x;
      for (let y of coords) {
        if (x == undefined) {
          x = y;
        } else {
          const point = this._apply([x, y]);
          x = point[0];
          y = point[1];
          if (!created) {
            this.ctx.beginPath();
            this.ctx.moveTo(x, y);
            created = true;
          } else {
            this.ctx.lineTo(x, y);
          }
          x = undefined;
        }
      }
      this.ctx.closePath();
      if (mode === "fill") {
        this.fillStyle = this._colorHex;
        this.ctx.fill();
      } else if (mode === "line") {
        this.ctx.strokeStyle = this._colorHex;
        this.ctx.stroke();
      }
    },
    rectangle(mode, x, y, w, h) {
      this.polygon(mode, x, y, x + w, y, x + w, y + h, x, y + h);
    }
  };

  keyboard = {
    isDown(key) {
      return this._keys[key];
    }
  };
}

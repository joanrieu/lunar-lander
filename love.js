class Love {
  constructor() {
    setTimeout(() => {
      const t = { window: {} };
      this.conf(t);
      this.conf = t;

      this.canvas = document.createElement("canvas");
      this.ctx = this.canvas.getContext("2d");
      this.canvas.width = this.conf.window.width;
      this.canvas.height = this.conf.window.height;
      document.body.appendChild(this.canvas);

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
      this.keyboard.isDown.keys = keys;
    });
  }

  graphics = {
    _reset() {
      this.transforms = [[1, 0, 0, 0, 1, 0, 0, 0, 1]];
      this._color = [1, 1, 1, 1];
      this._lineWidth = 1;
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
      const [a1, a2, a3, a4, a5, a6, a7, a8, a9] = this.transforms.pop();
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
    },
    getLineWidth() {
      return this._lineWidth;
    },
    setLineWidth(lineWidth) {
      this._lineWidth = lineWidth;
    },
    circle(mode, x, y, radius) {},
    line(...coords) {},
    points(points) {},
    polygon(mode, ...coords) {
      if (coords.length === 1) coords = coords[0];
    },
    rectangle(mode, x, y, w, h) {}
  };

  keyboard = {
    isDown(key) {
      return false;
    }
  };
}

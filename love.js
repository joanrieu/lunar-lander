class Love {
  constructor() {
    setTimeout(() => {
      const t = { window: {} };
      this.conf(t);
      this.conf = t;

      let lastTime = Date.now();
      const draw = () => {
        const time = Date.now();
        const dt = time - lastTime;
        lastTime = time;
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
    push() {},
    pop() {},
    rotate(angle) {},
    scale(x, y) {},
    translate(x, y) {},
    getColor() {
      return [1, 1, 1, 1];
    },
    setColor(r, g, b, a) {},
    getLineWidth() {
      return 1;
    },
    setLineWidth(lineWidth) {},
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

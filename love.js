class Love {
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

  event = {
    quit() {}
  };
}

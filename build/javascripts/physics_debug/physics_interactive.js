(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Phaser.Utils.PhysicsInteractive = (function() {
    function PhysicsInteractive(game, drawer) {
      this.handlePointerDown = __bind(this.handlePointerDown, this);
      this.game = game;
      this.drawer = drawer;
      this.physicsWorld = game.physics.world;
      this.init();
    }

    PhysicsInteractive.prototype.init = function() {
      this.upKey = this.game.input.keyboard.addKey(Phaser.Keyboard.UP);
      this.downKey = this.game.input.keyboard.addKey(Phaser.Keyboard.DOWN);
      this.leftKey = this.game.input.keyboard.addKey(Phaser.Keyboard.LEFT);
      this.rightKey = this.game.input.keyboard.addKey(Phaser.Keyboard.RIGHT);
      return this.game.input.onDown.add(this.handlePointerDown);
    };

    PhysicsInteractive.prototype.handlePointerDown = function(pointer) {
      var body, speed;
      if (Math.random() > 0.5) {
        body = this.createRectangle(pointer.x, pointer.y);
      } else {
        body = this.createCircle(pointer.x, pointer.y);
      }
      speed = 1000;
      if (this.upKey.isDown) {
        return this.addVelocity(body, speed);
      } else if (this.downKey.isDown) {
        return this.addVelocity(body, speed, Math.PI);
      } else if (this.leftKey.isDown) {
        return this.addVelocity(body, speed, -Math.PI / 2);
      } else if (this.rightKey.isDown) {
        return this.addVelocity(body, speed, Math.PI / 2);
      }
    };

    PhysicsInteractive.prototype.addVelocity = function(body, speed, angle) {
      var magnitude;
      if (angle == null) {
        angle = 0;
      }
      magnitude = this.px2pi(-speed);
      angle = angle + Math.PI / 2;
      body.velocity[0] = magnitude * Math.cos(angle);
      return body.velocity[1] = magnitude * Math.sin(angle);
    };

    PhysicsInteractive.prototype.createRectangle = function(x, y, w, h) {
      var body, rectangle;
      if (w == null) {
        w = 50;
      }
      if (h == null) {
        h = 50;
      }
      rectangle = new p2.Rectangle(this.px2p(w), this.px2p(h));
      body = this.getBody(x, y);
      body.addShape(rectangle);
      this.physicsWorld.addBody(body);
      return body;
    };

    PhysicsInteractive.prototype.createCircle = function(x, y, r) {
      var body, circle;
      if (r == null) {
        r = 20;
      }
      circle = new p2.Circle(this.px2p(r));
      body = this.getBody(x, y);
      body.addShape(circle);
      this.physicsWorld.addBody(body);
      return body;
    };

    PhysicsInteractive.prototype.getBody = function(x, y) {
      var body;
      body = new p2.Body({
        mass: 1,
        position: [this.px2pi(x), this.px2pi(y)]
      });
      return body;
    };

    PhysicsInteractive.prototype.px2p = function(value) {
      return this.game.math.px2p(value);
    };

    PhysicsInteractive.prototype.px2pi = function(value) {
      return this.game.math.px2pi(value);
    };

    return PhysicsInteractive;

  })();

}).call(this);

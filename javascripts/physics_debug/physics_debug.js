(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Phaser.Utils.PhysicsDebug = (function(_super) {
    __extends(PhysicsDebug, _super);

    function PhysicsDebug(game) {
      this.removeBody = __bind(this.removeBody, this);
      this.registerBody = __bind(this.registerBody, this);
      this.togglePolygon = __bind(this.togglePolygon, this);
      PhysicsDebug.__super__.constructor.call(this, game);
      this.game = game;
      this.bodies = [];
      this.init();
    }

    PhysicsDebug.prototype.init = function() {
      var _this = this;
      this.physicsWorld = this.game.physics.world;
      this.physicsWorld.on("addBody", function(e) {
        return _this.registerBody(e.body);
      });
      this.physicsWorld.on("removedBody", function(e) {
        return _this.removeBody(e.body);
      });
      this.initDrawer();
      this.invalidate(true);
      return this.registerKeys();
    };

    PhysicsDebug.prototype.registerKeys = function() {
      this.key_p = this.game.input.keyboard.addKey(Phaser.Keyboard.P);
      return this.key_p.onDown.add(this.togglePolygon);
    };

    PhysicsDebug.prototype.togglePolygon = function() {
      this.drawer.settings.debugPolygons = !this.drawer.settings.debugPolygons;
      return this.invalidate();
    };

    PhysicsDebug.prototype.initDrawer = function() {
      var drawingOptions;
      drawingOptions = {
        debugPolygons: false,
        drawingAlpha: 0.5,
        pixelsPerLengthUnit: 20
      };
      this.drawer = new Phaser.Utils.PhysicsDrawer(this.game, drawingOptions);
      this.add(this.drawer);
      return this.interactive = new Phaser.Utils.PhysicsInteractive(this.game, this.drawer);
    };

    PhysicsDebug.prototype.invalidate = function(rebuild) {
      var body, _i, _len, _ref;
      if (rebuild == null) {
        rebuild = true;
      }
      this.removeAll();
      if (rebuild) {
        _ref = this.physicsWorld.bodies;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          body = _ref[_i];
          this.registerBody(body);
        }
      }
      this.drawer.redrawAll();
      return this.ensureFrontPosition();
    };

    PhysicsDebug.prototype.redrawBody = function(body) {
      return this.drawer.redrawBody(body);
    };

    PhysicsDebug.prototype.ensureFrontPosition = function() {
      return this.game.world.bringToTop(this);
    };

    PhysicsDebug.prototype.removeAll = function() {
      var _results;
      _results = [];
      while (this.bodies.length > 0) {
        _results.push(this.removeBody(this.bodies[0]));
      }
      return _results;
    };

    PhysicsDebug.prototype.registerBody = function(body) {
      if (body instanceof p2.Body) {
        if (body.shapes.length) {
          this.bodies.push(body);
          return this.drawer.addRenderable(body);
        }
      } else {
        throw new Error("You can only add p2.body");
      }
    };

    PhysicsDebug.prototype.removeBody = function(body) {
      var i;
      if (body instanceof p2.Body) {
        i = this.bodies.indexOf(body);
        if (i !== -1) {
          this.bodies.splice(i, 1);
          return this.drawer.removeRenderable(body);
        }
      } else {
        throw new Error("No p2 body given");
      }
    };

    return PhysicsDebug;

  })(Phaser.Group);

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Phaser.Utils.PhysicsDrawer = (function(_super) {
    __extends(PhysicsDrawer, _super);

    PhysicsDrawer.prototype.settings = {
      debugPolygons: false,
      pixelsPerLengthUnit: 20,
      drawingAlpha: 0.5
    };

    function PhysicsDrawer(game, options) {
      if (options == null) {
        options = {};
      }
      PhysicsDrawer.__super__.constructor.call(this, game);
      this.settings = Phaser.Utils.extend(this.settings, options);
      this.alpha = this.settings.drawingAlpha;
    }

    PhysicsDrawer.prototype.removeRenderable = function(body) {
      var item;
      item = this.bodyToItem(body);
      return this.remove(item);
    };

    PhysicsDrawer.prototype.addRenderable = function(body) {
      var item;
      item = new Phaser.Utils.PhysicsItem(this.game, body, this.settings);
      return this.add(item);
    };

    PhysicsDrawer.prototype.redrawAll = function() {
      var item, _i, _len, _ref, _results;
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push(item.draw());
      }
      return _results;
    };

    PhysicsDrawer.prototype.redrawBody = function(body) {
      var item;
      item = this.bodyToItem(body);
      return item.draw();
    };

    PhysicsDrawer.prototype.bodyToItem = function(body) {
      var item, _i, _len, _ref;
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (item.body === body) {
          return item;
        }
      }
    };

    return PhysicsDrawer;

  })(Phaser.Group);

}).call(this);

(function() {
  var game, states;

  states = {
    preload: function() {
      game.load.physics('pinball', 'assets/pinball.json', null, Phaser.Physics.LIME_CORONA_JSON);
      game.load.image('table', 'assets/table.png');
      game.load.image('ball', 'assets/ball.png');
      game.load.image('flipperLeft', 'assets/flipper_left.png');
      return game.load.image('flipperRight', 'assets/flipper_right.png');
    },
    create: function() {
      var physicsDebug, pinball;
      game.physics.gravity.y = 1000;
      game.physics.friction = 0.5;
      pinball = new PinballPhysics(this.game);
      physicsDebug = new Phaser.Utils.PhysicsDebug(this.game);
      return game.world.add(physicsDebug);
    }
  };

  game = new Phaser.Game(768, 1024, Phaser.CANVAS, 'pinball', states);

}).call(this);

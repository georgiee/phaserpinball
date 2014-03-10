states=
  preload: ->
    game.load.physics('pinball', 'assets/pinball.json', null, Phaser.Physics.LIME_CORONA_JSON);
    game.load.image('table', 'assets/table.png');
    game.load.image('ball', 'assets/ball.png');
    game.load.image('flipperLeft', 'assets/flipper_left.png');
    game.load.image('flipperRight', 'assets/flipper_right.png');

  create: ->
    game.physics.startSystem(Phaser.Physics.P2);
    
    game.physics.p2.gravity.y = 1000;
    game.physics.p2.friction = 0.5;
    
    pinball = new PinballPhysics(@game)

    #physicsDebug = new Phaser.Utils.PhysicsDebug(@game)
    #game.world.add(physicsDebug)

game = new Phaser.Game(768, 1024, Phaser.CANVAS, 'pinball', states) 
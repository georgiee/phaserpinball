states=
  preload: ->
    game.load.physics('pinball', 'assets/pinball.json', null, Phaser.Physics.LIME_CORONA_JSON);
    game.load.image('table', 'assets/table.png');
    game.load.image('ball', 'assets/ball.png');
    game.load.image('flipperLeft', 'assets/flipper_left.png');
    game.load.image('flipperRight', 'assets/flipper_right.png');

  create: ->
    game.physics.startSystem(Phaser.Physics.BOX2D);
    
    ball = game.add.sprite(100,100,'ball')
    game.physics.enable(ball, Phaser.Physics.BOX2D, true)

game = new Phaser.Game(768, 1024, Phaser.CANVAS, 'pinball', states) 
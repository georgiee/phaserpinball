states=
  preload: ->
    game.load.physics('pinball', 'assets/pinball.json', null, Phaser.Physics.LIME_CORONA_JSON);
    game.load.image('table', 'assets/table.png');
    game.load.image('ball', 'assets/ball.png');
    game.load.image('flipperLeft', 'assets/flipper_left.png');
    game.load.image('flipperRight', 'assets/flipper_right.png');


  create: ->
    categories = {edge:2, ball:4, flipper: 8, square: 16}
    game.physics.startSystem(Phaser.Physics.BOX2D);
    
    square = game.add.sprite(160,100,'ball')
    game.physics.enable(square, Phaser.Physics.BOX2D, true)
    square.body.dynamic = true
    square.body.setCollisionCategory(categories.square)

    #ball.body.fixedRotation = true
    bb = new Phaser.Physics.Box2D.Body(game,null, 400, 400)
    bb.testEdgeShape()
    bb.setCollisionCategory(categories.edge)
    #bb.setCollisionMask(categories.ball | categories.flipper)

    ball = game.add.sprite(500,100,'ball')
    game.physics.enable(ball, Phaser.Physics.BOX2D, true)
    ball.body.setCircle(20)
    ball.body.dynamic = true
    ball.body.setCollisionCategory(categories.ball)

    ball = game.add.sprite(510,100,'ball')
    game.physics.enable(ball, Phaser.Physics.BOX2D, true)
    ball.body.setCircle(20)
    ball.body.dynamic = true
    ball.body.setCollisionCategory(categories.ball)

    ball = game.add.sprite(460,100,'ball')
    game.physics.enable(ball, Phaser.Physics.BOX2D, true)
    ball.body.setCircle(20)
    ball.body.dynamic = true
    
    ball.body.setCollisionCategory(categories.ball)


    bb = new Phaser.Physics.Box2D.Body(game,null, 400, 400)
    bb.testPolygon()
    bb.setCollisionCategory(categories.flipper)


    console.log('bb.angularVelocity', bb.mass)

    @chain()
  
  chain: ->
    shape = new box2d.b2PolygonShape();
    shape.SetAsBox(0.6, 0.125);

    fd = new box2d.b2FixtureDef();
    fd.shape = shape;
    fd.density = 20.0;
    fd.friction = 0.2;

    jd = new box2d.b2RevoluteJointDef();
    jd.collideConnected = false;

    y = -5.0;
    prevBody = game.physics.box2d.ground;

    for i in [0...20]
      ball = game.add.sprite(Phaser.Physics.Box2D.Utils.b2px(0.5 + i), Phaser.Physics.Box2D.Utils.b2pxi(y),'ball')
      game.physics.enable(ball, Phaser.Physics.BOX2D, true)
      bb = ball.body
      bb.setCircle(20)
      bb.dynamic = true
      bb.createFixture(fd)

      anchor = new box2d.b2Vec2(i, y);
      jd.Initialize(prevBody, bb.data, anchor);
      game.physics.box2d.world.CreateJoint(jd);

      prevBody = bb.data;

game = new Phaser.Game(768, 1024, Phaser.CANVAS, 'pinball', states) 
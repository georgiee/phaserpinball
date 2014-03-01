class window.PinballPhysics extends Phaser.Group
  constructor: (game)->
    super(game)
    @physicsWorld = @game.physics.world

    @build()
    @registerKeys()
  
  build: ->
    @groundBody = new p2.Body();
    @physicsWorld.addBody(@groundBody);

    @table = @createTable()  
    @flipperLeft = @createFlipperLeft()
    @flipperRight = @createFlipperRight()
    @ball = @createBall()
  
  registerKeys: ->
    @key_left = @game.input.keyboard.addKey(Phaser.Keyboard.Z);
    @key_right = @game.input.keyboard.addKey(Phaser.Keyboard.X);
  
  update: ->
    if @key_left.isDown
      @flipperLeftRevolute.lowerLimit = 35 * Math.PI/180
      @flipperLeftRevolute.upperLimit = 35 * Math.PI/180
    else
      @flipperLeftRevolute.lowerLimit = 0 * Math.PI/180
      @flipperLeftRevolute.upperLimit = 0 * Math.PI/180
    
    if @key_right.isDown
      @flipperRightRevolute.lowerLimit = -35 * Math.PI/180
      @flipperRightRevolute.upperLimit = -35 * Math.PI/180
    else
      @flipperRightRevolute.lowerLimit = 0 * Math.PI/180
      @flipperRightRevolute.upperLimit = 0 * Math.PI/180
  
  createFlipperRevolute: (sprite, pivotA, pivotB, motorSpeed)->
    revolute = new p2.RevoluteConstraint(sprite.body.data, pivotA, @groundBody, pivotB) 
    revolute.upperLimitEnabled = true
    revolute.lowerLimitEnabled = true
    revolute.enableMotor()
    revolute.setMotorSpeed(motorSpeed)
    @physicsWorld.addConstraint(revolute);
    revolute
    
  createTable: ->
    table = @create(@game.world.width/2,@game.world.height/2,'table')
    table.physicsEnabled = true;
    table.body.clearShapes();
    table.body.loadPolygon('pinball', 'table');
    table.body.collideWorldBounds = false;
    table.body.static = true
    table

  
  createBall: ->
    ball = @create(250,500, 'ball')
    ball.physicsEnabled = true;
    ball.body.setCircle(20);
    ball

  createFlipperLeft: ->
    flipper = @create(0, 0,'flipperLeft')
    flipper.physicsEnabled = true
    flipper.body.clearShapes()
    flipper.body.loadPolygon('pinball','flipper_left')

    pivotA = [@game.math.px2p(flipper.width/2 - 30), @game.math.px2p(10)] #center of flipper
    pivotB = [@game.math.px2pi(200), @game.math.px2pi(900)] #anchor in world

    @flipperLeftRevolute = @createFlipperRevolute(flipper, pivotA, pivotB, -20) #flip motor speed, we rotate in the opposite direction

    flipper

  createFlipperRight: ->
    flipper = @create(0, 0,'flipperRight')
    flipper.physicsEnabled = true
    flipper.body.clearShapes()
    flipper.body.loadPolygon('pinball','flipper_right')

    pivotA = [-@game.math.px2p(flipper.width/2 - 30), @game.math.px2p(10)] #center of flipper
    pivotB = [@game.math.px2pi(500), @game.math.px2pi(900)] #anchor in world
    @flipperRightRevolute = @createFlipperRevolute(flipper, pivotA, pivotB, 20)

    flipper
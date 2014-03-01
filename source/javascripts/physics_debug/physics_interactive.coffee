#manage drag an drop of debugged bodies
#manage creating of debug bodies (rectangles, cricles) to force an intercation with the current world.
class Phaser.Utils.PhysicsInteractive
  constructor: (game, drawer)->
    @game = game
    @drawer = drawer
    @physicsWorld = game.physics.world

    @init()
  init: ->
    @upKey = @game.input.keyboard.addKey(Phaser.Keyboard.UP);
    @downKey = @game.input.keyboard.addKey(Phaser.Keyboard.DOWN);
    @leftKey = @game.input.keyboard.addKey(Phaser.Keyboard.LEFT);
    @rightKey = @game.input.keyboard.addKey(Phaser.Keyboard.RIGHT);

    @game.input.onDown.add(@handlePointerDown)

  #create a random element and apply some velocity if appropriate
  #press direction keys for a strong directional velocity
  handlePointerDown: (pointer)=>
    if Math.random() > 0.5
      body = @createRectangle(pointer.x, pointer.y)
    else
      body = @createCircle(pointer.x, pointer.y)
    
    speed = 1000
    if @upKey.isDown
      @addVelocity(body, speed)
    else if @downKey.isDown
      @addVelocity(body, speed, Math.PI)
    else if @leftKey.isDown
      @addVelocity(body, speed, -Math.PI/2)
    else if @rightKey.isDown
      @addVelocity(body, speed, Math.PI/2)

  addVelocity: (body, speed, angle = 0)->
    magnitude = @px2pi(-speed);
    angle = angle + Math.PI/2
    body.velocity[0] = magnitude * Math.cos(angle);
    body.velocity[1] = magnitude * Math.sin(angle);
  
  createRectangle: (x, y, w = 50, h = 50)->
    rectangle= new p2.Rectangle(@px2p(w), @px2p(h));
    body = @getBody(x, y)
    body.addShape(rectangle);

    @physicsWorld.addBody(body);
    body

  createCircle: (x, y, r = 20)->
    circle= new p2.Circle(@px2p(r));
    body = @getBody(x, y)
    body.addShape(circle)

    @physicsWorld.addBody(body);
    body

  getBody: (x,y)->
    body = new p2.Body
      mass: 1
      position: [@px2pi(x),@px2pi(y)]
    body

  px2p: (value)-> @game.math.px2p(value)
  px2pi: (value)-> @game.math.px2pi(value)
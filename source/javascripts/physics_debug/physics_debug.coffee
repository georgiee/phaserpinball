#Physics Debug to draw and draw bodies in Phaser World.
#This is heavily copied & derived from the PIXI demo example in p2 source.
#
#This class is listen for all changes in the physics world and calls the appropriate
#methods in the drawer.
#There is an interctive class. This class is planned to handle drag/drop AND creating 
#physics only objects to debug the physics interactions betweend bodies.

class Phaser.Utils.PhysicsDebug extends Phaser.Group
  constructor: (game)->
    super(game)
    @game = game
    @bodies = []
    
    @init()
  
  init: ->
    @physicsWorld = @game.physics.world;
    @physicsWorld.on("addBody", (e)=> @registerBody(e.body))
    @physicsWorld.on("removedBody", (e)=> @removeBody(e.body))

    @initDrawer()
    @invalidate(true)
  
    @registerKeys()  
  
  registerKeys: ->
    @key_p = @game.input.keyboard.addKey(Phaser.Keyboard.P);
    @key_p.onDown.add(@togglePolygon)
  
  togglePolygon: =>
    @drawer.settings.debugPolygons = !@drawer.settings.debugPolygons
    @invalidate()  
  
  initDrawer: ->
    drawingOptions = 
      debugPolygons: false
      drawingAlpha: 0.5
      pixelsPerLengthUnit: 20
    
    @drawer = new Phaser.Utils.PhysicsDrawer(@game, drawingOptions)
    @add(@drawer)

    @interactive = new Phaser.Utils.PhysicsInteractive(@game, @drawer)
  
  #public/interface
  
  #make the current state invalidate. Remove all bodies and traverse
  #the current world body list again and add everything you find.
  invalidate: (rebuild = true)->
    @removeAll()

    if rebuild
      for body in @physicsWorld.bodies
        @registerBody(body)
    
    @drawer.redrawAll()
    @ensureFrontPosition() 

  # Redraw a single body. Useful if you change the shape.
  # There is no callback/event so the debugger never know abotu a change
  redrawBody: (body)->
    @drawer.redrawBody(body)
  

  #private
  
  #make sure that debug group is in front of any other object in phaser world
  ensureFrontPosition: ->
    @game.world.bringToTop(@)
  
  removeAll: ->
    while @bodies.length > 0
      @removeBody(@bodies[0])
  
  registerBody: (body) =>
    if(body instanceof p2.Body)
      if(body.shapes.length) # Only draw things that can be seen
          @bodies.push(body);
          @drawer.addRenderable(body);
    else
      throw new Error("You can only add p2.body")
    
  removeBody: (body)=>
    if(body instanceof p2.Body)
      i = @bodies.indexOf(body);
      if(i!=-1)
        @bodies.splice(i,1);
        @drawer.removeRenderable(body)
    else
      throw new Error("No p2 body given")
  

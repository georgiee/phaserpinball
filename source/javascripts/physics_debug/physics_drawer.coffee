#this is the drawer. Add and remove Bodies, this class will create 
#an item per body to draw all shapes of a body at the same place in the phaser world.
#This is heavily copied & derived from the PIXI demo example in p2 source.

class Phaser.Utils.PhysicsDrawer extends Phaser.Group
  settings:
    debugPolygons: false #if enabled, draw the outlines of all sub polygons in different colors. do not fill.
    pixelsPerLengthUnit : 20 #this should default to phasers unit conversion. It's 20 at the moment of writing.
    drawingAlpha: 0.5 #apply alpha to the whole container so we can see the associated phaser object
  
  constructor: (game, options = {})->
    super(game)
    @settings = Phaser.Utils.extend(@settings, options);
    @alpha = @settings.drawingAlpha
  
  #interface
  
  removeRenderable: (body)->
    item = @bodyToItem(body)
    @remove(item)

  #when a body is added create a corresponding sprite for it
  #which we use to draw all the shapes of a single body.
  #create a small value object to pair sprite and body
  addRenderable: (body)->
    item = new Phaser.Utils.PhysicsItem(@game, body, @settings)
    @add(item)  
  
  #force a redraw on all debugged bodies.
  #This will clear it and draw all cotnaining shapes of the body again
  redrawAll: ->
    for item in @children
      item.draw()
  
  # Redraw a single body. Useful if you change the shape.
  # There is no callback/event so the debugger never know abotu a change
  redrawBody: (body)->
    item = @bodyToItem(body)
    item.draw()

  
  #helpers
  
  bodyToItem: (body) ->
    for item in @children
      return item if item.body == body

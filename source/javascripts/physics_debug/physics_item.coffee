class Phaser.Utils.PhysicsItem2 extends Phaser.Group
  settings:
    pixelsPerLengthUnit : 20
    debugPolygons: true
    lineWidth : 1
  
  constructor: (game, body, settings = {})->
    super(game)
    @settings = Phaser.Utils.extend(@settings, settings);
    @ppu = @settings.pixelsPerLengthUnit
    @ppu = -1 * @ppu #flip it to draw in the right direction
    @body = body
    
    #create a separate container.
    @canvas = new Phaser.Graphics(game)
    @add(@canvas)



    @draw() #draw the body shapes
    #@prepareDragable()
  
  #allow use to drag a physics object
  prepareDragable: ->
    #first idea was to render everythign a second time to a texture
    #which we could render on a sprite which we could drag and process the drag feedback in the
    #physics loop. But aabb seems not to be the right place to finde the necessary width/height
    return
    @texture = new Phaser.RenderTexture(@game, @body.aabb, 50)
    @outputSprite = game.add.sprite(0, 0, @texture);
    @outputSprite.inputEnabled = true
    @outputSprite.input.enableDrag(false, undefined,undefined,undefined,undefined)
    @add(@outputSprite)
  
  update: ->
    #@texture.renderXY(@canvas, 0, 0, false)
    @updateSpriteTransform()
  
  #sync the position of our sprite with the target body
  updateSpriteTransform: ->
    @position.x = @body.position[0] * @ppu;
    @position.y = @body.position[1] * @ppu;
    @rotation = @body.angle

  #drawing actions
  draw: ->
    obj = @body
    sprite = @canvas
    sprite.clear()
    color = parseInt(@randomPastelHex(),16)
    lineColor = 0xff0000;
    lw = @lineWidth

    if(obj instanceof p2.Body && obj.shapes.length)
      for i in [0...obj.shapes.length]
        child = obj.shapes[i]
        offset = obj.shapeOffsets[i]
        angle = obj.shapeAngles[i]
        offset = offset || zero;
        angle = angle || 0;
        if(child instanceof p2.Circle)
          @drawCircle(sprite,offset[0]*@ppu,-offset[1]*@ppu,angle,child.radius*@ppu,color,lw);
        else if(child instanceof p2.Convex)
          verts = []
          vrot = p2.vec2.create()
          for j in [0...child.vertices.length]
            v = child.vertices[j];
            p2.vec2.rotate(vrot, v, angle);
            verts.push([(vrot[0]+offset[0])*@ppu, -(vrot[1]+offset[1])*@ppu]);
          @drawConvex(sprite, verts, child.triangles, lineColor, color, lw, this.settings.debugPolygons,[offset[0]*@ppu,-offset[1]*@ppu]);
        else if(child instanceof p2.Plane)
          @drawPlane(sprite, offset[0]*@ppu,-offset[1]*@ppu, color, lineColor, lw * 5, lw*10, lw*10, @ppu*100, angle);
        else if(child instanceof p2.Line)
          @drawLine(sprite, child.length*@ppu, lineColor, lw);
        else if(child instanceof p2.Rectangle)
          @drawRectangle(sprite, offset[0]*@ppu, -offset[1]*@ppu, angle, child.width*@ppu, child.height*@ppu, lineColor, color, lw);
  
  drawRectangle: (g,x,y,angle,w,h,color,fillColor,lineWidth)->
    lineWidth = typeof(lineWidth)=="number" ? lineWidth : 1;
    color = typeof(color)=="undefined" ? 0x000000 : color;
    g.lineStyle(lineWidth, color, 1);
    g.beginFill(fillColor);
    g.drawRect(x-w/2,y-h/2,w,h);
  
  drawCircle: (g, x, y, angle, radius, color, lineWidth) ->
    lineWidth = (if typeof (lineWidth) is "number" then lineWidth else 1)
    color = (if typeof (color) is "number" then color else 0xffffff)
    g.lineStyle lineWidth, 0x000000, 1
    g.beginFill color, 1.0
    g.drawCircle x, y, -radius    
    g.endFill()
    
    # line from center to edge
    g.moveTo x, y
    g.lineTo x + radius * Math.cos(-angle), y + radius * Math.sin(-angle)

  drawLine: (g, len, color, lineWidth) ->
    lineWidth = (if typeof (lineWidth) is "number" then lineWidth else 1)
    color = (if typeof (color) is "undefined" then 0x000000 else color)
    g.lineStyle lineWidth*5, color, 1
    # Draw the actual plane
    g.moveTo -len / 2, 0
    g.lineTo len / 2, 0


  drawConvex: (g, verts, triangles, color, fillColor, lineWidth, debug, offset) ->
    lineWidth = (if typeof (lineWidth) is "number" then lineWidth else 1)
    color = (if typeof (color) is "undefined" then 0x000000 else color)
    unless debug
      g.lineStyle lineWidth, color, 1
      g.beginFill fillColor
      i = 0

      while i isnt verts.length
        v = verts[i]
        x = v[0]
        y = v[1]
        if i is 0
          g.moveTo x, -y
        else
          g.lineTo x, -y
        i++
      g.endFill()
      if verts.length > 2
        g.moveTo verts[verts.length - 1][0], - verts[verts.length - 1][1]
        g.lineTo verts[0][0], - verts[0][1]
    else
      colors = [
        0xff0000
        0x00ff00
        0x0000ff
      ]
      i = 0

      while i isnt verts.length + 1
        v0 = verts[i % verts.length]
        v1 = verts[(i + 1) % verts.length]
        x0 = v0[0]
        y0 = v0[1]
        x1 = v1[0]
        y1 = v1[1]
        g.lineStyle lineWidth, colors[i % colors.length], 1
        g.moveTo x0, -y0
        g.lineTo x1, -y1
        g.drawCircle x0, -y0, lineWidth * 2
        i++
      g.lineStyle lineWidth, 0x000000, 1
      g.drawCircle offset[0], offset[1], lineWidth * 2

  drawPath: (g, path, color, fillColor, lineWidth) ->
    lineWidth = (if typeof (lineWidth) is "number" then lineWidth else 1)
    color = (if typeof (color) is "undefined" then 0x000000 else color)
    g.lineStyle lineWidth, color, 1
    g.beginFill fillColor  if typeof (fillColor) is "number"
    lastx = null
    lasty = null
    i = 0

    while i < path.length
      v = path[i]
      x = v[0]
      y = v[1]
      if x isnt lastx or y isnt lasty
        if i is 0
          g.moveTo x, y
        else
          
          # Check if the lines are parallel
          p1x = lastx
          p1y = lasty
          p2x = x
          p2y = y
          p3x = path[(i + 1) % path.length][0]
          p3y = path[(i + 1) % path.length][1]
          area = ((p2x - p1x) * (p3y - p1y)) - ((p3x - p1x) * (p2y - p1y))
          g.lineTo x, y  unless area is 0
        lastx = x
        lasty = y
      i++
    g.endFill()  if typeof (fillColor) is "number"
    
    # Close the path
    if path.length > 2 and typeof (fillColor) is "number"
      g.moveTo path[path.length - 1][0], path[path.length - 1][1]
      g.lineTo path[0][0], path[0][1]
  
  drawPlane: (g, x0, x1, color, lineColor, lineWidth, diagMargin, diagSize, maxLength, angle) ->
    lineWidth = (if typeof (lineWidth) is "number" then lineWidth else 1)
    color = (if typeof (color) is "undefined" then 0xffffff else color)
    g.lineStyle lineWidth, lineColor, 11
    g.beginFill color
    max = maxLength
  

    g.moveTo(x0, -x1)

    xd = x0 + Math.cos(angle) * @game.width
    yd = x1 + Math.sin(angle) * @game.height
    g.lineTo(xd,-yd)
    
    #a plane has a center from which we start drawin
    #so draw again in the opposite direction for a full line
    g.moveTo(x0, -x1)
    xd = x0 + Math.cos(angle) * -@game.width
    yd = x1 + Math.sin(angle) * -@game.height
    g.lineTo(xd,-yd)

  #color helper methods
  randomPastelHex: ->
    mix = [255,255,255];
    red =   Math.floor(Math.random()*256);
    green = Math.floor(Math.random()*256);
    blue =  Math.floor(Math.random()*256);

    # mix the color
    red =   Math.floor((red +   3*mix[0]) / 4);
    green = Math.floor((green + 3*mix[1]) / 4);
    blue =  Math.floor((blue +  3*mix[2]) / 4);
    return @rgbToHex(red,green,blue)
  
  rgbToHex: (r, g, b)->
    @componentToHex(r) + @componentToHex(g) + @componentToHex(b)
  
  componentToHex: (c)->
    hex = c.toString(16);
    if hex.len == 2 then hex else hex + '0'
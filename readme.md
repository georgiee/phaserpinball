# Pinball Prototype with Phaser (+ p2)
This demo includes a custom debug drawer for the physics copied & dervived from the p2 js PIXI example.

p2: https://github.com/schteppe/p2.js
phaser: https://github.com/georgiee/phaser

See folder ./build for a compiled example
This proejct is based on static page generator middleman http://middlemanapp.com/

## Usage
  + Key Z & X for the flippers
  + Click to palce a circle or rectangle anywhere 
  + Press a direction key (left, top, right, bottom) during a click
  + to add some velocity in that direction

## Other
  + Polygons were built using PhysicsEditor
  + Flippers are built with a RevoluteJoint and a strong motor
  + The Table itself is a large set of shapes
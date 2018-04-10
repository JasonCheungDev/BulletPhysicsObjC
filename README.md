# BulletPhysicsObjC

## Quick Setup: 
Most of the physics and OpenGL setup is done in BulletPhysics.mm. Edit the SetupObjects() function to get started right away. 

## Details:
This project is an extension of Borna's BulletPhysics project and our OpenGL assignments. This comes with obj file reading and a demo of a sphere and box falling onto the ground. To render anything you need to draw GameObjects. 

GameObjects contain four components
- Model : Vertices and indices of your model data. 
- Material : Visual appearance of your object. (Texture and color) 
- Transform : Model offset position, rotation, and scale. (if model is off centered or if you need to **visually** scale it up)
- Rigidbody : Bullet Physics object that handles collision and **actual object position** in the world. 

Check SetupObjects() in BulletPhysics.mm to see how to initialize. Model and Materials can be shared between GameObjects; GameObjects should have their own Transform and Rigidbody. 

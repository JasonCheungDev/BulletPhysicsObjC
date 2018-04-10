//
//  BulletPhysics.m
//  BulletTest
//
//  Created by Borna Noureddin on 2015-03-20.
//  Copyright (c) 2015 BCIT. All rights reserved.
//

#import "BulletPhysics.h"
//#include "bullet-2.82-r2704/src/btBulletDynamicsCommon.h"
#include "btBulletDynamicsCommon.h"
#import "GameObject.h"
#import "ObjReader.h"
#import "Renderer.h"

@interface BulletPhysics()
{
    // physics world
    btBroadphaseInterface *broadphase;
    btDefaultCollisionConfiguration *collisionConfiguration;
    btCollisionDispatcher *dispatcher;
    btSequentialImpulseConstraintSolver *solver;
    btDiscreteDynamicsWorld *dynamicsWorld;
    
    // ground stuff
    btCollisionShape *groundShape;
    btDefaultMotionState *groundMotionState;
    btRigidBody *groundRigidBody;
    
    // rendering stuff
    Renderer* renderer;
    NSMutableArray* gameObjects;
}

@end

@implementation BulletPhysics

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // SETUP PHYSICS WORLDS
        broadphase = new btDbvtBroadphase();
        collisionConfiguration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(collisionConfiguration);
        solver = new btSequentialImpulseConstraintSolver;

        dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher,broadphase,solver,collisionConfiguration);
        dynamicsWorld->setGravity(btVector3(0,-10,0));
        
        NSLog(@"Starting bullet physics...\n");
    }
    return self;
}

- (void)dealloc
{
    dynamicsWorld->removeRigidBody(groundRigidBody);
    delete groundRigidBody->getMotionState();
    delete groundRigidBody;
    delete groundShape;
    
    delete dynamicsWorld;
    delete solver;
    delete collisionConfiguration;
    delete dispatcher;
    delete broadphase;
    NSLog(@"Ending bullet physics...\n");
}

// additional setup after init
-(void)SetupContext:(GLKView *)glkview
{
    renderer = [[Renderer alloc] init];
    [renderer setup:glkview];
    gameObjects = [NSMutableArray array];
}

// when initial setup is done, spawn objects in the world
-(void)SetupObjects
{
    // GAME ENGINE
    
    // Create some shared resources
    ObjReader* objReader = [[ObjReader alloc] init];
    Model* cubeModel = [objReader Read :@"cube"];
    Model* sphereModel = [objReader Read :@"sphere"];
    Model* tileModel = [objReader Read:@"tile"];
    Material* floorMat = [[Material alloc] init];
    [floorMat LoadTexture:@"floor.jpg"];
    Material* mat = [[Material alloc] init];
    [mat LoadTexture:@"wallBothSides.jpg"];
    
    
    // Game object (floor)
    GameObject* floor = [[GameObject alloc] init];
    [floor.transform SetScale:10];    // the physics plane extends infinitely, so we'll just make this large. 
    floor.model = tileModel;
    floor.material = floorMat;
    
    groundShape = new btStaticPlaneShape(btVector3(0,1,0),0);   // (normal, thickness)
    groundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,-1,0))); // (rotation, position)
    btRigidBody::btRigidBodyConstructionInfo groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
    groundRigidBody = new btRigidBody(groundRigidBodyCI);
    dynamicsWorld->addRigidBody(groundRigidBody);
    floor.rigidbody = groundRigidBody;
    
    // Game object 1 (sphere)
    GameObject* go = [[GameObject alloc] init];
    [go.transform SetScale:0.5];    // this model has radius 2, so we'll scale it down to have radius 1
    go.model = sphereModel;
    go.material = mat;

    btSphereShape* physicsSphereShape = new btSphereShape(1);
    btDefaultMotionState* physicsSphereMotion = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(2,5,3)));
    btScalar physicsSphereMass = 1;
    btVector3 physicsSphereInertia(0,0,0);
    physicsSphereShape->calculateLocalInertia(physicsSphereMass, physicsSphereInertia);
    btRigidBody::btRigidBodyConstructionInfo physicsSphereRbCi(physicsSphereMass,physicsSphereMotion,physicsSphereShape,physicsSphereInertia);
    btRigidBody* physicsSphereRb = new btRigidBody(physicsSphereRbCi);
    dynamicsWorld->addRigidBody(physicsSphereRb);   // add to physics world
    go.rigidbody = physicsSphereRb;
    
    
    // Game object 2 (cube)
    GameObject* go2 = [[GameObject alloc] init];
    // [go2.transform SetScale: 1];    // this model has radius 0.5 (same as physics obj), so no need to change.
    go2.model = cubeModel;
    go2.material = mat;
    
    btVector3 cubeShapeHalfExtents(0.5,0.5,0.5);  // 1x1x1 cube
    btBoxShape* physicsCubeShape = new btBoxShape(cubeShapeHalfExtents);
    btDefaultMotionState* physicsCubeMotion = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(-2,5,3)));
    btScalar physicsCubeMass = 1;
    btVector3 physicsCubeInertia(0,0,0);
    physicsCubeShape->calculateLocalInertia(physicsCubeMass, physicsCubeInertia);
    btRigidBody::btRigidBodyConstructionInfo physicsCubeRbCi(physicsCubeMass,physicsCubeMotion,physicsCubeShape,physicsCubeInertia);
    btRigidBody* physicsCubeRb = new btRigidBody(physicsCubeRbCi);
    dynamicsWorld->addRigidBody(physicsCubeRb);   // add to physics world
    go2.rigidbody = physicsCubeRb;
    
    // Add to draw list
    [gameObjects addObject:go];
    [gameObjects addObject:go2];
    [gameObjects addObject:floor];

    // Camera lol
    [Renderer setCameraPosition:GLKVector3Make(0, 3, -10)];
    [Renderer setCameraYRotation:180];
    [Renderer setCameraXRotation:0];
}

-(void)Update:(float)elapsedTime
{
    dynamicsWorld->stepSimulation(1/60.f,10);
    
    GameObject* go = [gameObjects firstObject];
    btTransform trans;
    go.rigidbody->getMotionState()->getWorldTransform(trans);
    btTransform floorTrans;
    groundRigidBody->getMotionState()->getWorldTransform(floorTrans);
    NSLog(@"%f\t%f\t%f\n", elapsedTime*1000, trans.getOrigin().getY(), floorTrans.getOrigin().getY());
}

-(void)Draw
{
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    for (int i = 0; i < gameObjects.count; i++)
    {
        [renderer drawGameObject :[gameObjects objectAtIndex:i]];
    }
}

@end

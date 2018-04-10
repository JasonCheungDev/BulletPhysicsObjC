//
//  GameObject.m
//  iosMaze
//
//  Created by Jason Cheung on 2018-03-19.
//  Copyright © 2018 Maze Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transform.h"
#import "Model.h"
#import "Material.h"

#import "BulletPhysics.h"
#include "btBulletDynamicsCommon.h"

@interface GameObject : NSObject

@property Transform* transform;     // Offset of the model (if model is not centered or if you want to scale the visuals)
@property Model* model;             // Model data (vertices + indices)
@property Material* material;       // Visual data of the object (texture, color, etc.)
@property btRigidBody* rigidbody;   // Physics object. Position of the object in the world.

@end


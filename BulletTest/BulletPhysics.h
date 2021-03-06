//
//  BulletPhysics.h
//  BulletTest
//
//  Created by Borna Noureddin on 2015-03-20.
//  Copyright (c) 2015 BCIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface BulletPhysics: NSObject

-(void)SetupContext:(GLKView*)glkview;
-(void)SetupObjects;
-(void)Update:(float)elapsedTime;
-(void)Draw;

@end

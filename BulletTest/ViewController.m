//
//  ViewController.m
//  BulletTest
//
//  Created by Borna Noureddin on 2015-03-20.
//  Copyright (c) 2015 BCIT. All rights reserved.
//

#import "ViewController.h"
#import "BulletPhysics.h"
#include <GLKit/GLKVector3.h>

@interface ViewController ()
{
    BulletPhysics *bp;
    IBOutlet UILabel *ObjectPositionLabel;
    IBOutlet UILabel *GravityLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bp = [[BulletPhysics alloc] init];
    [bp SetupContext:self.view];
    [bp SetupObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    if (!bp) return;
    [bp Update:self.timeSinceLastUpdate];
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [bp Draw];
    
    GLKVector3 pos = [bp GetObjectPosition];
    ObjectPositionLabel.text = [NSString stringWithFormat:@"Pos(%.2f,%.2f,%.2f)", pos.x, pos.y, pos.z];
    
    GLKVector3 grav = [bp GetGravity];
    GravityLabel.text = [NSString stringWithFormat:@"Gravity: %.2f", grav.y];
}

// MARK:- Gestures

- (IBAction)OnSingleTap:(UITapGestureRecognizer *)sender {
    [bp OnSingleTap];
}

- (IBAction)OnDoubleTap:(UITapGestureRecognizer *)sender {
    [bp OnDoubleTap];
}

- (IBAction)OnPan:(UIPanGestureRecognizer *)sender {
    const float speed = 5.0;
    CGPoint translation = [sender translationInView:sender.view];
    [bp OnDrag :-translation.x * speed :-translation.y * speed];
}

@end

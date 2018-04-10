//
//  ViewController.m
//  BulletTest
//
//  Created by Borna Noureddin on 2015-03-20.
//  Copyright (c) 2015 BCIT. All rights reserved.
//

#import "ViewController.h"
#import "BulletPhysics.h"
#import "BulletPhysics.h"

@interface ViewController ()
{
    BulletPhysics *bp;
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
}

@end

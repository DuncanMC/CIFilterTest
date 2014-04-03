//
//  PointView.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/31/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "PointView.h"
#import "Utils.h"

@implementation PointView

+ (Class)layerClass
{
  return [CAShapeLayer class];
}
//------------------------------------------------------------------------------------------------------
#pragma mark - PropertyMethods
//------------------------------------------------------------------------------------------------------


- (void) doInitSetup;
{
  CAShapeLayer *theLayer = (CAShapeLayer *)self.layer;

  CGRect boxRect;
  CGRect secondRect;
  
  boxRect = [Utils centerRect: CGRectMake(0, 0, 20, 20) inRect: theLayer.bounds];
  secondRect = [Utils centerRect: CGRectMake(0, 0, 3, 3) inRect: theLayer.bounds];
  
  UIBezierPath *path;
  UIBezierPath *secondPath;
  
  path = [UIBezierPath bezierPathWithRect: boxRect];
  secondPath = [UIBezierPath bezierPathWithRect: secondRect];
  
  [path appendPath: secondPath];
  

  secondRect = [Utils centerRect: CGRectMake(0, 0, 30, 30) inRect: theLayer.bounds];
  secondPath = [UIBezierPath bezierPathWithRect: secondRect];
  [path appendPath: secondPath];

  theLayer.lineWidth = 2.0;
  
  theLayer.path = path.CGPath;
  theLayer.fillColor = [UIColor clearColor].CGColor;
  theLayer.strokeColor = [UIColor blackColor].CGColor;
  
//  theLayer.borderWidth = 1;
//  theLayer.borderColor = [UIColor lightGrayColor].CGColor;
  //---------------
  CAShapeLayer *whiteShapeLayer = [CAShapeLayer layer];
  whiteShapeLayer.frame = theLayer.bounds;
  boxRect = [Utils centerRect: CGRectMake(0, 0, 18, 18) inRect: theLayer.bounds];
  path = [UIBezierPath bezierPathWithRect: boxRect];

  secondRect = [Utils centerRect: CGRectMake(0, 0, 22, 22) inRect: theLayer.bounds];
  secondPath = [UIBezierPath bezierPathWithRect: secondRect];
  [path appendPath: secondPath];

  
  secondRect = [Utils centerRect: CGRectMake(0, 0, 5, 5) inRect: theLayer.bounds];
  secondPath = [UIBezierPath bezierPathWithRect: secondRect];
  [path appendPath: secondPath];
  
  secondRect = [Utils centerRect: CGRectMake(0, 0, 32, 32) inRect: theLayer.bounds];
  secondPath = [UIBezierPath bezierPathWithRect: secondRect];
  [path appendPath: secondPath];

  secondRect = [Utils centerRect: CGRectMake(0, 0, 28, 28) inRect: theLayer.bounds];
  secondPath = [UIBezierPath bezierPathWithRect: secondRect];
  [path appendPath: secondPath];

  whiteShapeLayer.path = path.CGPath;
  whiteShapeLayer.fillColor = [UIColor clearColor].CGColor;
  whiteShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
  [theLayer addSublayer: whiteShapeLayer];
}

//------------------------------------------------------------------------------------------------------

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if (!self)
    return nil;
  [self doInitSetup];
  return self;
}

//------------------------------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self doInitSetup];
    }
    return self;
}

@end

//
//  PointView.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/31/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "PointView.h"

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
  UIBezierPath *path = [UIBezierPath bezierPathWithRect: self.layer.bounds];
  ((CAShapeLayer*)self.layer).path = path.CGPath;
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

- (id) initWithCenter: (CGPoint) center andPointChangedBlock: (pointChangedBlock) thePointChangedBlock;
{
  CGRect frame = CGRectMake(center.x, center.y, 0, 0);
  frame = CGRectInset(frame, 20, 20);
  self = [self initWithFrame: frame];
  if (!self)
    return nil;
  self.thePointChangedBlock = thePointChangedBlock;
  [self doInitSetup];
  return self;
}

//------------------------------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end

//
//  PointButton.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/31/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "PointButton.h"
#import "PointView.h"

@implementation PointButton

//------------------------------------------------------------------------------------------------------

- (void) doInitSetup
{
  self.selectedImageName = @"PointButton Image active";
  self.notSelectedImageName = @"PointButton image inactive";
  {
    _thePoint = [[PointView alloc]
                 initWithCenter: CGPointMake(150,150)
                 andPointChangedBlock:  ^(CGPoint newPoint)
                 {
                   NSLog(@"in pointChanged block");
                 }
                 ];
  }
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
    if (!self)
    {
      return nil;
    }
    return self;
}

- (void) setSelected:(BOOL)selected;
{
  [super setSelected: selected];
 if (self.selected)
 {
 }
}
@end

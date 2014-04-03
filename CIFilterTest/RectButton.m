//
//  RectButton.m
//  CIFilterTest
//
//  Created by Duncan Champney on 4/3/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "RectButton.h"
#import "PointView.h"


@implementation RectButton


//-----------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//-----------------------------------------------------------------------------------------------------------

- (void) setTheExtentRect:(CGRect)theExtentRect
{
  _theExtentRect = theExtentRect;
  
  //Convert the extent rect to coordinates for the 4 corner points.
  
   NSLog(@"Starting extent rect  = %@", NSStringFromCGRect(_theExtentRect));
  CGFloat maxX = CGRectGetMaxX(theExtentRect);
  CGFloat maxY = CGRectGetMaxY(theExtentRect);
  
  //Bottom left
  [self setCenter: theExtentRect.origin
  forPointAtIndex: 2];
  
  //Bottom right
  [self setCenter: CGPointMake(maxX, theExtentRect.origin.y)
  forPointAtIndex: 3];
  
  //Top left
  [self setCenter: CGPointMake(theExtentRect.origin.x, maxY)
  forPointAtIndex: 0];
  
  //Top right
  [self setCenter: CGPointMake(maxX, maxY)
  forPointAtIndex: 1];
  
  NSLog(@"done setting extent rect");
  }

//-----------------------------------------------------------------------------------------------------------
#pragma mark - Object lifecycle methods
//-----------------------------------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------

- (void) doInitSetup;
{
  [super doInitSetup];
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - custom instance methods
//-----------------------------------------------------------------------------------------------------------

- (void) setCenter:(CGPoint)pointCenter forPointAtIndex: (NSUInteger) index;
{
  [super setCenter: pointCenter forPointAtIndex: index];
}

//------------------------------------------------------------------------------------------------------

- (void) pointHasMoved: (UIPanGestureRecognizer *)thePanRecognizer
{
  
  //NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  PointView *thePoint = (PointView *) thePanRecognizer.view;
  NSUInteger index = [thePoints indexOfObject: thePoint];
  if (index == NSNotFound)
  {
    NSLog(@"Gack! index not found!");
    return;
  }
  CGPoint oldPointCenter = thePoint.center;
  CGPoint delta = [thePanRecognizer translationInView: self.pointContainerView];
  
  CGFloat newX = oldPointCenter.x+ delta.x;
  CGFloat newY = oldPointCenter.y + delta.y;
  CGPoint newPoint =  CGPointMake(newX, newY);
  
  //Make sure all 4 corners are inside the container view
  ///and the rect is at least 10x10
  
  //If the new corner point is inside the view  bounds...
  if (CGRectContainsPoint(self.pointContainerView.bounds, newPoint))
  {
    CGPoint otherPointCenter;
    //Check the x position
    if (index %2 == 0)
    {
      //left edge point. Make sure it isn't too far to the right
      CGFloat rightEdge = [thePoints[1] center].x;
      if (newX+10 > rightEdge)
        newX = rightEdge -10;
    }
    else
    {
      //Right edge point. Make sure it isn't too far left.
      CGFloat leftEdge = [thePoints[0] center].x;
      if (newX < leftEdge+10)
        newX = leftEdge +10;
    }
    PointView *otherXPoint = thePoints[(index+2) % 4];
    otherPointCenter = otherXPoint.center;
    otherPointCenter.x = newX;
    otherXPoint.center = otherPointCenter;
    
    //Check the Y position
    PointView *otherYPoint;
    if (index <2)
    {
      //top edge point. Make sure Y isn't too far down
      CGFloat bottomEdge = [thePoints[2] center].y;
      if (newY+10 > bottomEdge)
        newY = bottomEdge -10;
      otherYPoint = thePoints[(index+1) %2];
    }
    else
    {
      //Bottom edge point. Make sure y isn't too far up.
      CGFloat topEdge = [thePoints[0] center].y;
      if (newY < topEdge+10)
        newY = topEdge +10;
      otherYPoint = thePoints[2+(index+1) %2];
    }
    otherPointCenter = otherYPoint.center;
    otherPointCenter.y = newY;
    otherYPoint.center = otherPointCenter;
    
    thePoint.center = CGPointMake(newX, newY);

    
    [thePanRecognizer setTranslation: CGPointZero
                              inView: self.pointContainerView];
    
    CGPoint origin = [self centerForPointAtIndex:2];
    CGPoint oppositeCorner = [self centerForPointAtIndex:1];
    
    CGRect extentRect;
    
    extentRect.origin = origin;
    extentRect.size.width = oppositeCorner.x - origin.x;
    extentRect.size.height = oppositeCorner.y - origin.y;
    NSLog(@"After moving, new origin = %@", NSStringFromCGRect(extentRect));
    if (self.theRectChangedBlock)
    {
      self.theRectChangedBlock(extentRect, _theKey);
    }
  }
}

@end

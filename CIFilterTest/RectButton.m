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

- (void) setSelected:(BOOL)selected;
{
  [super setSelected: selected];
  
  [self showExtentRect];
}

//------------------------------------------------------------------------------------------------------

- (void) setTheExtentRect:(CGRect)theExtentRect
{
  _theExtentRect = theExtentRect;
  
  
  //Convert the extent rect to coordinates for the 4 corner points.
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
  self.selectedImageName = @"RectButton image active";
  self.notSelectedImageName = @"RectButton image inactive";

  
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - custom instance methods
//-----------------------------------------------------------------------------------------------------------

- (void) createExtentRectLayers;
{
  extentRectLayer1 = [CAShapeLayer layer];
  extentRectLayer2 = [CAShapeLayer layer];
  extentRectLayer1.frame = self.pointContainerView.layer.bounds;
  extentRectLayer2.frame = self.pointContainerView.layer.bounds;
  
  extentRectLayer1.fillColor = [UIColor clearColor].CGColor;
  extentRectLayer1.strokeColor = [UIColor blackColor].CGColor;
  extentRectLayer1.lineWidth = 1;

  extentRectLayer2.fillColor = [UIColor clearColor].CGColor;
  extentRectLayer2.strokeColor = [UIColor whiteColor].CGColor;
  extentRectLayer2.lineWidth = 4;
  
  NSArray *dashPattern = @[@8, @4];
  extentRectLayer1.lineDashPattern = dashPattern;
  extentRectLayer2.lineDashPattern = dashPattern;

  [self.pointContainerView.layer addSublayer: extentRectLayer2];
  [self.pointContainerView.layer addSublayer: extentRectLayer1];
}

//-----------------------------------------------------------------------------------------------------------

- (void) showExtentRect;
{
  if (!extentRectLayer1)
    [self createExtentRectLayers];
  if (self.selected)
  {
    CGRect tempRect;
    CGPoint origin;
    CGPoint bottomRight;
    origin = ((PointView*)thePoints[0]).center;
    bottomRight = ((PointView*)thePoints[3]).center;
    tempRect.origin = origin;
    tempRect.size = CGSizeMake(bottomRight.y - origin.y, bottomRight.x = origin.x );
    tempRect.size = _theExtentRect.size;
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect: tempRect];
    extentRectLayer1.path = rectPath.CGPath;
    extentRectLayer2.path = rectPath.CGPath;
  }
  else
  {
    extentRectLayer1.path = nil;
    extentRectLayer2.path = nil;
  }
}

//------------------------------------------------------------------------------------------------------

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
    
    _theExtentRect = extentRect;
    [self showExtentRect];

    //NSLog(@"After moving, new origin = %@", NSStringFromCGRect(extentRect));
    if (self.theRectChangedBlock)
    {
      self.theRectChangedBlock(extentRect, _theKey);
    }
  }
}

@end

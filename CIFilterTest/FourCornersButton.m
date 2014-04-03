//
//  FourCornersButton.m
//  CIFilterTest
//
//  Created by Duncan Champney on 4/2/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "FourCornersButton.h"
#import "PointView.h"


@implementation FourCornersButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self doInitSetup];
        // Initialization code
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//-----------------------------------------------------------------------------------------------------------

- (void) setPointKeys:(NSArray *)pointKeys;
{
  _pointKeys = pointKeys;
  for (int index = 0; index < thePoints.count; index++)
  {
    [thePoints[index] setPointKey: _pointKeys[index]];
  }
}


//------------------------------------------------------------------------------------------------------

- (void) setSelected:(BOOL)selected;
{
  [super setSelected: selected];
  for (int index = 0; index < thePoints.count; index++)
  {
    PointView *thePoint = thePoints[index];
    thePoint.hidden = !selected;
  }
  
  if (self.selected)
  {
  }
}

//------------------------------------------------------------------------------------------------------

- (void) doInitSetup;
{
  [super doInitSetup];
  
  //TODO: replace the images below with appropriate graphics
  self.selectedImageName = @"PointButton Image active";
  self.notSelectedImageName = @"PointButton image inactive";
  self.buttonTitle = @"Four Corners";
  
  _theCGPointValues = [NSMutableArray arrayWithCapacity: 4];
  thePoints = [NSMutableArray arrayWithCapacity: 4];
  for (int index = 0; index < 4; index++)
  {
    PointView *thePoint = [[PointView alloc] initWithFrame: CGRectMake(0,0, 50, 50)];
    thePoints[index] = thePoint;
    thePoint.hidden  = YES;
    thePoint.pointKey = _pointKeys[index];
    UIPanGestureRecognizer *thePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(pointHasMoved:)];
    [thePoint addGestureRecognizer: thePanRecognizer];
  }
}

//------------------------------------------------------------------------------------------------------
- (void) setPointContainerView:(UIView *)pointContainerView;
{
  _pointContainerView = pointContainerView;
  
  for (int index = 0; index < thePoints.count; index++)
  {
    [pointContainerView addSubview: thePoints[index]];
  }
}

//------------------------------------------------------------------------------------------------------


- (CGPoint) centerForPointAtIndex: (NSUInteger) index;
{
  PointView *thePoint = thePoints[index];
  CGPoint pointCenter = thePoint.center;
  pointCenter.y = _pointContainerView.bounds.size.height - pointCenter.y;
  
  return pointCenter;
}

//------------------------------------------------------------------------------------------------------

- (void) setCenter:(CGPoint)pointCenter forPointAtIndex: (NSUInteger) index;
{
  pointCenter.y = _pointContainerView.bounds.size.height - pointCenter.y;
  PointView *thePoint = thePoints[index];
  thePoint.center = pointCenter;
}

//------------------------------------------------------------------------------------------------------

- (void) pointHasMoved: (UIPanGestureRecognizer *)thePanRecognizer
{
  
  //NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  PointView *thePoint = (PointView *) thePanRecognizer.view;
  CGPoint oldPointCenter = thePoint.center;
  CGPoint delta = [thePanRecognizer translationInView: _pointContainerView];
  
  CGPoint newPoint =  CGPointMake(oldPointCenter.x+ delta.x,
                                  oldPointCenter.y + delta.y);
  
  if (CGRectContainsPoint(_pointContainerView.bounds, newPoint))
  {
    thePoint.center = newPoint;
    
    [thePanRecognizer setTranslation: CGPointZero
                              inView: _pointContainerView];
    
    NSUInteger index = [thePoints indexOfObject: thePoint];
    
    if (_thePointChangedBlock)
      _thePointChangedBlock([self centerForPointAtIndex: index], thePoint.pointKey);
  }
}


@end

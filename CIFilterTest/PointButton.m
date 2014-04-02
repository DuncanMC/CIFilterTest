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

//-----------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//-----------------------------------------------------------------------------------------------------------

- (void) setButtonTitle:(NSString *)buttonTitle;
{
  _buttonTitle = buttonTitle;
  customTitleLabel.text = buttonTitle;
}

//------------------------------------------------------------------------------------------------------

- (void) setPointContainerView:(UIView *)pointContainerView;
{
  _pointContainerView = pointContainerView;
  [pointContainerView addSubview: self.thePoint];
}

//------------------------------------------------------------------------------------------------------

- (PointView *)thePoint;
{
  if (!_thePoint)
  {
    _thePoint = [[PointView alloc] initWithDelegate: self];
    _thePoint.hidden = YES;
  }
  return _thePoint;
}

//------------------------------------------------------------------------------------------------------

- (CGPoint) pointCenter;
{
  CGPoint pointCenter = self.thePoint.center;
  pointCenter.y = _pointContainerView.bounds.size.height - pointCenter.y;
  
  return pointCenter;
}

//------------------------------------------------------------------------------------------------------

- (void) setPointCenter:(CGPoint)pointCenter
{
  pointCenter.y = _pointContainerView.bounds.size.height - pointCenter.y;
  self.thePoint.center = pointCenter;
}

//------------------------------------------------------------------------------------------------------

- (void) doInitSetup
{
  
  const CGFloat labelWidth = 120;
  const CGFloat labelHeight = 23;
  CGFloat x = CGRectGetMidX(self.bounds) - labelWidth/2;
  CGFloat y = CGRectGetMaxY(self.bounds) + 3;
  CGRect labelFrame = CGRectMake(x, y, labelWidth, labelHeight);
  customTitleLabel = [[UILabel alloc] initWithFrame: labelFrame];
  customTitleLabel.textAlignment = NSTextAlignmentCenter;
  customTitleLabel.font = [UIFont systemFontOfSize: 14];
  customTitleLabel.textColor =[UIColor blueColor];
  [self addSubview: customTitleLabel];
  
  self.clipsToBounds = NO;

  self.selectedImageName = @"PointButton Image active";
  self.notSelectedImageName = @"PointButton image inactive";
  
  UIPanGestureRecognizer *thePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(pointHasMoved:)];
  //thePanRecognizer.delegate = self;
  [self.thePoint addGestureRecognizer: thePanRecognizer];
}



- (void) pointHasMoved: (UIPanGestureRecognizer *)thePanRecognizer
{

  //NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  CGPoint oldPointCenter = self.thePoint.center;
  CGPoint delta = [thePanRecognizer translationInView: _pointContainerView];
  
  CGPoint newPoint =  CGPointMake(oldPointCenter.x+ delta.x,
                                  oldPointCenter.y + delta.y);
  
  if (CGRectContainsPoint(_pointContainerView.bounds, newPoint))
  {
    self.thePoint.center = newPoint;
    
    [thePanRecognizer setTranslation: CGPointZero
                              inView: _pointContainerView];
    
    if (_thePointChangedBlock)
      _thePointChangedBlock(self.pointCenter);
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

//------------------------------------------------------------------------------------------------------

- (void) setSelected:(BOOL)selected;
{
  [super setSelected: selected];
  self.thePoint.hidden = !selected;
  
  if (self.selected)
  {
  }
}
@end

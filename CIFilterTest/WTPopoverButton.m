//
//  WTPopoverButton.m
//  CIFilterTest
//
//  Created by Duncan Champney on 4/10/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "WTPopoverButton.h"

@implementation WTPopoverButton

//------------------------------------------------------------------------------------------------------
#pragma mark property methods
//------------------------------------------------------------------------------------------------------

- (void) setButtonTitle:(NSString *)buttonTitle;
{
  _buttonTitle = buttonTitle;
  _customTitleLabel.text = buttonTitle;
}

//------------------------------------------------------------------------------------------------------
#pragma custom instance methods
//------------------------------------------------------------------------------------------------------

- (void) triggerValueChangedActions;
{
  NSSet *targets = [self allTargets];
  for (id aTarget in targets)
  {
    NSArray *actions = [self actionsForTarget: aTarget forControlEvent: UIControlEventValueChanged];
    for (NSString *anActionName in actions)
    {
      SEL aSelector = NSSelectorFromString(anActionName);
      [self sendAction: aSelector
                    to: aTarget
              forEvent: nil];
    }
  }
}

//------------------------------------------------------------------------------------------------------

- (void) showVCAsPopoverOrModal;
{
}

//------------------------------------------------------------------------------------------------------

- (void) showPopover;
{
  
  CGRect thesegementedControlRect = [self
                                     convertRect: self.bounds
                                     toView: self.window.rootViewController.view];
  
  [self.thePopover presentPopoverFromRect: thesegementedControlRect
                                   inView: self.window.rootViewController.view
                 permittedArrowDirections: UIPopoverArrowDirectionAny
                                 animated: TRUE];
  
}


//------------------------------------------------------------------------------------------------------
#pragma Object lifecycle methods
//------------------------------------------------------------------------------------------------------

- (void) doInitSetup;
{
  const CGFloat labelWidth = 120;
  const CGFloat labelHeight = 21;
  CGFloat x = CGRectGetMidX(self.bounds) - labelWidth/2;
  CGFloat y = CGRectGetMaxY(self.bounds);
  CGRect labelFrame = CGRectMake(x, y, labelWidth, labelHeight);
  _customTitleLabel = [[UILabel alloc] initWithFrame: labelFrame];
  _customTitleLabel.textAlignment = NSTextAlignmentCenter;
  _customTitleLabel.font = [UIFont systemFontOfSize: 14];
  _customTitleLabel.textColor =[UIColor blueColor];
  [self addSubview: _customTitleLabel];
  
  self.clipsToBounds = NO;
}

//------------------------------------------------------------------------------------------------------



- (id)initWithFrame:(CGRect)frame
{
  NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  self = [super initWithFrame:frame];
  if (self)
  {
    [self doInitSetup];
  }
  return self;
}

//------------------------------------------------------------------------------------------------------
-(id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if (!self)
    return nil;
  [self doInitSetup];
  return self;
}


//------------------------------------------------------------------------------------------------------
#pragma mark touch handling events
//------------------------------------------------------------------------------------------------------

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.highlighted = YES;
  
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.highlighted = NO;
  //allTouches
  NSSet *allTouches = event.allTouches;
  UITouch *aTouch = [allTouches anyObject];
  CGPoint touchPoint = [aTouch locationInView: self];
  if (CGRectContainsPoint(self.bounds, touchPoint))
  {
    [self showVCAsPopoverOrModal];
  }
}


@end

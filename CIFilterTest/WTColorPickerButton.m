//
//  WTColorPickerButton.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/28/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "WTColorPickerButton.h"
#import "NKOColorPickerView.h"
#import "WTColorPickerVC.h"

@implementation WTColorPickerButton

//------------------------------------------------------------------------------------------------------
#pragma mark property methods
//------------------------------------------------------------------------------------------------------

- (void) setButtonTitle:(NSString *)buttonTitle;
{
  _buttonTitle = buttonTitle;
  customTitleLabel.text = buttonTitle;
}

//------------------------------------------------------------------------------------------------------

- (void) setCurrentColor:(UIColor *)currentColor;
{
  if (![currentColor isEqual: _currentColor])
  {
    _currentColor = currentColor;
    self.backgroundColor = _currentColor;
  }
}
//------------------------------------------------------------------------------------------------------
#pragma mark object lifecycle methods
//------------------------------------------------------------------------------------------------------


- (void) doInitSetup
{
  const CGFloat labelWidth = 120;
  const CGFloat labelHeight = 21;
  CGFloat x = CGRectGetMidX(self.bounds) - labelWidth/2;
  CGFloat y = CGRectGetMaxY(self.bounds);
  CGRect labelFrame = CGRectMake(x, y, labelWidth, labelHeight);
  customTitleLabel = [[UILabel alloc] initWithFrame: labelFrame];
  customTitleLabel.textAlignment = NSTextAlignmentCenter;
  customTitleLabel.font = [UIFont systemFontOfSize: 14];
  customTitleLabel.textColor =[UIColor blueColor];
  [self addSubview: customTitleLabel];
  
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
  if (![super initWithCoder: aDecoder])
    return nil;
  [self doInitSetup];
  return self;
}

- (void)didMoveToSuperview
{
  self.layer.borderWidth = 1;
  self.currentColor = [UIColor redColor];
}

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

- (void) showColorPicker;
{
  //NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  WTColorPickerVC* thePopoverViewController = nil;
  
    thePopoverViewController = [[WTColorPickerVC alloc]
                                initWithNibName: nil
                                bundle: nil];
  
  thePopoverViewController.color = _currentColor;
  
  
  //Set up the block of code that gets executed when the user picks a new color.
  thePopoverViewController.didChangeColorBlock = ^(UIColor *color)
  {
    self.currentColor = color;
    [self triggerValueChangedActions];
  };
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
  {
    //presentViewController: animated: completion
    [self.window.rootViewController presentViewController: thePopoverViewController
                                                       animated: TRUE
                                                     completion: nil];
    
    //    [targetView.window.rootViewController presentModalViewController: thePopoverViewController
    //                                                            animated: TRUE];
  }
  else
  {
    self.thePopover = [[UIPopoverController alloc] initWithContentViewController: thePopoverViewController];
    
    self.thePopover.delegate = self;
    [self showPopover];
    
  }

}

//------------------------------------------------------------------------------------------------------

- (void) showPopover;
{
  /*
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  if (!willRotateObserver)
    willRotateObserver = [notificationCenter addObserverForName: kUIOrientationWillChangeNotice
                                                         object: nil
                                                          queue: nil
                                                     usingBlock:
                          ^(NSNotification *note) {
                            //NSLog(@"in willRotate block");
                            [self.thePopover dismissPopoverAnimated: FALSE];
                          }
                          ];
  
  if (!didRotateObserver)
    didRotateObserver = [notificationCenter addObserverForName:  kUIOrientationDidChangeNotice
                                                        object: nil
                                                         queue: nil
                                                    usingBlock:
                         ^(NSNotification *note) {
                           //NSLog(@"in didRotate block");
                           [self showPopover];
                         }
                         ];
  if (!popoverDismissedObserver)
    popoverDismissedObserver = [notificationCenter addObserverForName:  kPopoverDismissedNotice
                                                               object: nil
                                                                queue: nil
                                                           usingBlock:
                                ^(NSNotification *note) {
                                  //NSLog(@"in popoverDismissed block");
                                  [self removeObservers];
                                }
                                ];
  */
  
  CGRect thesegementedControlRect = [self
                                     convertRect: self.bounds
                                     toView: self.window.rootViewController.view];
  
  [self.thePopover presentPopoverFromRect: thesegementedControlRect
                                   inView: self.window.rootViewController.view
                 permittedArrowDirections: UIPopoverArrowDirectionAny
                                 animated: TRUE];
  
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
    [self showColorPicker];
  }
}


@end

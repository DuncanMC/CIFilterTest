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
  [super doInitSetup];
}

//------------------------------------------------------------------------------------------------------

- (void)didMoveToSuperview
{
  self.layer.borderWidth = 1;
  self.currentColor = [UIColor redColor];
}

//------------------------------------------------------------------------------------------------------

- (void) showVCAsPopoverOrModal;
{
  [self showColorPickerAsPopoverOrModal];
}

//------------------------------------------------------------------------------------------------------

- (void) showColorPickerAsPopoverOrModal;
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
  }
  else
  {
    self.thePopover = [[UIPopoverController alloc] initWithContentViewController: thePopoverViewController];
    
    self.thePopover.delegate = self;
    [self showPopover];
    
  }

}

//------------------------------------------------------------------------------------------------------


@end

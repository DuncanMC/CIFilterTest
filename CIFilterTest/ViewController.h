//
//  ViewController.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/24/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

@class PopupMenuControl;

#import <UIKit/UIKit.h>
#import "TableViewSelectionProtocol.h"

@class FiltersList;

#define K_VIEW_BASE_TAG   100
#define K_LABEL_BASE_TAG  10
#define K_VALUE_BASE_TAG  20
#define K_MIN_BASE_TAG    30
#define K_SLIDER_BASE_TAG 40
#define K_MAX_BASE_TAG    50


//---The number of defined settings sliders.
#define K_MAX_SLIDERS 5

@interface ViewController : UIViewController <UITextFieldDelegate, TableViewSelectionProtocol>

{
  __weak IBOutlet UIImageView *theImageView;
  __weak IBOutlet UISwitch *useFilterSwitch;
  __weak IBOutlet UISegmentedControl *positionSelector;
  __weak IBOutlet UISlider *slider1;
  __weak IBOutlet UISlider *slider2;
  __weak IBOutlet UILabel *filterNameLabel;
  __weak IBOutlet UIButton *animateButton;
  __weak IBOutlet PopupMenuControl *theFilterTypePopup;
  
  UIImage         *imageToEdit;
  UIImage         *secondImage;
  NSString        *currentFilterName;
  CIFilter        *currentFilter;
  NSString        *sliderKeys[5];
  NSTimeInterval  start;
  CIVector        *defaultCenterPoint;
  CGFloat         timeValue;
  int             conrtrolIndex;
  
  //iVars used to handle textField editing and keyboard animation
  __weak UITextField* textFieldToEdit;

  id showKeyboardNotificaiton;
  id hideKeyboardNotificaiton;

  CGFloat keyboardShiftAmount;
  CGFloat keyboardSlideDuration;
  NSUInteger keyboardAnimationCurve;

  CGFloat totalDuration;
  int steps;
  CGFloat stepDuration;
}

- (IBAction)handleUseFilterSwitch:(UISwitch *)sender;
- (IBAction)handlePositionSelector:(UISegmentedControl *)sender;
- (IBAction)handleSlider:(UISlider *)sender;
- (IBAction)handleAnimateButton:(UIButton *)sender;

@end

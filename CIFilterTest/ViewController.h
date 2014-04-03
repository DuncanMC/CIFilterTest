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
@class WTColorPickerButton;
@class PointButton;
@class FourCornersButton;
@class RectButton;

#define K_VIEW_BASE_TAG   100
#define K_LABEL_BASE_TAG  10
#define K_VALUE_BASE_TAG  20
#define K_MIN_BASE_TAG    30
#define K_SLIDER_BASE_TAG 40
#define K_MAX_BASE_TAG    50

#define K_COLORWELL_BASE_TAG 200

#define K_POINTBUTTON_BASE_TAG 300

//---The number of defined settings sliders.
#define K_MAX_SLIDERS 6
#define K_MAX_COLORWELLS 2
#define K_MAX_POINTBUTTONS 4

@interface ViewController : UIViewController <UITextFieldDelegate, TableViewSelectionProtocol>

{
    IBOutletCollection(PointButton) NSArray *thePointButtons;
  
  __weak IBOutlet UIImageView *theImageView;
  __weak IBOutlet UISwitch *useFilterSwitch;
  __weak IBOutlet UISegmentedControl *positionSelector;
  __weak IBOutlet UISlider *slider1;
  __weak IBOutlet UISlider *slider2;
  __weak IBOutlet UILabel *filterNameLabel;
  __weak IBOutlet UIButton *animateButton;
  __weak IBOutlet PopupMenuControl *theFilterTypePopup;
  __weak IBOutlet UIView *imageContainerView;
  __weak IBOutlet PointButton *pointButton0;
  __weak IBOutlet FourCornersButton *theFourCornersButton;
  __weak IBOutlet UIView *positionControlView;
  __weak IBOutlet RectButton *theExtentButton;
  
  CIFilter        *_clampFilter;
  CIFilter        *_cropFilter;
  UIImage         *imageToEdit;
  UIImage         *secondImage;
  NSString        *currentFilterName;
  CIFilter        *currentFilter;
  NSString        *sliderKeys[K_MAX_SLIDERS];
  NSString        *colorWellKeys[K_MAX_COLORWELLS];
  NSString        *pointButtonKeys[K_MAX_POINTBUTTONS];
  NSTimeInterval  start;
  CIVector        *defaultCenterPoint;
  CGFloat         timeValue;
  int             sliderControlIndex;
  int             colorWellControlIndex;
  int             pointButtonIndex;
  
  BOOL            scaleUpImage;
  
  //iVars used to handle textField editing and keyboard animation
  __weak UITextField* textFieldToEdit;

  id showKeyboardNotificaiton;
  id hideKeyboardNotificaiton;

  CGSize sourceImageExtent;
  CGFloat keyboardShiftAmount;
  CGFloat keyboardSlideDuration;
  NSUInteger keyboardAnimationCurve;

  CGFloat totalDuration;
  int steps;
  CGFloat stepDuration;
}

//------------------------------------------------------------------------------------------------------
#pragma mark - IBAction methods
//------------------------------------------------------------------------------------------------------

- (IBAction)handleUseFilterSwitch:(UISwitch *)sender;
- (IBAction)handlePositionSelector:(UISegmentedControl *)sender;
- (IBAction)handleSlider:(UISlider *)sender;
- (IBAction)handleAnimateButton:(UIButton *)sender;
- (IBAction)colorWellChanged:(WTColorPickerButton *)sender;
- (IBAction)pointButtonChanged:(PointButton *)sender;

@end

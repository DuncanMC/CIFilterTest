//
//  ViewController.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/24/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

{
  __weak IBOutlet UIImageView *theImageView;
  __weak IBOutlet UISwitch *useFilterSwitch;
  __weak IBOutlet UISegmentedControl *positionSelector;
  __weak IBOutlet UISlider *radiusSlider;
  __weak IBOutlet UISlider *amountSlider;
  
  UIImage *imageToEdit;
  CIImage *outputImage;
  NSString *currentFilterName;
  CIFilter *currentFilter;
}

- (IBAction)handleUseFilterSwitch:(UISwitch *)sender;
- (IBAction)handlePositionSelector:(UISegmentedControl *)sender;
- (IBAction)handleRadiusSlider:(UISlider *)sender;
- (IBAction)handleAmountSlider:(UISlider *)sender;

@end

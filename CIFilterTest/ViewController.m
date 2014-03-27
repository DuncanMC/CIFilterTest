//
//  ViewController.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/24/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "ViewController.h"
#import "PopupMenuControl.h"
#import "FiltersList.h"
#import "FilterCategoryInfo.h"
#import "FilterRecord.h"

@interface ViewController ()

@end

@implementation ViewController

//------------------------------------------------------------------------------------------------------
#pragma mark - Custom instance methods
//------------------------------------------------------------------------------------------------------

- (void) listCIFiltersAndShowInputKeys: (BOOL) listFilterKeys;
{
  
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
  for (FilterCategoryInfo *aCategory in theFiltersList.filterCategoriesExcludingDupes)
  {
    printf("Category %s:\n", [aCategory.categoryName cStringUsingEncoding: NSUTF8StringEncoding]);
    for (FilterRecord *aFilterRecord in aCategory.filterRecordsWithNoDuplicates)

    {
      NSString *aFilterName = aFilterRecord.filterName;
      NSString *aFilterDisplayName = aFilterRecord.filterDisplayName;
      CIFilter *aFilter = [CIFilter filterWithName: aFilterName];
      NSDictionary *attributes = [aFilter attributes];
      printf ("\tfilter %s. (%s)", [aFilterName cStringUsingEncoding: NSUTF8StringEncoding], [aFilterDisplayName cStringUsingEncoding: NSUTF8StringEncoding]);
      NSArray *categories = attributes[kCIAttributeFilterCategories];
      if (categories.count > 1)
      {
        printf("\tCategories:  %s", [categories[0] cStringUsingEncoding: NSUTF8StringEncoding]);
        for (int index = 1; index <categories.count; index++ )
          printf(",  %s", [categories[index] cStringUsingEncoding: NSUTF8StringEncoding]);
      }
      printf("\n");
      NSArray *inputKeys = [aFilter inputKeys];
      if (listFilterKeys)
      {
        if (inputKeys.count)
        {
          printf("\t\tInput keys:");
          for (NSString *anInputKey in inputKeys)
          {
            NSDictionary *attributes = [aFilter attributes];
            //NSString *attributeDisplayName = attributes[anInputKey][kCIAttributeDisplayName];
            NSString *attributeType = attributes[anInputKey][kCIAttributeType];
            NSString *attributeClass = attributes[anInputKey][kCIAttributeClass];
            
            printf("\t%s (%s/%s)",
                   [anInputKey cStringUsingEncoding: NSUTF8StringEncoding],
                   [attributeType cStringUsingEncoding: NSUTF8StringEncoding],
                   [attributeClass cStringUsingEncoding: NSUTF8StringEncoding]
                   );
          }
        }
        NSArray *outputKeys = [aFilter outputKeys];
        if (outputKeys.count)
        {
          if (outputKeys.count >= 1 && ![outputKeys[0] isEqualToString: @"outputImage"])
          {
            NSLog(@"output keys!");
            printf("\t\tOutput keys:");
            for (NSString *anOutputKey in outputKeys)
            {
              printf("\t%s", [anOutputKey cStringUsingEncoding: NSUTF8StringEncoding]);
            }
          }
          printf("\n");
        }
      }
    }
  }
  printf("\n");

  }


/*

  NSMutableArray *uniqueFilterNames = [NSMutableArray new];

  int duplicateCount = 0;
  BOOL listFilterKeys = YES;
  
  NSArray *categories = @[
                          kCICategoryDistortionEffect,
                          kCICategoryGeometryAdjustment,
                          kCICategoryCompositeOperation,
                          kCICategoryHalftoneEffect,
                          kCICategoryColorAdjustment,
                          kCICategoryColorEffect,
                          kCICategoryTransition,
                          kCICategoryTileEffect,
                          kCICategoryGenerator,
                          kCICategoryReduction,
                          kCICategoryGradient,
                          kCICategoryStylize,
                          kCICategorySharpen,
                          kCICategoryBlur,
                          kCICategoryVideo,
                          kCICategoryStillImage,
                          kCICategoryInterlaced,
                          kCICategoryNonSquarePixels,
                          kCICategoryHighDynamicRange ,
                          kCICategoryBuiltIn,];
  
  for (NSString *aCategory in categories)
  {
    printf("Category %s:\n", [aCategory cStringUsingEncoding: NSUTF8StringEncoding]);
    NSArray *filters = [CIFilter filterNamesInCategory: aCategory];
    for (NSString *aFilterName in filters)
    {
      CIFilter *aFilter = [CIFilter filterWithName: aFilterName];
      if ([uniqueFilterNames containsObject: aFilterName])
      {
        duplicateCount++;
        //NSLog(@"duplicate filter named %@", aFilterName);
      }
      else
      {
        [uniqueFilterNames addObject: aFilterName];
        //[aCategory cStringUsingEncoding: NSUTF8StringEncoding]
        //[categories[0] cStringUsingEncoding: NSUTF8StringEncoding]
        //categories[0]
        NSDictionary *attributes = [aFilter attributes];
        NSString *filterDisplayName = attributes[kCIAttributeFilterDisplayName];
        printf ("\tfilter %s. (%s)", [aFilterName cStringUsingEncoding: NSUTF8StringEncoding], [filterDisplayName cStringUsingEncoding: NSUTF8StringEncoding]);
        NSArray *categories = attributes[kCIAttributeFilterCategories];
        if (categories.count > 1)
        {
          printf("\tCategories:  %s", [categories[0] cStringUsingEncoding: NSUTF8StringEncoding]);
          for (int index = 1; index <categories.count; index++ )
            printf(",  %s", [categories[index] cStringUsingEncoding: NSUTF8StringEncoding]);
        }
        printf("\n");
        NSArray *inputKeys = [aFilter inputKeys];
        if (listFilterKeys)
        {
          if (inputKeys.count)
          {
            printf("\t\tInput keys:");
            for (NSString *anInputKey in inputKeys)
            {
              NSDictionary *attributes = [aFilter attributes];
              //NSString *attributeDisplayName = attributes[anInputKey][kCIAttributeDisplayName];
              NSString *attributeType = attributes[anInputKey][kCIAttributeType];
              NSString *attributeClass = attributes[anInputKey][kCIAttributeClass];
              
              printf("\t%s (%s/%s)",
                     [anInputKey cStringUsingEncoding: NSUTF8StringEncoding],
                     [attributeType cStringUsingEncoding: NSUTF8StringEncoding],
                     [attributeClass cStringUsingEncoding: NSUTF8StringEncoding]
                     );
            }
          }
          NSArray *outputKeys = [aFilter outputKeys];
          if (outputKeys.count)
          {
            if (outputKeys.count >= 1 && ![outputKeys[0] isEqualToString: @"outputImage"])
            {
              NSLog(@"output keys!");
              printf("\t\tOutput keys:");
              for (NSString *anOutputKey in outputKeys)
              {
                printf("\t%s", [anOutputKey cStringUsingEncoding: NSUTF8StringEncoding]);
              }
            }
            printf("\n");
          }
        }
      }
    }
    printf("\n");
  }
  //printf("Total of %d unique filters found. Skipped %d duplicates", uniqueFilterNames.count, duplicateCount);
}
 */

//------------------------------------------------------------------------------------------------------
- (void) addControlWithKey: (NSString *)aKey;
{
  int index = conrtrolIndex++;
  sliderKeys[index] = aKey;
  
  int sliderTag = index + K_SLIDER_BASE_TAG;
  UIView *containerView = [self.view viewWithTag: index + K_VIEW_BASE_TAG];

  UISlider *aSlider = (UISlider *)[self.view viewWithTag: sliderTag];
  UILabel *sliderLabel = (UILabel *)[self.view viewWithTag: index + K_LABEL_BASE_TAG];
  UILabel *minLabel = (UILabel *)[self.view viewWithTag: index + K_MIN_BASE_TAG];
  UILabel *maxLabel = (UILabel *)[self.view viewWithTag: index + K_MAX_BASE_TAG];
  UITextView *currentValueTextView = (UITextView *)[self.view viewWithTag: index + K_VALUE_BASE_TAG];
  if (!aSlider || ![aSlider isKindOfClass: [UISlider class]])
  {
    NSLog(@"No slider found with tag %d, ", sliderTag);
    return;
  }
  if (aKey.length == 0)
  {
    containerView.hidden = YES;
    return;
  }
  NSDictionary *attributes = currentFilter.attributes;
  NSDictionary *thisAttribute = attributes[aKey];
  if (!thisAttribute)
  {
    NSLog(@"can't find attribute");
    containerView.hidden = YES;
    return;
  }
  containerView.hidden = NO;

  CGFloat minValue = [thisAttribute[@"CIAttributeSliderMin"] floatValue];
  CGFloat maxValue = [thisAttribute[@"CIAttributeSliderMax"] floatValue];
  CGFloat defaultValue  = [thisAttribute[@"CIAttributeDefault"] floatValue];
  
  aSlider.minimumValue = minValue;
  aSlider.maximumValue = maxValue;
  aSlider.value = defaultValue;
  
  sliderLabel.text = aKey;
  
  minLabel.text = [NSString stringWithFormat: @"%.2f", minValue];
  maxLabel.text = [NSString stringWithFormat: @"%.2f", maxValue];
  currentValueTextView.text = [NSString stringWithFormat: @"%.2f", defaultValue];

}

//------------------------------------------------------------------------------------------------------

- (void) showImage;
{
  CIImage *outputImage;
  UIImage *outputUIImage;

  if (useFilterSwitch.isOn)
  {
    outputImage = [currentFilter valueForKey: kCIOutputImageKey];
    outputUIImage = [UIImage imageWithCIImage: outputImage];
  }
  else
  {
    outputImage = [currentFilter valueForKey: kCIInputImageKey];
    outputUIImage = imageToEdit;
  }
  
  theImageView.image = outputUIImage;
}

//------------------------------------------------------------------------------------------------------

- (void) clearControls;
{
  conrtrolIndex = 0;
  for (int index = 0; index < K_MAX_SLIDERS; index++)
  {
    UIView *controlsView = [self.view viewWithTag: K_VIEW_BASE_TAG + index];
    controlsView.hidden = YES;
    sliderKeys[index] = nil;
  }
}

//------------------------------------------------------------------------------------------------------

- (void) doSetup;
{
  
  
  //CIHoleDistortion, CIBumpDistortion, CIBumpDistortionLinear, CIHoleDistortion, CIGaussianBlur, CIPinchDistortion, CIBarsSwipeTransition
  
  
  currentFilter = [CIFilter filterWithName: currentFilterName];
  [currentFilter setDefaults];
  

  
  NSDictionary *attributes = currentFilter.attributes;
  //NSLog(@"Filter %@ attributes = %@", currentFilterName, attributes);
  NSString *filterName = attributes[@"CIAttributeFilterDisplayName"];
  filterNameLabel.text = filterName;

  animateButton.enabled = [attributes objectForKey: @"inputTime"] != nil;
  positionSelector.selectedSegmentIndex = 0;

  if ([attributes objectForKey: kCIInputImageKey])
  {
    imageToEdit = [UIImage imageNamed: @"Sample image"];
    CIImage *sourceCIImage = [CIImage imageWithCGImage: imageToEdit.CGImage];
    [currentFilter setValue: sourceCIImage
                     forKey: kCIInputImageKey];

  }

  if ([attributes objectForKey: kCIInputColorKey])
  {
    CIColor *inputColor = [CIColor colorWithRed: 1.0 green: 0 blue: 0 alpha: 1.0];
    [currentFilter setValue: inputColor
                     forKey: kCIInputColorKey];
    
  }

  if ([attributes objectForKey: @"inputColor0"])
  {
    CIColor *inputColor = [CIColor colorWithRed: 1.0 green: 0 blue: 0 alpha: 1.0];
    [currentFilter setValue: inputColor
                     forKey: @"inputColor0"];
    
  }

  if ([attributes objectForKey: @"inputColor1"])
  {
    CIColor *inputColor = [CIColor colorWithRed: 0 green: 1.0 blue: 0 alpha: 1.0];
    [currentFilter setValue: inputColor
                     forKey: @"inputColor1"];
    
  }


  
  //inputMaskImage
  if ([attributes objectForKey: kCIInputMaskImageKey])
  {
    UIImage *maskImage = [UIImage imageNamed: @"Mask image"];
    CIImage *maskCIImage = [CIImage imageWithCGImage: maskImage.CGImage];
    
    
    [currentFilter setValue: maskCIImage
                     forKey: kCIInputMaskImageKey];
    
  }

  if ([attributes objectForKey: @"inputTargetImage"])
  {
    secondImage = [UIImage imageNamed: @"Sample image #2"];
    CIImage *secondCIImage = [CIImage imageWithCGImage: secondImage.CGImage];
    
    
    [currentFilter setValue: secondCIImage
                     forKey: kCIInputTargetImageKey];
    
  }

  if ([attributes objectForKey: @"inputPoint"])
  {
    
    CIVector *imageCenterVector = [CIVector vectorWithX: imageToEdit.size.width/2.0
                                                      Y: imageToEdit.size.height/2.0];
    [currentFilter setValue: imageCenterVector
                     forKey: @"inputPoint"];

  }


  [self clearControls];
  
  NSMutableArray *inputKeys = [[currentFilter inputKeys] mutableCopy];
  
  //If this filter as an "inputTime" key, and it's not the first item, move it to the first position
  NSUInteger index = [inputKeys indexOfObject: kCIInputTimeKey];
  if (index != NSNotFound && index != 0)
  {
    NSString *key0 = inputKeys[0];
    NSString *timeKey = inputKeys[index];
    [inputKeys replaceObjectAtIndex: 0
                         withObject: timeKey];
    [inputKeys replaceObjectAtIndex: index
                         withObject: key0];
  }
  
  for (NSString *thisKey in inputKeys)
  {
    NSDictionary *thisInputDict = [attributes objectForKey: thisKey];
    //Find all keys that contain slider information add add them to the controls
    if (thisInputDict[kCIAttributeSliderMax] != nil)
      [self addControlWithKey: thisKey];

  }
  
  /*
  if ([currentFilterName isEqualToString: @"CIBumpDistortion"] ||
      [currentFilterName isEqualToString: @"CIBumpDistortionLinear"] ||
      [currentFilterName isEqualToString: @"CIPinchDistortion"] ||
      [currentFilterName isEqualToString: @"CIGaussianBlur"]      )
  {
    [self addControlWithKey: @"inputRadius"];
    [self addControlWithKey: @"inputScale"];
    [self addControlWithKey: @"inputAngle"];
  }
  else if ([currentFilterName isEqualToString: @"CISharpenLuminance"])
  {
    [self addControlWithKey: @"inputSharpness"];
  }
  else if ([currentFilterName isEqualToString: @"CIUnsharpMask"])
  {
    [self addControlWithKey: @"inputRadius"];
    [self addControlWithKey: @"inputIntensity"];
  }
  else if ([currentFilterName isEqualToString: @"CIBarsSwipeTransition"] ||
           [currentFilterName isEqualToString: @"CIDissolveTransition"]
           )
  {
    [self addControlWithKey: @"inputTime"];
    [self addControlWithKey: @"inputAngle"];
    [self addControlWithKey: @"inputWidth"];
    [self addControlWithKey: @"inputBarOffset"];
  }
  else if ([currentFilterName isEqualToString: @"CICopyMachineTransition"] ||
           [currentFilterName isEqualToString: @"CISwipeTransition"]
            )
  {
    [self addControlWithKey: @"inputTime"];
    [self addControlWithKey: @"inputAngle"];
    [self addControlWithKey: @"inputWidth"];
    [self addControlWithKey: @"inputOpacity"];
  }
  else if ([currentFilterName isEqualToString: @"CIModTransition"])
  {
    [self addControlWithKey: @"inputTime"];
    [self addControlWithKey: @"inputAngle"];
    [self addControlWithKey: @"inputRadius"];
    [self addControlWithKey: @"inputCompression"];
  }
  else if ([currentFilterName isEqualToString: @"CIDisintegrateWithMaskTransition"])
  {
    [self addControlWithKey: @"inputTime"];
    [self addControlWithKey: @"inputShadowRadius"];
    [self addControlWithKey: @"inputShadowDensity"];
  }
   */

  if (![attributes objectForKey: @"inputCenter"])
  {
    positionSelector.enabled = NO;
  }
  else
  {
    positionSelector.enabled = YES;

    defaultCenterPoint = [currentFilter valueForKey: @"inputCenter"];
  }
  if ([currentFilterName isEqualToString: @"CIBumpDistortion"])
    NSLog(@"After creating CIBumpDistortion filter, default inputCenter = %@\n", defaultCenterPoint);
}

//------------------------------------------------------------------------------------------------------

- (void) animate;
{
  int index = 0;
  for (index = 0; index < K_MAX_SLIDERS; index++)
    if ([sliderKeys[index] isEqualToString: kCIInputTimeKey])
         break;
  UITextField *valueField = (UITextField *)[self.view viewWithTag: index + K_VALUE_BASE_TAG];
  valueField.text = [NSString stringWithFormat: @"%.2f", timeValue];
  NSString *aKey = sliderKeys[index];
  
  valueField.text = [NSString stringWithFormat: @"%.2f", timeValue];
  
  start = [NSDate timeIntervalSinceReferenceDate];
  [currentFilter setValue: @(timeValue) forKey: aKey];
  
  UISlider *slider = (UISlider *)[self.view viewWithTag: index + K_SLIDER_BASE_TAG];
  slider.value = timeValue;
  
  [self showImage];
  timeValue += 1.0/steps;
  if (timeValue < 1+1.0/steps)
    [self performSelector: @selector(next) withObject: nil afterDelay:0];
  else
  {
    [self enableSliders: YES];
    animateButton.enabled = YES;
    //NSLog(@"Ending animation");

  }
}

- (void) next;
{
  NSTimeInterval delta;
  delta = [NSDate timeIntervalSinceReferenceDate] - start;
  //NSLog(@"Processing time = %.6f. stepDuration = %.6f", delta, stepDuration);
  CGFloat delay = 0;
  if (delta < stepDuration)
    delay = stepDuration- delta;
  [self performSelector: @selector(animate) withObject: nil afterDelay: delay];
}

//------------------------------------------------------------------------------------------------------

- (void) changeValue: (CGFloat) newValue forIndex: (NSInteger) index;
{
  NSString *aKey = sliderKeys[index];
 [currentFilter setValue: @(newValue) forKey: aKey];
  [self showImage];

}

//------------------------------------------------------------------------------------------------------

- (void) enableSliders: (BOOL) enable;
{
  int tag;
  for (int index = 0; index < K_MAX_SLIDERS; index++)
  {
    tag = K_SLIDER_BASE_TAG + index;
    UISlider *aSlider = (UISlider *)[self.view viewWithTag: tag];
    aSlider.enabled = enable;
  }
}
//------------------------------------------------------------------------------------------------------
#pragma mark - VC Lifecycle methods
//------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
  [super viewDidLoad];
  showKeyboardNotificaiton = [[NSNotificationCenter defaultCenter] addObserverForName: UIKeyboardWillShowNotification
                              
                                                                               object: nil
                                                                                queue: nil
                                                                           usingBlock: ^(NSNotification *note)
                              {
                                CGRect keyboardFrame;
                                NSDictionary* userInfo = note.userInfo;
                                keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
                                keyboardAnimationCurve = [[userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16;
                                
                                UIInterfaceOrientation theStatusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                                
                                CGFloat keyboardHeight;
                                if UIInterfaceOrientationIsLandscape(theStatusBarOrientation)
                                  keyboardHeight = keyboardFrame.size.width;
                                else
                                  keyboardHeight = keyboardFrame.size.height;
                                
                                CGRect fieldFrame = textFieldToEdit.bounds;
                                fieldFrame = [self.view convertRect: fieldFrame fromView: textFieldToEdit];
                                CGRect contentFrame = self.view.frame;
                                CGFloat fieldBottom = fieldFrame.origin.y + fieldFrame.size.height;
                                
                                keyboardShiftAmount= 0;
                                if (contentFrame.size.height - fieldBottom <keyboardHeight)
                                {
                                  keyboardShiftAmount = keyboardHeight - (contentFrame.size.height - fieldBottom);
                                  if (theStatusBarOrientation == UIInterfaceOrientationPortraitUpsideDown ||
                                      theStatusBarOrientation == UIInterfaceOrientationLandscapeRight)
                                    keyboardShiftAmount *= -1;
                                  
                                  //                                  keyboardConstraint.constant -= keyboardShiftAmount;
                                  //                                  keyboardBottomConstraint.constant += keyboardShiftAmount;
                                  [UIView animateWithDuration: keyboardSlideDuration
                                                        delay: 0
                                                      options: keyboardAnimationCurve
                                                   animations:
                                   ^{
                                     CGRect frame = self.view.frame;
                                     frame.origin.y -= keyboardShiftAmount;
                                     self.view.frame = frame;
                                   }
                                                   completion: nil
                                   ];
                                }
                              }
                              ];
  hideKeyboardNotificaiton = [[NSNotificationCenter defaultCenter] addObserverForName: UIKeyboardWillHideNotification
                                                                               object: nil
                                                                                queue: nil
                                                                           usingBlock: ^(NSNotification *note)
                              {
                                if (keyboardShiftAmount != 0)
                                  [UIView animateWithDuration: keyboardSlideDuration
                                                        delay: 0
                                                      options: keyboardAnimationCurve
                                                   animations:
                                   ^{
                                     CGRect frame = self.view.frame;
                                     frame.origin.y += keyboardShiftAmount;
                                     self.view.frame = frame;
                                     
                                     //                                     keyboardConstraint.constant += keyboardShiftAmount;
                                     //                                     keyboardBottomConstraint.constant -= keyboardShiftAmount;
                                     //                                     [self.view setNeedsUpdateConstraints];
                                     //                                     [viewToShift layoutIfNeeded];
                                   }
                                                   completion: nil
                                   ];
                                
                                
                              }
                              ];
  

}


//------------------------------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL)animated
{
  //[self listCIFiltersAndShowInputKeys: YES];
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
  theFilterTypePopup.choices = [theFiltersList.uniqueFilterNames copy];
  theFilterTypePopup.delegate = self;
  theFilterTypePopup.selectedIndex = 77;
  currentFilterName = theFiltersList.uniqueFilterNames[77];
  [self doSetup];
  [self showImage];
}

//------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------------------

- (IBAction)handleUseFilterSwitch:(UISwitch *)sender
{
  [self showImage];
}

//------------------------------------------------------------------------------------------------------

- (IBAction)handlePositionSelector:(UISegmentedControl *)sender
{
  CGFloat x = 0;
  NSInteger index = positionSelector.selectedSegmentIndex;
  switch (index)
  {
    case 0:
      [currentFilter setValue: defaultCenterPoint forKey: @"inputCenter"];
      [self showImage];
      return;
    case 1:
      x = 0;
      break;
    case 2:
      x = imageToEdit.size.width/2.0;
      break;
  }
  if (index == 0)
  {
    //Recreate the initial state (bug), where there is no inputCenter key in the dictionary
    NSLog(@"Deleting the inputCenter key from the filter.");
    [currentFilter setValue: nil forKey: @"inputCenter"];
  }
  else
  {
    CIVector *imageCenterVector = [CIVector vectorWithX: x
                                                      Y: imageToEdit.size.height/2.0];
  [currentFilter setValue: imageCenterVector forKey: @"inputCenter"];
  }

  [self showImage];
}

//------------------------------------------------------------------------------------------------------

- (IBAction)handleSlider:(UISlider *)sender
{
  NSInteger index = sender.tag - K_SLIDER_BASE_TAG;
  CGFloat newValue = sender.value;
  
  UITextField *valueField = (UITextField *)[self.view viewWithTag: index + K_VALUE_BASE_TAG];
  valueField.text = [NSString stringWithFormat: @"%.2f", newValue];

  start = [NSDate timeIntervalSinceReferenceDate];
  [self changeValue: newValue forIndex: index];
}

//------------------------------------------------------------------------------------------------------


- (IBAction)handleAnimateButton:(UIButton *)sender
{
  //NSLog(@"Starting animation");
  totalDuration = 3;
  steps = 60;
  stepDuration = totalDuration/steps;

  timeValue = 0;
  [self enableSliders: NO];
  animateButton.enabled = NO;
  [self animate];
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark -	TableViewSelectionProtocol methods
//-----------------------------------------------------------------------------------------------------------
//

- (void) userSelectedRow: (NSInteger) row
                  sender: (id) sender;
{
  NSArray *uniqueFilterNames = [FiltersList sharedFiltersList].uniqueFilterNames;
  NSLog(@"User selected row %ld (%@)", (long)row, uniqueFilterNames[row]);
  currentFilterName = uniqueFilterNames[row];
  [self doSetup];
  [self showImage];

}
//-----------------------------------------------------------------------------------------------------------
#pragma mark -	UITextFieldDelegate methods
//-----------------------------------------------------------------------------------------------------------

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return YES;
}

//-----------------------------------------------------------------------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  textFieldToEdit = textField;
  return YES;
}

//-----------------------------------------------------------------------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  //dlog(0, @"Entering %s. text field = %@", __PRETTY_FUNCTION__, textField);
  [textField resignFirstResponder];
  return TRUE;
}

//-----------------------------------------------------------------------------------------------------------

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSInteger index = textField.tag - K_VALUE_BASE_TAG;
  NSInteger sliderTag = index + K_SLIDER_BASE_TAG;
  UISlider *slider = (UISlider *)[self.view viewWithTag: sliderTag];
  
  NSString *input = textField.text;
  CGFloat value = [input floatValue];
  if (input.length > 0 && value >= slider.minimumValue && value <= slider.maximumValue)
  {
    slider.value = value;
    [self changeValue: value forIndex: index];
  }
  else
  {
    textField.text = [NSString stringWithFormat: @"%0.2f", slider.value];
  }
}

@end

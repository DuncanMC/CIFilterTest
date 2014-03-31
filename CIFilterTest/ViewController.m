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
#import "WTColorPickerButton.h"

@interface ViewController ()

@end

@implementation ViewController

//------------------------------------------------------------------------------------------------------
#pragma mark - Custom instance methods
//------------------------------------------------------------------------------------------------------

- (CIFilter *) clampFilter;
{
  if (!_clampFilter)
    _clampFilter = [CIFilter filterWithName: @"CIAffineClamp"];
  //CIAttributeTypeTransform
  return _clampFilter;
}

- (CIFilter *) cropFilter;
{
  if (!_cropFilter)
    _cropFilter = [CIFilter filterWithName: @"CICrop"];
  //CIAttributeTypeTransform
  return _cropFilter;
}

//------------------------------------------------------------------------------------------------------

- (void) listCIFiltersAndShowInputKeys: (BOOL) listFilterKeys;
{
  NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
  printf("CI filters from iOS version %s:\n\n", [iOSVersion cStringUsingEncoding: NSUTF8StringEncoding]);

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

- (void) addColorWellControlWithKey: (NSString *)aKey;
{
  int index = colorWellControlIndex++;
  if (index < K_MAX_COLORWELLS)
  colorWellKeys[index] = aKey;
  else
  {
    NSLog(@"Too many color wells!");
    return;
  }
  
  int colorWellTag = index + K_COLORWELL_BASE_TAG;
  WTColorPickerButton *colorPicker = (WTColorPickerButton *)[self.view viewWithTag: colorWellTag];
  
  if (aKey.length == 0)
  {
    colorPicker.hidden = YES;
    return;
  }
  
  
  NSDictionary *attributes = currentFilter.attributes;
  NSDictionary *thisAttribute = attributes[aKey];
  if (!thisAttribute)
  {
    NSLog(@"can't find attribute");
    return;
  }
  CIColor *defaultCIColor  = (CIColor *)thisAttribute[@"CIAttributeDefault"];
  CGFloat red, green, blue, alpha;
  
  red = defaultCIColor.red;
  green = defaultCIColor.green;
  blue = defaultCIColor.blue;
  alpha = defaultCIColor.alpha;
  UIColor *defaultUIColor = [UIColor colorWithRed: red
                                            green: green
                                             blue: blue
                                            alpha: alpha];

  colorPicker.currentColor = defaultUIColor;
  colorPicker.hidden = NO;
  colorPicker.buttonTitle = aKey;

  
//  CGFloat minValue = [thisAttribute[@"CIAttributeSliderMin"] floatValue];
//  CGFloat maxValue = [thisAttribute[@"CIAttributeSliderMax"] floatValue];
//  CGFloat defaultValue  = [thisAttribute[@"CIAttributeDefault"] floatValue];
//  
//  aSlider.minimumValue = minValue;
//  aSlider.maximumValue = maxValue;
//  aSlider.value = defaultValue;
//  
//  sliderLabel.text = aKey;
//  
//  minLabel.text = [NSString stringWithFormat: @"%.2f", minValue];
//  maxLabel.text = [NSString stringWithFormat: @"%.2f", maxValue];
//  currentValueTextView.text = [NSString stringWithFormat: @"%.2f", defaultValue];
  
}

//------------------------------------------------------------------------------------------------------

- (void) addSliderControlWithKey: (NSString *)aKey;
{
  int index = sliderControlIndex++;
  if (index < K_MAX_SLIDERS)
    sliderKeys[index] = aKey;
  else
  {
    NSLog(@"Too many sliders!");
    return;
  }
  
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
    if ([currentFilterName isEqualToString: @"CIGaussianBlur"]
        ||
        [currentFilterName isEqualToString: @"CIGloom"]
        )
    {
      // NSLog(@"new image is bigger");
      CIFilter *clampFilter = [self clampFilter];
      
      CIImage *sourceCIImage = [CIImage imageWithCGImage: imageToEdit.CGImage];
      [clampFilter setValue: sourceCIImage
                     forKey: kCIInputImageKey];
      
      
      [clampFilter setValue:[NSValue valueWithBytes: &CGAffineTransformIdentity
                                           objCType:@encode(CGAffineTransform)]
                     forKey:@"inputTransform"];
      
      
      
      sourceCIImage = [clampFilter valueForKey: kCIOutputImageKey];
      [currentFilter setValue: sourceCIImage
                       forKey: kCIInputImageKey];
    }
    
    outputImage = [currentFilter valueForKey: kCIOutputImageKey];
    CGSize newSize;
    
    newSize = outputImage.extent.size;
    if (newSize.width < sourceImageExtent.width || newSize.height < sourceImageExtent.height)
    {
      CIFilter *transformFilter = [CIFilter filterWithName: @"CIAffineTransform"];
      
      CGFloat scale =sourceImageExtent.width/newSize.width;
      
      CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
      [transformFilter setValue:[NSValue valueWithBytes: &transform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
      [transformFilter setValue:outputImage forKey: @"inputImage"];
      
      outputImage = [transformFilter valueForKey: kCIOutputImageKey];
      
    }
    newSize = outputImage.extent.size;
    
    if (newSize.width > sourceImageExtent.width || newSize.height > sourceImageExtent.height)
    {
      // NSLog(@"new image is bigger");
      CIFilter *cropFilter = [self cropFilter];
      
      CGRect boundsRect = CGRectMake(0, 0, sourceImageExtent.width, sourceImageExtent.height);
      
      [cropFilter setValue:outputImage forKey: @"inputImage"];
      
      CIVector *rectVector = [CIVector vectorWithCGRect: boundsRect];
      
      [cropFilter setValue: rectVector
                    forKey: @"inputRectangle"];
      outputImage = [cropFilter valueForKey: kCIOutputImageKey];
      
      
    }
    outputUIImage = [UIImage imageWithCIImage: outputImage];
  }
  else
  {
    outputUIImage = imageToEdit;
  }
  
  theImageView.image = outputUIImage;
}

//------------------------------------------------------------------------------------------------------

- (void) clearControls;
{
  sliderControlIndex = 0;
  colorWellControlIndex = 0;
  
  int index;
  for (index = 0; index < K_MAX_SLIDERS; index++)
  {
    UIView *controlsView = [self.view viewWithTag: K_VIEW_BASE_TAG + index];
    controlsView.hidden = YES;
    sliderKeys[index] = nil;
  }
  for (index = 0; index < K_MAX_COLORWELLS; index++)
  {
    UIView *colorWellView = [self.view viewWithTag: K_COLORWELL_BASE_TAG + index];
    colorWellView.hidden = YES;
    colorWellKeys[index] = nil;
  }
}

//------------------------------------------------------------------------------------------------------

- (void) doSetup;
{
  
  scaleUpImage = NO;

  
  //CIHoleDistortion, CIBumpDistortion, CIBumpDistortionLinear, CIHoleDistortion, CIGaussianBlur, CIPinchDistortion, CIBarsSwipeTransition
  
  
  currentFilter = [CIFilter filterWithName: currentFilterName];
  [currentFilter setDefaults];
  

  
  NSDictionary *attributes = currentFilter.attributes;
  //NSLog(@"Filter %@ attributes = %@", currentFilterName, attributes);
  NSString *filterName;
//  filterName = attributes[kCIAttributeFilterDisplayName];
  filterName = attributes[kCIAttributeFilterName];
  filterNameLabel.text = filterName;

  animateButton.enabled = [attributes objectForKey: @"inputTime"] != nil;
  positionSelector.selectedSegmentIndex = 0;

  if ([attributes objectForKey: kCIInputImageKey])
  {
    imageToEdit = [UIImage imageNamed: @"Sample image"];
    CIImage *sourceCIImage = [CIImage imageWithCGImage: imageToEdit.CGImage];
    sourceImageExtent = sourceCIImage.extent.size;
    [currentFilter setValue: sourceCIImage
                     forKey: kCIInputImageKey];

  }

  if ([currentFilterName isEqualToString: @"CIQRCodeGenerator"])
  {
    NSString *theQRString = @"http://appstore.com/facedancer";
    //dataUsingEncoding
    NSData *theQRData = [theQRString dataUsingEncoding: NSASCIIStringEncoding];
    
    [currentFilter setValue: theQRData
                     forKey: @"inputMessage"];
    [currentFilter setValue: @"M"
                     forKey: @"inputCorrectionLevel"];
    scaleUpImage = YES;
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

  if ([attributes objectForKey: kCIInputBackgroundImageKey])
  {
    secondImage = [UIImage imageNamed: @"Sample image #2"];
    CIImage *secondCIImage = [CIImage imageWithCGImage: secondImage.CGImage];
    
    
    [currentFilter setValue: secondCIImage
                     forKey: kCIInputBackgroundImageKey];
    
  }

  if ([attributes objectForKey: @"inputPoint"])
  {
    
    CIVector *imageCenterVector = [CIVector vectorWithX: sourceImageExtent.width/2.0
                                                      Y: sourceImageExtent.height/2.0];
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
    //This si a color key, so set up one of the color controls to use it.
    if ([thisKey rangeOfString: @"inputColor"].location != NSNotFound)
    {
      [self addColorWellControlWithKey: thisKey];
    }
    else if (thisInputDict[kCIAttributeSliderMax] != nil)
      //Find all keys that contain slider information add add them to the controls
      [self addSliderControlWithKey: thisKey];

  }
  

  /*
  if ([currentFilterName isEqualToString: @"CIBumpDistortion"] ||
      [currentFilterName isEqualToString: @"CIBumpDistortionLinear"] ||
      [currentFilterName isEqualToString: @"CIPinchDistortion"] ||
      [currentFilterName isEqualToString: @"CIGaussianBlur"]      )
  {
    [self addSliderControlWithKey: @"inputRadius"];
    [self addSliderControlWithKey: @"inputScale"];
    [self addSliderControlWithKey: @"inputAngle"];
  }
  else if ([currentFilterName isEqualToString: @"CISharpenLuminance"])
  {
    [self addSliderControlWithKey: @"inputSharpness"];
  }
  else if ([currentFilterName isEqualToString: @"CIUnsharpMask"])
  {
    [self addSliderControlWithKey: @"inputRadius"];
    [self addSliderControlWithKey: @"inputIntensity"];
  }
  else if ([currentFilterName isEqualToString: @"CIBarsSwipeTransition"] ||
           [currentFilterName isEqualToString: @"CIDissolveTransition"]
           )
  {
    [self addSliderControlWithKey: @"inputTime"];
    [self addSliderControlWithKey: @"inputAngle"];
    [self addSliderControlWithKey: @"inputWidth"];
    [self addSliderControlWithKey: @"inputBarOffset"];
  }
  else if ([currentFilterName isEqualToString: @"CICopyMachineTransition"] ||
           [currentFilterName isEqualToString: @"CISwipeTransition"]
            )
  {
    [self addSliderControlWithKey: @"inputTime"];
    [self addSliderControlWithKey: @"inputAngle"];
    [self addSliderControlWithKey: @"inputWidth"];
    [self addSliderControlWithKey: @"inputOpacity"];
  }
  else if ([currentFilterName isEqualToString: @"CIModTransition"])
  {
    [self addSliderControlWithKey: @"inputTime"];
    [self addSliderControlWithKey: @"inputAngle"];
    [self addSliderControlWithKey: @"inputRadius"];
    [self addSliderControlWithKey: @"inputCompression"];
  }
  else if ([currentFilterName isEqualToString: @"CIDisintegrateWithMaskTransition"])
  {
    [self addSliderControlWithKey: @"inputTime"];
    [self addSliderControlWithKey: @"inputShadowRadius"];
    [self addSliderControlWithKey: @"inputShadowDensity"];
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
  [self listCIFiltersAndShowInputKeys: YES];
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
  theFilterTypePopup.choices = [theFiltersList.uniqueFilterNames copy];
  theFilterTypePopup.delegate = self;
  currentFilterName = theFiltersList.uniqueFilterNames[77];
  
  NSIndexPath *filterIndexPath = [theFiltersList indexPathForFilterNamed: currentFilterName];
  
  theFilterTypePopup.selectedItemIndexPath = filterIndexPath;
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
#pragma mark - IBAction methods
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
      x = sourceImageExtent.width/2.0;
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
                                                      Y: sourceImageExtent.height/2.0];
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
  totalDuration = 3;
  steps = 60;
  #if (TARGET_IPHONE_SIMULATOR)
    steps = 10;
  #endif
  stepDuration = totalDuration/steps;

  timeValue = 0;
  [self enableSliders: NO];
  animateButton.enabled = NO;
  [self animate];
}

//-----------------------------------------------------------------------------------------------------------

- (IBAction)colorWellChanged:(WTColorPickerButton *)sender
{
  NSInteger index = sender.tag - K_COLORWELL_BASE_TAG;
  NSString *colorKey = colorWellKeys[index];
  
  UIColor *newColor = sender.currentColor;
  
  if (colorKey.length != 0)
  {
    CIColor *newCIColor = [[CIColor  alloc]  initWithColor: newColor];
    
    CIColor *oldCIColor = [currentFilter valueForKey: colorKey];
    
    if (![newCIColor isEqual: oldCIColor])
    {
      [currentFilter setValue: newCIColor
                       forKey: colorKey];
      [self showImage];
    }
  }
  
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark -	TableViewSelectionProtocol methods
//-----------------------------------------------------------------------------------------------------------

- (void) userSelectedRow: (NSInteger) row
                  sender: (id) sender;
{
  NSArray *uniqueFilterNames = [FiltersList sharedFiltersList].uniqueFilterNames;
  NSLog(@"User selected row %ld (%@)", (long)row, uniqueFilterNames[row]);
  currentFilterName = uniqueFilterNames[row];
  [self doSetup];
  [self showImage];

}


- (void) userSelectedIndexPath: (NSIndexPath *) indexPath
                  sender: (id) sender;
{
  
  
//  NSLog(@"User selected row %ld (%@)", (long)row, uniqueFilterNames[row]);
  currentFilterName = [[FiltersList sharedFiltersList] filterNameForIndexPath: indexPath];
  [self doSetup];
  [self showImage];
  
}


//-----------------------------------------------------------------------------------------------------------
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

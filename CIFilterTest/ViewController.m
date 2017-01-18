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
#import "PointButton.h"
#import "FourCornersButton.h"
#import "Defines.h"
#import "RectButton.h"
#import "ConvolutionPickerButton.h"

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
          if (outputKeys.count >= 1 && ![outputKeys[0] isEqualToString: kCIOutputImageKey])
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
            if (outputKeys.count >= 1 && ![outputKeys[0] isEqualToString: kCIOutputImageKey)
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

- (void) addPointButtonWithKey: (NSString *)aKey;
{
  int index = pointButtonIndex++;
  if (index < K_MAX_POINTBUTTONS)
    pointButtonKeys[index] = aKey;
  else
  {
    NSLog(@"Too many color wells!");
    return;
  }
  
  int pointButtonTag = index + K_POINTBUTTON_BASE_TAG;
  PointButton *aPointButton = (PointButton *)[self.view viewWithTag: pointButtonTag];
  
  aPointButton.buttonTitle = aKey;

  
  if (aKey.length == 0)
  {
    aPointButton.hidden = YES;
    return;
  }
  
  
  NSDictionary *attributes = currentFilter.attributes;
  NSDictionary *thisAttribute = attributes[aKey];
  if (!thisAttribute)
  {
    NSLog(@"can't find attribute");
    return;
  }
  NSValue *pointNSValue = [currentFilter valueForKey: aKey];
//  NSValue *pointNSValue = ((NSValue *)thisAttribute[@"CIAttributeDefault"]);
  CGPoint defaultCenter;
  CGFloat scale = 1.0;
  
  if (imageToEdit)
    scale = imageToEdit.scale;
  if (pointNSValue)
  {
    defaultCenter  = pointNSValue.CGPointValue;
    defaultCenter.x /= scale;
    defaultCenter.y /= scale;
  }
  else
    defaultCenter = CGPointMake( CGRectGetMidX(imageContainerView.bounds),
                                CGRectGetMidY(imageContainerView.bounds));
  
  aPointButton.pointCenter = defaultCenter;
  
  aPointButton.hidden = NO;
  aPointButton.enabled = YES;

  aPointButton.pointKey =aKey;
  
  aPointButton.thePointChangedBlock = ^(CGPoint newPoint, NSString *key)
  {
    CIVector *pointVector = [CIVector vectorWithX: newPoint.x * imageToEdit.scale
                                               Y: newPoint.y * imageToEdit.scale
                             ];
    [currentFilter setValue: pointVector
                     forKey: key];
    if ([key isEqualToString: kCIInputCenterKey])
      positionSelector.selectedSegmentIndex = -1;
    [self showImage];

  };
  
}

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
  static BOOL doExtend = YES;
  
  if (useFilterSwitch.isOn)
  {
    if (([currentFilterName isEqualToString: @"CIGaussianBlur"]
         ||
         [currentFilterName isEqualToString: @"CIGloom"]
         ||
         [currentFilterName isEqualToString: @"CIBloom"])
        && doExtend
        )
    {
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
      
      UIImage *tempUIImage = [UIImage imageWithCIImage: outputImage];
      
      
      UIGraphicsBeginImageContext(CGSizeMake(sourceImageExtent.width, sourceImageExtent.height));
      CGContextRef context = UIGraphicsGetCurrentContext();
      CGContextSetInterpolationQuality(context, kCGInterpolationNone);
      [tempUIImage drawInRect:CGRectMake(0, 0, sourceImageExtent.width, sourceImageExtent.height)];
      outputUIImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
    }
    else
    {
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
  theConvolutionPickerButton.hidden = YES;
  sliderControlIndex = 0;
  colorWellControlIndex = 0;
  pointButtonIndex = 0;
  theFourCornersButton.hidden = YES;
  theFourCornersButton.selected = NO;
  
  theExtentButton.hidden = YES;
  theExtentButton.selected = NO;

  
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
  //pointButtonKeys K_MAX_POINTBUTTONS
  for (index = 0; index < K_MAX_COLORWELLS; index++)
  {
    PointButton *aPointButton= (PointButton *) [self.view viewWithTag: K_POINTBUTTON_BASE_TAG + index];
    aPointButton.hidden = YES;
    aPointButton.selected = NO;
    pointButtonKeys[index] = nil;
  }
}

//------------------------------------------------------------------------------------------------------
//Set up the filter named in currentFilterName using default settings

- (void) doSetup;
{
  CGFloat inputBiasValue = 0;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject: currentFilterName forKey: K_DEFAULT_FILTERNAME];
  [defaults synchronize];
  scaleUpImage = NO;

  currentFilter = [CIFilter filterWithName: currentFilterName];
  [currentFilter setDefaults];
  
  [self clearControls];


  //Get the attributes for this filter
  NSDictionary *attributes = currentFilter.attributes;
  //NSLog(@"Filter %@ attributes = %@", currentFilterName, attributes);
  NSString *filterName;
  filterName = attributes[kCIAttributeFilterDisplayName];
//  filterName = attributes[kCIAttributeFilterName];
  filterNameLabel.text = filterName;

  animateButton.enabled = [attributes objectForKey: @"inputTime"] != nil;

  CIImage *sourceCIImage = [CIImage imageWithCGImage: imageToEdit.CGImage];
  sourceImageExtent = sourceCIImage.extent.size;
  
  //-----------------------------------
  //Special-cased code for QR Code
  //-----------------------------------
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
  //-----------------------------------
  //Special-cased code for CIConvolution3X3
  //-----------------------------------
  else if ([currentFilterName isEqualToString: @"CIConvolution3X3"])
  {
    
    //Create a sharpening 3x3 matrix
    CGFloat sharpenWeights[9]=
    {
      0, -2,  0,
     -2,  9, -2,
      0,  -2, 0
    };
    CGFloat embossWeights[9] =
    { 1,   0, -1,
      2,   0, -2,
      1,   0, -1
    };

    CGFloat fraction = 1.0/9;
    CGFloat blurweights[9] =
    { fraction,   fraction,  fraction,
      fraction,   fraction,  fraction,
      fraction,   fraction,  fraction
    };
    

    CGFloat *weights;
    if (NO)
    {
      weights = sharpenWeights;
      inputBiasValue = 0;
    } else if (NO)
    {
      weights = blurweights;
      inputBiasValue = 0;
    }
    else
    {
      weights = embossWeights;
      inputBiasValue = .5;
    }
    [currentFilter setValue: @(inputBiasValue)
                     forKey: @"inputBias"];
    //----
    theConvolutionPickerButton.hidden = NO;
    theConvolutionPickerButton.matrixSize = threeByThreeSize;
    
    theConvolutionPickerButton.threeByThreeMatrix = weights;

    

    CIVector *weightsVector = [CIVector vectorWithValues: weights
                                                   count: 9];
    [currentFilter setValue: weightsVector
                     forKey: @"inputWeights"];

  }
  else if ([currentFilterName isEqualToString: @"CIConvolution7x7"])
  {
#define fortynine 49
    CGFloat onefortyninth = 1.0/fortynine;
    CGFloat blurweights[49] =
    {
      onefortyninth,   onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,
      onefortyninth,   onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,
      onefortyninth,   onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,
      onefortyninth,   onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,
      onefortyninth,   onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,
      onefortyninth,   onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,
      onefortyninth,   onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth,  onefortyninth
    };
    CGFloat *weights = blurweights;
    CIVector *weightsVector = [CIVector vectorWithValues: weights
                                                   count: fortynine];
    [currentFilter setValue: weightsVector
                     forKey: @"inputWeights"];

  }
  else if ([currentFilterName isEqualToString: @"CIConvolution5X5"])
  {
#define twentyfive 25
    CGFloat blurweights[twentyfive] =
    {
      //emboss filter
      1.0000, 1.0000, 1.0000, 0.0000, 0.0000,
      1.0000, 1.0000, 0.0000, 0.0000, 0.0000,
      1.0000, 0.0000, 0.0000, 0.0000, -1.0000,
      0.0000, 0.0000, 0.0000, -1.0000, -1.0000,
      0.0000, 0.0000, -1.0000, -1.0000, -1.0000
      //Blur filter
//      0.0000, 0.0125, 0.0250, 0.0125, 0.0000,
//      0.0125, 0.0500, 0.1000, 0.0500, 0.0125,
//      0.0250, 0.1000, 0.2000, 0.1000, 0.0250,
//      0.0125, 0.0500, 0.1000, 0.0500, 0.0125,
//      0.0000, 0.0125, 0.0250, 0.0125, 0.0000
    };
    CGFloat *weights = blurweights;
    
    //----
    theConvolutionPickerButton.hidden = NO;
    theConvolutionPickerButton.matrixSize = fiveByFiveSize;
    
    theConvolutionPickerButton.fiveByFiveMatrix = weights;

    CIVector *weightsVector = [CIVector vectorWithValues: weights
                                                   count: twentyfive];
    [currentFilter setValue: weightsVector
                     forKey: @"inputWeights"];
    
    inputBiasValue = .5;
    [currentFilter setValue: @(inputBiasValue)
                     forKey: @"inputBias"];

    
  }
  
  if ([currentFilterName rangeOfString: @"CIConvolution"].location != NSNotFound)
  {
    theConvolutionPickerButton.bias = inputBiasValue;
    theConvolutionPickerButton.theConvolutionValuesChangedBlock = ^(matrixSizes matrixSize, CGFloat* newMatrix, CGFloat newBias)
    {
      NSUInteger matrixCount = 0;
      matrixCount = (matrixSize==threeByThreeSize) ? threeByThreeMatrixSize : fiveByFiveMatrixSize;
      if (FALSE)
      {
        NSMutableString *matrixString = [NSMutableString new];
        if (newMatrix != nil)
        {
          [matrixString appendString: @"\nMatrix: ("];
          for (NSUInteger index = 0; index < matrixCount; index++)
          {
            [matrixString appendFormat: @"%.4f", newMatrix[index]];
            if (index <matrixCount-1)
              [matrixString appendString: @", "];
            else
              [matrixString appendString: @")\n"];
          }
        }
        NSLog(@"In theConvolutionValuesChangedBlock. matrixSize = %d. %@newBias = %.3f", matrixSize, matrixString, newBias);
      }
      if (matrixCount)
      {
        CIVector *weightsVector = [CIVector vectorWithValues: newMatrix
                                                       count: matrixCount];
        [currentFilter setValue: weightsVector
                         forKey: @"inputWeights"];
        
        if (matrixSize == threeByThreeSize)
          theConvolutionPickerButton.threeByThreeMatrix = newMatrix;
        else
          theConvolutionPickerButton.fiveByFiveMatrix = newMatrix;
        theConvolutionPickerButton.bias = newBias;
      }
      [currentFilter setValue: @(newBias)
                       forKey: @"inputBias"];
      
      [self showImage];
    };
  }
  
    //
  
  //-----------------------------------
  //Handle the image keys
  //-----------------------------------
  
  //inputImageKey
  if ([attributes objectForKey: kCIInputImageKey])
  {
    [currentFilter setValue: sourceCIImage
                     forKey: kCIInputImageKey];
    
  }
  
  //inputMaskImage
  if ([attributes objectForKey: kCIInputMaskImageKey])
  {
    UIImage *maskImage = [UIImage imageNamed: @"Mask image"];
    CIImage *maskCIImage = [CIImage imageWithCGImage: maskImage.CGImage];
    
    
    [currentFilter setValue: maskCIImage
                     forKey: kCIInputMaskImageKey];
    
  }

  //inputTargetImage
  if ([attributes objectForKey: kCIInputTargetImageKey])
  {
    secondImage = [UIImage imageNamed: @"Sample image #2"];
    CIImage *secondCIImage = [CIImage imageWithCGImage: secondImage.CGImage];
    
    
    [currentFilter setValue: secondCIImage
                     forKey: kCIInputTargetImageKey];
    
  }

  //inputBackgroundImageKey
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
  
  //Special-case code to show the segmented control for the input center attribute
  if (![attributes objectForKey: kCIInputCenterKey])
  {
    positionSelector.enabled = NO;
    positionControlView.hidden = YES;
  }
  else
  {
    if (!defaultCenterPoint)
      defaultCenterPoint = [currentFilter valueForKey: kCIInputCenterKey];
    positionSelector.enabled = YES;
    positionControlView.hidden = NO;
    
    //Set the center point to the center of the image to begin with
    positionSelector.selectedSegmentIndex = 2;
    [self handlePositionSelector: positionSelector];
  }

  
  for (NSString *thisKey in inputKeys)
  {
    NSDictionary *thisInputDict = [attributes objectForKey: thisKey];
    
    //This is a color key, so set up one of the color controls to use it.
    if ([thisKey rangeOfString: @"inputColor"].location != NSNotFound)
    {
      [self addColorWellControlWithKey: thisKey];
    }
    
    else if (thisInputDict[kCIAttributeSliderMax] != nil)
    {
      //-------------------------------------
      // Handle the floating-point attributes
      // managed by sliders
      //-------------------------------------
      [self addSliderControlWithKey: thisKey];
    }
    
    else if ([thisInputDict[kCIAttributeType] isEqualToString: kCIAttributeTypePosition])
    {
      //-------------------------------------
      // Handle the attributes that use a
      // single point location
      //-------------------------------------
      if ([thisKey rangeOfString: @"inputPoint"].location != NSNotFound ||
          [thisKey isEqualToString: kCIInputCenterKey]
          )
      {
        [self addPointButtonWithKey: thisKey];
      }
    }
  }
  
  //---------------------------------------------
  // See if this filter uses
  // topLeft/topRight/bottomLeft/bottomRight keys
  //---------------------------------------------
  
  if (
      [inputKeys containsObject: K_TOPLEFT_INPUT_KEY] &&
      [inputKeys containsObject: K_TOPRIGHT_INPUT_KEY] &&
      [inputKeys containsObject: K_BOTTOMLEFT_INPUT_KEY] &&
      [inputKeys containsObject: K_BOTTOMLEFT_INPUT_KEY]
      )
    
  {
    //NSLog(@"Filter %@ contains four corners", currentFilterName);
    theFourCornersButton.hidden = NO;
    
    NSArray *pointKeys = @[K_TOPLEFT_INPUT_KEY,
                           K_TOPRIGHT_INPUT_KEY,
                           K_BOTTOMLEFT_INPUT_KEY,
                           K_BOTTOMRIGHT_INPUT_KEY];
    theFourCornersButton.pointKeys = pointKeys;
    
    
    CGFloat scale = 1.0;
    
    if (imageToEdit)
      scale = imageToEdit.scale;
    
    for (int index = 0; index< pointKeys.count; index++)
    {
      NSDictionary *thisAttribute = attributes[pointKeys[index]];
      if (!thisAttribute)
      {
        NSLog(@"can't find attribute");
        return;
      }
      
      CIVector *pointVector = [currentFilter valueForKey: pointKeys[index] ];
      CGPoint pointValue;
      if (pointVector)
      {
        pointValue  = pointVector.CGPointValue;
        pointValue.x /= scale;
        pointValue.y /= scale;
        
        if (pointValue.x < 0)
          pointValue.x = 0;
        else if (pointValue.x > imageContainerView.bounds.size.width)
          pointValue.x = imageContainerView.bounds.size.width;
        
        if (pointValue.y < 0)
          pointValue.y = 0;
        else if (pointValue.y > imageContainerView.bounds.size.height)
          pointValue.y = imageContainerView.bounds.size.height;
      }
      else
        pointValue = CGPointMake( CGRectGetMidX(imageContainerView.bounds),
                                    CGRectGetMidY(imageContainerView.bounds));
      
      [theFourCornersButton setCenter: pointValue forPointAtIndex: index];
      
    }
    
    theFourCornersButton.hidden = NO;
    theFourCornersButton.enabled = YES;
    
    
    theFourCornersButton.thePointChangedBlock = ^(CGPoint newPoint, NSString *key)
    {
      CIVector *pointVector = [CIVector vectorWithX: newPoint.x * imageToEdit.scale
                                                  Y: newPoint.y * imageToEdit.scale
                               ];
      [currentFilter setValue: pointVector
                       forKey: key];
      [self showImage];
      
    };
    
  }
  else
    theFourCornersButton.hidden = YES;
  
 
  //---------------------------------------------
  // See if this filter uses the inputExtent key
  //---------------------------------------------
  BOOL isExtent = [inputKeys containsObject: K_INPUT_EXTENT_KEY];
  BOOL isInputRect = [inputKeys containsObject: K_INPUT_RECT_KEY];
  
  if (isExtent ||
      isInputRect)
  {
    
    NSString *key;
    if (isExtent)
      key = K_INPUT_EXTENT_KEY;
    else
      key = K_INPUT_RECT_KEY;
    
    if (TRUE)
      //Fix the default extent to include the entire source image instead of a silly 150x150 rectangle.
      if (isExtent )
        if (sourceImageExtent.height>0 && sourceImageExtent.width>0)
        {
          CGRect extentRect = CGRectMake(0, 0, sourceImageExtent.width, sourceImageExtent.height);
          CIVector *rectVector = [CIVector vectorWithCGRect: extentRect
                                  ];
          [currentFilter setValue: rectVector
                           forKey: K_INPUT_EXTENT_KEY];
          
        }

    CIVector *rectVector = [currentFilter valueForKey: key  ];
    CGRect theExtentRect = [rectVector CGRectValue];
    //---
    //NSLog(@"Filter %@ contains four corners", currentFilterName);
    
    NSArray *pointKeys = @[K_TOPLEFT_INPUT_KEY,
                           K_TOPRIGHT_INPUT_KEY,
                           K_BOTTOMLEFT_INPUT_KEY,
                           K_BOTTOMRIGHT_INPUT_KEY];
    theExtentButton.pointKeys = pointKeys;
    
    
    if (isExtent)
    {
      theExtentButton.buttonTitle = @"Extent";
      theExtentButton.theKey = K_INPUT_EXTENT_KEY;
    }
    else
    {
      theExtentButton.buttonTitle = @"Rectangle";
      theExtentButton.theKey = K_INPUT_RECT_KEY;
    }
    
    
    CGFloat scale = 1.0;
    
    if (imageToEdit)
      scale = imageToEdit.scale;
    
    theExtentRect.origin.x /= scale;
    theExtentRect.origin.y /= scale;
    theExtentRect.size.width /= scale;
    theExtentRect.size.height /= scale;
    
    if (theExtentRect.origin.x < 0)
      theExtentRect.origin.x = 0;
    if (CGRectGetMaxX( theExtentRect) > imageContainerView.bounds.size.width)
      theExtentRect.size.width = imageContainerView.bounds.size.width - theExtentRect.origin.x;
    
    if (theExtentRect.origin.y < 0)
      theExtentRect.origin.y = 0;
    if (CGRectGetMaxY( theExtentRect) > imageContainerView.bounds.size.height)
      theExtentRect.size.height = imageContainerView.bounds.size.height - theExtentRect.origin.y;
    
    theExtentButton.theExtentRect = theExtentRect;
    theExtentButton.theRectChangedBlock = ^(CGRect newRect, NSString *key)
    {
      newRect.origin.x *= scale;
      newRect.origin.y *= scale;
      newRect.size.width *= scale;
      newRect.size.height *= scale;
      
      CIVector *rectVector = [CIVector vectorWithCGRect:newRect
                              ];
      [currentFilter setValue: rectVector
                       forKey: key];
      [self showImage];
      
    };
    
    theExtentButton.hidden = NO;
    
  }
else
{
  theExtentButton.hidden = YES;
}
  
  
  //Debugging. For the bump distorition filter,
  //Log the default value of CenterPoint that we get from the attributes
  
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
  
  
  imageToEdit = [UIImage imageNamed: @"Sample image"];

  for (PointButton *aPointButton in thePointButtons)
  {
    aPointButton.pointContainerView = imageContainerView;
  }
  theFourCornersButton.pointContainerView = imageContainerView;
  theExtentButton.pointContainerView = imageContainerView;
  
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
                                if (UIInterfaceOrientationIsLandscape(theStatusBarOrientation))
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
//  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
//  theFilterTypePopup.choices = [theFiltersList.uniqueFilterNames copy];
  theFilterTypePopup.delegate = self;
  
  [self listCIFiltersAndShowInputKeys: YES];
  //NSLog(@"%@", [[FiltersList sharedFiltersList] description]);
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  currentFilterName = [defaults stringForKey: K_DEFAULT_FILTERNAME];
  
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
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
  CGFloat y = sourceImageExtent.height/2.0;
  NSInteger index = positionSelector.selectedSegmentIndex;
  CIVector *imageCenterVector;
  BOOL useDefaultCenter = NO;
  switch (index)
  {
    case 0:
      useDefaultCenter = YES;
      break;
    case 1:
      x = 0;
      break;
    case 2:
      x = sourceImageExtent.width/2.0;
      break;
  }
  if (useDefaultCenter)
  {
    imageCenterVector = defaultCenterPoint;
  }
  else
  {
    imageCenterVector = [CIVector vectorWithX: x
                                            Y: y];
  }
  x = imageCenterVector.CGPointValue.x;
  y = imageCenterVector.CGPointValue.y;
  [currentFilter setValue: imageCenterVector forKey: kCIInputCenterKey];
  
  [self showImage];
  
  BOOL found = NO;
  for ( index = 0; index < K_MAX_POINTBUTTONS; index++)
  {
    NSString *pointKeyString = pointButtonKeys[index];
    if ([pointKeyString isEqualToString: kCIInputCenterKey])
    {
      found = YES;
      break;
    }
  }
  if (found)
  {
    NSInteger pointButtonTag = K_POINTBUTTON_BASE_TAG + index;
    PointButton *thePointButton = (PointButton *) [self.view viewWithTag: pointButtonTag];
    if (useDefaultCenter && defaultCenterPoint == nil)
    {
      thePointButton.selected =NO;
      thePointButton.hidden = YES;
    }
    else
      thePointButton.hidden = NO;
    CGPoint newCenter = CGPointMake(x/imageToEdit.scale, y/imageToEdit.scale);
    thePointButton.pointCenter = newCenter;
  }
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

- (IBAction)pointButtonChanged:(PointButton *)sender
{
  //NSLog(@"Entering %s", __PRETTY_FUNCTION__);
}

- (IBAction)handleResetButton:(UIButton *)sender
{
  [self doSetup];
  [self showImage];
}

- (IBAction)handleRotateButton:(UIButton *)sender {
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
  defaultCenterPoint = nil;
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

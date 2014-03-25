//
//  ViewController.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/24/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//------------------------------------------------------------------------------------------------------
#pragma mark - Custom instance methods
//------------------------------------------------------------------------------------------------------

- (void) listCIFilters;
{
  return;   //Skip this step
  NSMutableSet *uniqueFilterNames = [NSMutableSet new];
  
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

- (void) showImage;
{
  CIImage *sourceCIImage = [CIImage imageWithCGImage: imageToEdit.CGImage];
  
  
  [currentFilter setValue: sourceCIImage
                   forKey: kCIInputImageKey];
  if (useFilterSwitch.isOn)
    outputImage = [currentFilter valueForKey:kCIOutputImageKey];
  else
    outputImage = sourceCIImage;
  
  
  UIImage *outputUIImage = [UIImage imageWithCIImage: outputImage];
  theImageView.image = outputUIImage;
}

- (void) doSetup;
{
  imageToEdit = [UIImage imageNamed: @"Sample image"];
  //CIHoleDistortion, CIBumpDistortion, CIBumpDistortionLinear
  currentFilterName = @"CIBumpDistortion";
  currentFilter = [CIFilter filterWithName: currentFilterName];
  [currentFilter setDefaults];
  
  id value = [currentFilter valueForKey: @"inputCenter"];
  NSLog(@"After creating CIBumpDistortion filter, default inputCenter = %@", value);
}

//------------------------------------------------------------------------------------------------------
#pragma mark - VC Lifecycle methods
//------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self doSetup];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void) viewWillAppear:(BOOL)animated
{
  [self listCIFilters];
  [self showImage];
}

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

- (IBAction)handlePositionSelector:(UISegmentedControl *)sender
{
  CGFloat x = 0;
  int index = positionSelector.selectedSegmentIndex;
  switch (index)
  {
    case 0:
      break;
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

- (IBAction)handleRadiusSlider:(UISlider *)sender
{
  CGFloat radius = radiusSlider.value;
  [currentFilter setValue: @(radius) forKey: @"inputRadius"];
  [self showImage];
}

- (IBAction)handleAmountSlider:(UISlider *)sender
{
  CGFloat amount = amountSlider.value;
  [currentFilter setValue: @(amount) forKey: @"inputScale"];
  [self showImage];
}
@end

//
//  ConvolutionPickerButton.m
//  CIFilterTest
//
//  Created by Duncan Champney on 4/10/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "ConvolutionPickerButton.h"
#import "ConvolutionEditorVC.h"

@implementation ConvolutionPickerButton

//------------------------------------------------------------------------------------------------------
#pragma mark - Object lifecycle methods
//------------------------------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


//------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//------------------------------------------------------------------------------------------------------

- (void) setThreeByThreeMatrix:(CGFloat *)threeByThreeMatrix;
{
  for (int index = 0; index < sizeof(threeByThreeMatrixArray) / sizeof(CGFloat); index++)
  {
    threeByThreeMatrixArray[index] = threeByThreeMatrix[index];
  }
}

//------------------------------------------------------------------------------------------------------

- (void) setFiveByFiveMatrix:(CGFloat *)fiveByFiveMatrix;
{
  for (int index = 0; index < fiveByFiveMatrixSize; index++)
  {
    fiveByFiveMatrixArray[index] = fiveByFiveMatrix[index];
  }
}

//------------------------------------------------------------------------------------------------------
#pragma mark - custom instance methods
//------------------------------------------------------------------------------------------------------

- (void) showVCAsPopoverOrModal;
{
  [self showConvolutionPickerAsPopoverOrModal];
}

//------------------------------------------------------------------------------------------------------

- (void) showConvolutionPickerAsPopoverOrModal;
{
  //NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  ConvolutionEditorVC* thePopoverViewController = nil;
  
  thePopoverViewController = [[self.window.rootViewController storyboard] instantiateViewControllerWithIdentifier: @"ConvolutionEditor" ];
  
  thePopoverViewController.matrixSize = self.matrixSize;
  thePopoverViewController.theConvolutionValuesChangedBlock = self.theConvolutionValuesChangedBlock;
  
  if (self.matrixSize == threeByThreeSize)
    thePopoverViewController.threeByThreeMatrix = threeByThreeMatrixArray;
  else
    thePopoverViewController.fiveByFiveMatrix = fiveByFiveMatrixArray;
  
  
  thePopoverViewController.bias = self.bias;
  //Set up the block of code that gets executed when the user picks a new color.
  
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


@end

//
//  ConvolutionEditorVC.m
//  CIFilterTest
//
//  Created by Duncan Champney on 4/10/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "ConvolutionEditorVC.h"
#import "Types.h"

@interface ConvolutionEditorVC ()

@end


@implementation ConvolutionEditorVC

static NSUInteger threeByThreeMatrixTags[] = {
  11, 12, 13,
  21, 22, 23,
  31, 32, 33
};


static NSUInteger fiveByFiveMatrixTags[] = {
  11, 12, 13, 14, 15,
  21, 22, 23, 24, 25,
  31, 32, 33, 34, 35,
  41, 42, 43, 44, 45,
  51, 52, 53, 54, 55,
};


//------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//------------------------------------------------------------------------------------------------------

- (CGFloat *)threeByThreeMatrix;
{
  return threeByThreeMatrixArray;
}

//------------------------------------------------------------------------------------------------------

- (void) setThreeByThreeMatrix:(CGFloat *)newThreeByThreeMatrix;
{
  for (int index = 0; index < sizeof(threeByThreeMatrixArray) / sizeof(CGFloat); index++)
  {
    threeByThreeMatrixArray[index] = newThreeByThreeMatrix[index];
  }
}

//------------------------------------------------------------------------------------------------------

- (CGFloat *) fiveByFiveMatrix
{
  return fiveByFiveMatrixArray;
}

//------------------------------------------------------------------------------------------------------

- (void) setFiveByFiveMatrix:(CGFloat *)newFiveByFiveMatrix;
{
  for (int index = 0; index < fiveByFiveMatrixSize; index++)
  {
    fiveByFiveMatrixArray[index] = newFiveByFiveMatrix[index];
  }
}


//------------------------------------------------------------------------------------------------------
#pragma mark - ViewController lifecycle methods
//------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//------------------------------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL)animated
{
  biasField.text = [NSString stringWithFormat: @"%.3f", self.bias];
  
  if (self.matrixSize == threeByThreeSize)
  {
    //Loop through the array of tags and find each text field for the 3x3 convolution matrix
    convolutionTextFields = [NSMutableArray arrayWithCapacity: threeByThreeMatrixSize];
    for (int index = 0; index < threeByThreeMatrixSize; index++)
    {
      NSUInteger tag = threeByThreeMatrixTags[index];
      UITextField *textField = (UITextField *)[self.view viewWithTag: tag];
      convolutionTextFields[index] = textField;
      textField.hidden = NO;
      textField.text = [NSString stringWithFormat: @"%.3f", threeByThreeMatrixArray[index]];
    }
    
    //Now loop through the full array of field, looking for unused fields.
    for (int index = 0; index < fiveByFiveMatrixSize; index++)
    {
      NSUInteger tag = fiveByFiveMatrixTags[index];
      UITextField *textField = (UITextField *)[self.view viewWithTag: tag];
      if (![convolutionTextFields containsObject: textField])
        //If this isn't one of the text fields in the 3x3 matrix, remove it.
        [textField removeFromSuperview];
    }
  }
  else
  {
    convolutionTextFields = [NSMutableArray arrayWithCapacity: threeByThreeMatrixSize];
    for (int index = 0; index < fiveByFiveMatrixSize; index++)
    {
      NSUInteger tag = fiveByFiveMatrixTags[index];
      UITextField *textField = (UITextField *)[self.view viewWithTag: tag];
      textField.hidden = NO;
      convolutionTextFields[index] = textField;
      NSString *fieldString = [NSString stringWithFormat: @"%.3f", fiveByFiveMatrixArray[index]];
      textField.text = fieldString;
    }

  }
  
  //Now resize the convoultionValuesView to fit the current set of convolution UITextFields
  
  //First calculate the size needed to contain all the remaining subviews.
  CGSize boundsSize = CGSizeMake(0,0);
  for (UIView *aView in convoultionValuesView.subviews)
  {
    CGRect aViewFrame = aView.frame;
    CGFloat thisFieldMaxX = CGRectGetMaxX(aViewFrame) + 10;
    if (thisFieldMaxX > boundsSize.width)
      boundsSize.width = thisFieldMaxX;
    CGFloat thisFieldMaxY = CGRectGetMaxY(aViewFrame) + 10;
    if (thisFieldMaxY > boundsSize.height)
      boundsSize.height = thisFieldMaxY;
  }
  
  //Adjust the size of the convoultionValuesView
  CGRect bounds = convoultionValuesView.bounds;
  bounds.size = boundsSize;
  convoultionValuesView.bounds = bounds;
  
  //Re-center the convolutionValuesTitleView in the resized convoultionValuesView
  CGPoint center = convolutionValuesTitleView.center;
  center.x = boundsSize.width / 2;
  convolutionValuesTitleView.center = center;
}

//------------------------------------------------------------------------------------------------------
#pragma mark - custom instance methods
//------------------------------------------------------------------------------------------------------

- (void) displayMatrixValues;
{
  CGFloat *currentMatrix;
  NSUInteger matrixCount;
  if (self.matrixSize == threeByThreeSize)
  {
    matrixCount = threeByThreeMatrixSize;
    currentMatrix = threeByThreeMatrixArray;
  }
  else
  {
    currentMatrix = fiveByFiveMatrixArray;
    matrixCount = fiveByFiveMatrixSize;
  }
  for (int index = 0; index < matrixCount; index++)
  {
    UITextField *theTextField = convolutionTextFields[index];
    theTextField.text = [NSString stringWithFormat: @"%.3f", currentMatrix[index]];
  }

}

//-----------------------------------------------------------------------------------------------------------
#pragma mark -	UITextFieldDelegate methods
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
  //NSLog(@"Entering %s. View tag = %d", __PRETTY_FUNCTION__, tag);
  
  CGFloat *theMatrixArray = nil;

  CGFloat newValue;
  newValue = [textField.text floatValue];
  
  //If the edited field is NOT the bias field, figure out which one it was.
  if (textField != biasField)
  {
    //Fetch the correct array of floats for the current convolution matrix
    if (_matrixSize == threeByThreeSize)
      theMatrixArray = threeByThreeMatrixArray;
    else
      theMatrixArray = fiveByFiveMatrixArray;
    
    //Figure out the index of this field in the array of convolution values
    NSUInteger fieldIndex = [convolutionTextFields indexOfObject: textField];
    if (fieldIndex == NSNotFound)
    {
      NSLog(@"Error! Field not found!");
      return;
    }
    
    theMatrixArray[fieldIndex] = newValue;
  }
  else
    self.bias = [biasField.text floatValue];

}

//-----------------------------------------------------------------------------------------------------------

- (void) invokeMatrixChangedBlock;
{
  CGFloat *theMatrixArray = (_matrixSize == threeByThreeSize) ? threeByThreeMatrixArray : fiveByFiveMatrixArray;
  
  if (_theConvolutionValuesChangedBlock)
    _theConvolutionValuesChangedBlock(_matrixSize, theMatrixArray, self.bias);
  else
    NSLog(@"No convolutionValuesChangedBlock");
}

//-----------------------------------------------------------------------------------------------------------

- (IBAction)handleApplyButton:(UIButton *)sender
{
  if ([textFieldToEdit isFirstResponder])
    [textFieldToEdit resignFirstResponder];
  [self invokeMatrixChangedBlock];
}

- (IBAction)handleNormalizeButton:(UIButton *)sender
{
  //Setup
  if ([textFieldToEdit isFirstResponder])
    [textFieldToEdit resignFirstResponder];
  
  NSUInteger matrixCount = (_matrixSize==threeByThreeSize) ? threeByThreeMatrixSize : fiveByFiveMatrixSize;
  
  //Collect total of input values;
  CGFloat total = 0;
  CGFloat *currentMatrix = (_matrixSize==threeByThreeSize) ? threeByThreeMatrixArray : fiveByFiveMatrixArray;
  for (int index = 0; index<matrixCount; index++)
  {
    total += currentMatrix[index];
  }
  
  if (total != 0)
  {
    CGFloat factor = 1/total;
    
    //If the weight factor is not 1...
    if (fabsf(1-factor) > .01)
    {
      for (int index = 0; index<matrixCount; index++)
        currentMatrix[index] *= factor;
      [self displayMatrixValues];
    }
  }
  
  }

- (IBAction)handleRotateButton:(UIButton *)sender
{
  NSUInteger size;
  if (_matrixSize == threeByThreeSize)
  {
    size = 3;
    CGFloat newMatrix[threeByThreeMatrixSize];
    for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++)
      {
        NSUInteger array_index = x + y*size;
        CGFloat aFloat = threeByThreeMatrixArray[array_index];
        array_index = size-y-1+x*size;
        newMatrix[array_index] = aFloat;
      }
    for (int index = 0; index < threeByThreeMatrixSize; index++)
      threeByThreeMatrixArray[index] = newMatrix[index];
  }
  else
  {
    size = 5;
    CGFloat newMatrix[fiveByFiveMatrixSize];
    for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++)
      {
        CGFloat aFloat = fiveByFiveMatrixArray[x + y*size];
        newMatrix[size-y-1+x*size] = aFloat;
      }
    for (int index = 0; index < fiveByFiveMatrixSize; index++)
      fiveByFiveMatrixArray[index] = newMatrix[index];
  }
  [self displayMatrixValues];
}

@end

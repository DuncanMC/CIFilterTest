//
//  ConvolutionPickerButton.h
//  CIFilterTest
//
//  Created by Duncan Champney on 4/10/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "WTPopoverButton.h"
#import "ConvolutionEditorVC.h"


@interface ConvolutionPickerButton : WTPopoverButton
{
  CGFloat threeByThreeMatrixArray[9];
  CGFloat fiveByFiveMatrixArray[25];
}

@property (nonatomic, assign) matrixSizes matrixSize;

@property (nonatomic, assign) CGFloat *threeByThreeMatrix;
@property (nonatomic, assign) CGFloat *fiveByFiveMatrix;
@property (nonatomic, assign) CGFloat bias;

@property (nonatomic, strong) convolutionValuesChangedBlock theConvolutionValuesChangedBlock;

@end

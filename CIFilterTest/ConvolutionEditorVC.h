//
//  ConvolutionEditorVC.h
//  CIFilterTest
//
//  Created by Duncan Champney on 4/10/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Types.h"



@interface ConvolutionEditorVC : UIViewController <UITextFieldDelegate>

#define biasFieldTag 100

{
  __weak IBOutlet UITextField *biasField;
  __weak IBOutlet UIView *convoultionValuesView;
  __weak IBOutlet UILabel *convolutionValuesTitleView;
  CGFloat threeByThreeMatrixArray[9];
  CGFloat fiveByFiveMatrixArray[25];
  
  UITextField *textFieldToEdit;
  
  NSMutableArray *convolutionTextFields;
}

@property (nonatomic, assign) CGFloat *threeByThreeMatrix;
@property (nonatomic, assign) CGFloat *fiveByFiveMatrix;
@property (nonatomic, assign) matrixSizes matrixSize;

@property (nonatomic, strong) convolutionValuesChangedBlock theConvolutionValuesChangedBlock;


@property (nonatomic, assign) CGFloat bias;

- (IBAction)handleApplyButton:(UIButton *)sender;
- (IBAction)handleNormalizeButton:(UIButton *)sender;

@end

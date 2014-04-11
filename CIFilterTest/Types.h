//
//  Types.h
//  CIFilterTest
//
//  Created by Duncan Champney on 4/2/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#ifndef CIFilterTest_Types_h
#define CIFilterTest_Types_h

typedef enum
{
  threeByThreeSize,
  fiveByFiveSize
} matrixSizes;

#define threeByThreeMatrixSize 9
#define fiveByFiveMatrixSize 25

typedef void (^pointChangedBlock)(CGPoint point, NSString *key);

typedef void (^rectChangedBlock)(CGRect rect, NSString *key);

typedef  void (^convolutionValuesChangedBlock)(matrixSizes matrixSize, CGFloat* newMatrix, CGFloat newBias);
//typedef void (^NKOColorPickerDidChangeColorBlock)(UIColor *color);

#endif

//
//  RectButton.h
//  CIFilterTest
//
//  Created by Duncan Champney on 4/3/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "LabeledToggleButton.h"
#import "FourCornersButton.h"

@interface RectButton : FourCornersButton

{
  CAShapeLayer *extentRectLayer1;
  CAShapeLayer *extentRectLayer2;
}
@property (nonatomic, assign) CGRect theExtentRect;
@property (nonatomic, strong) NSString *theKey;
@property (nonatomic, strong) rectChangedBlock theRectChangedBlock;

@end

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

@property (nonatomic, assign) CGRect theExtentRect;
@property (nonatomic, strong) NSString *theKey;
@property (nonatomic, strong) rectChangedBlock theRectChangedBlock;

@end

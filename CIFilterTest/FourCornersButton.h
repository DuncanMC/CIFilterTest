//
//  FourCornersButton.h
//  CIFilterTest
//
//  Created by Duncan Champney on 4/2/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "LabeledToggleButton.h"
#import "Types.h"

@class PointView;

@interface FourCornersButton : LabeledToggleButton
{
 NSMutableArray *thePoints;
}

@property (nonatomic, strong) NSArray *pointKeys;
@property (nonatomic, strong) NSMutableArray *theCGPointValues;
@property (nonatomic, weak) UIView *pointContainerView;

@property (nonatomic, strong) pointChangedBlock thePointChangedBlock;

- (CGPoint) centerForPointAtIndex: (NSUInteger) index;

- (void) setCenter:(CGPoint)pointCenter forPointAtIndex: (NSUInteger) index;

@end

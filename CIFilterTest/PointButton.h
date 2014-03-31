//
//  PointButton.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/31/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTToggleButton.h"
#import "PointView.h"

@interface PointButton : WTToggleButton;

@property (nonatomic, strong) PointView *thePoint;

@end

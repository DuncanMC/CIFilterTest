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
#import "PointViewDelegateProtocol.h"

typedef void (^pointChangedBlock)(CGPoint point);

@interface PointButton : WTToggleButton <PointViewDelegateProtocol>
{
  UILabel *customTitleLabel;
}

@property (nonatomic, strong) PointView *thePoint;
@property (nonatomic, weak) UIView *pointContainerView;
@property (nonatomic, assign) CGPoint pointCenter;
@property (nonatomic, strong) NSString *buttonTitle;

@property (nonatomic, strong) pointChangedBlock thePointChangedBlock;


//-----------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//-----------------------------------------------------------------------------------------------------------
- (PointView *)thePoint;


@end

//
//  PointView.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/31/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^pointChangedBlock)(CGPoint point);

@interface PointView : UIView

@property (nonatomic, strong) pointChangedBlock thePointChangedBlock;


- (id) initWithCenter: (CGPoint) center andPointChangedBlock: (pointChangedBlock) thePointChangedBlock;

@end

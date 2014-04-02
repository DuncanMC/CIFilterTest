//
//  PointView.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/31/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PointViewDelegateProtocol.h"

@interface PointView : UIView


//------------------------------------------------------------------------------------------------------

@property (nonatomic, weak) id <PointViewDelegateProtocol> delegate;

- (id) initWithDelegate: (id <PointViewDelegateProtocol>) delegate;

@end

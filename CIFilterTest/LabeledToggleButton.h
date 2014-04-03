//
//  LabeledToggleButton.h
//  CIFilterTest
//
//  Created by Duncan Champney on 4/2/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "WTToggleButton.h"

@interface LabeledToggleButton : WTToggleButton
{
  UILabel *customTitleLabel;
}

@property (nonatomic, strong) NSString *buttonTitle;


- (void) doInitSetup;

@end

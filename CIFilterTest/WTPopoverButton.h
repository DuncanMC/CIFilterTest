//
//  WTPopoverButton.h
//  CIFilterTest
//
//  Created by Duncan Champney on 4/10/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTPopoverButton : UIButton <UIPopoverControllerDelegate>

@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) UIPopoverController *thePopover;


- (void) triggerValueChangedActions;
- (void) doInitSetup;
- (void) showPopover;


@end

//
//  WTColorPickerButton.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/28/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPopoverButton.h"

@interface WTColorPickerButton : WTPopoverButton
{
  UILabel *customTitleLabel;
}
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) UIPopoverController *thePopover;
@property (nonatomic, strong) NSString *buttonTitle;

//------------------------------------------------------------------------------------------------------


@end

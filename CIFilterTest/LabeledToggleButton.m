//
//  LabeledToggleButton.m
//  CIFilterTest
//
//  Created by Duncan Champney on 4/2/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "LabeledToggleButton.h"

@implementation LabeledToggleButton

//-----------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//-----------------------------------------------------------------------------------------------------------

- (void) setButtonTitle:(NSString *)buttonTitle;
{
  buttonTitle = buttonTitle;
  customTitleLabel.text = buttonTitle;
}

//------------------------------------------------------------------------------------------------------

- (void) doInitSetup;
{
  const CGFloat labelWidth = 120;
  const CGFloat labelHeight = 21;
  CGFloat x = CGRectGetMidX(self.bounds) - labelWidth/2;
  CGFloat y = CGRectGetMaxY(self.bounds) ;
  CGRect labelFrame = CGRectMake(x, y, labelWidth, labelHeight);
  customTitleLabel = [[UILabel alloc] initWithFrame: labelFrame];
  customTitleLabel.textAlignment = NSTextAlignmentCenter;
  customTitleLabel.font = [UIFont systemFontOfSize: 14];
  customTitleLabel.textColor =[UIColor blueColor];
  [self addSubview: customTitleLabel];
}

//------------------------------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self doInitSetup];
    }
    return self;
}

//------------------------------------------------------------------------------------------------------

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if (!self)
    return nil;
  [self doInitSetup];
  return self;
}


@end

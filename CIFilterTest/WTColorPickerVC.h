//
//  WTColorPickerVC.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/28/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"

@interface WTColorPickerVC : UIViewController

@property (weak, nonatomic) IBOutlet NKOColorPickerView *theColorPickerView;
@property (nonatomic, strong) NKOColorPickerDidChangeColorBlock didChangeColorBlock;
@property (nonatomic, strong) UIColor *color;;

@end

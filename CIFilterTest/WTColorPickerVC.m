//
//  WTColorPickerVC.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/28/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "WTColorPickerVC.h"

@interface WTColorPickerVC ()

@end

@implementation WTColorPickerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
  _theColorPickerView.didChangeColorBlock = _didChangeColorBlock;
  _theColorPickerView.color = _color;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

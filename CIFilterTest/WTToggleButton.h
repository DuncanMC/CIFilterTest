//
//  WTToggleButton.h
//  SaveMyPlace
//
//  Created by Duncan Champney on 12/29/09. Updated 03/08/2013.
//  Copyright 2013 WareTo. May be used for any purpose as long as this copyright notice remains.
//  WareTo logo and other artwork is Copyright (c) 2013 WareTo and may not be used outside of this demo.
//

#import <UIKit/UIKit.h>


@interface WTToggleButton : UIButton 

@property (nonatomic, strong) UIImage*	notSelectedImage;
@property (nonatomic, strong) UIImage*	selectedImage;

//Use these properties to assign an image to your button by loading an image from the bundle by name.
@property (nonatomic, copy) NSString *notSelectedImageName;
@property (nonatomic, copy) NSString *selectedImageName;

@end

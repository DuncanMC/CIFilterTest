//
//  Utils.m
//  ChromaKey
//
//  Created by Duncan Champney on 5/21/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#import "Utils.h"
#import <sys/sysctl.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>


@implementation Utils

static Utils * _sharedUtils;


//-----------------------------------------------------------------------------------------------------------
#pragma mark - Class methods
//-----------------------------------------------------------------------------------------------------------


+ (Utils *) sharedUtils;
{
  if (!_sharedUtils)
    _sharedUtils = [[Utils alloc] init];
  
  return _sharedUtils;
}

+ (CGRect) centerRect: (CGRect) firstRect
               inRect: (CGRect)secondRect;
{
  CGRect newRect;
  
  newRect = firstRect;
  
  newRect.origin.x = CGRectGetMidX(secondRect) - firstRect.size.width/2;
  newRect.origin.y = CGRectGetMidX(secondRect) - firstRect.size.height/2;
  return newRect;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - Instance methods
//-----------------------------------------------------------------------------------------------------------

@end

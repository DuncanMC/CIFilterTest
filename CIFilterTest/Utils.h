//
//  Utils.h
//  ChromaKey
//
//  Created by Duncan Champney on 5/21/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface Utils : NSObject
{
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark - Class methods
//-----------------------------------------------------------------------------------------------------------

+ (Utils *) sharedUtils;


+ (CGRect) centerRect: (CGRect) firstRect
               inRect: (CGRect)secondRect;

//-----------------------------------------------------------------------------------------------------------
#pragma mark - Instance methods
//-----------------------------------------------------------------------------------------------------------



@end

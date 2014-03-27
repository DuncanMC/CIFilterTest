//
//  FilterRecord.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/27/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterRecord: NSObject
{
}
@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSString *filterDisplayName;
@property (nonatomic, assign) BOOL filterIsDuplicate;
@end


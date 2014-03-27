//
//  FilterCategoryInfo.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/27/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FilterCategoryInfo: NSObject
{
}
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSMutableArray *filterRecords;
@property (nonatomic, strong) NSArray *filterRecordsWithNoDuplicates;
@property (nonatomic, assign) BOOL expandThisCategory;


@end

//
//  FilterCategoryInfo.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/27/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "FilterCategoryInfo.h"
#import "FilterRecord.h"

@implementation FilterCategoryInfo



- (NSString *) description;
{
  NSMutableString *result = [NSMutableString new];

  [result appendFormat: @"Category %@ contains %lu unique filters, %lu total\n",
   _categoryName,
   (unsigned long)_filterRecordsWithNoDuplicates.count,
   (unsigned long)_filterRecords.count];
  for (FilterRecord *aFilterRecord in _filterRecordsWithNoDuplicates)
  {
    [result appendFormat: @"\t\t%@", aFilterRecord];
  }
  return result;
}

@end

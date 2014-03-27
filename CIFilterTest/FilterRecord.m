//
//  FilterRecord.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/27/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "FilterRecord.h"

@implementation FilterRecord


- (NSString *) description;
{
  NSMutableString *result = [NSMutableString new];
  
  [result appendFormat: @"Filter %@, display name \"%@\" ",
   _filterName,
   _filterDisplayName];
  if (_filterIsDuplicate)
    [result appendString: @" (duplicate)\n"];
  else
    [result appendString: @"\n"];
  
  return result;
}

@end

//
//  FiltersList.m
//  CIFilterTest
//
//  Created by Duncan Champney on 3/27/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import "FiltersList.h"
#import "FilterCategoryInfo.h"
#import "FilterRecord.h"

@implementation FiltersList

static FiltersList* theFiltersList = nil;

//-----------------------------------------------------------------------------------------------------------
#pragma mark -	Object lifecycle methods
//-----------------------------------------------------------------------------------------------------------

+ (FiltersList*) sharedFiltersList;
{
  if (!theFiltersList)
    theFiltersList = [[FiltersList alloc] init];
  return theFiltersList;
}

//-----------------------------------------------------------------------------------------------------------

-(id) init;
{
  int duplicateCount = 0;
  
  self = [super init];
  if (!self)
    return nil;
  _hideDuplicates = YES;
  
  _uniqueFilterNames = [NSMutableArray new];
  
  
  NSArray *categoryNames = @[
                             kCICategoryDistortionEffect,
                             kCICategoryGeometryAdjustment,
                             kCICategoryCompositeOperation,
                             kCICategoryHalftoneEffect,
                             kCICategoryColorAdjustment,
                             kCICategoryColorEffect,
                             kCICategoryTransition,
                             kCICategoryTileEffect,
                             kCICategoryGenerator,
                             kCICategoryReduction,
                             kCICategoryGradient,
                             kCICategoryStylize,
                             kCICategorySharpen,
                             kCICategoryBlur,
                             kCICategoryVideo,
                             kCICategoryStillImage,
                             kCICategoryInterlaced,
                             kCICategoryNonSquarePixels,
                             kCICategoryHighDynamicRange ,
                             kCICategoryBuiltIn,];
  
  
  _filterCategories = [NSMutableArray arrayWithCapacity: categoryNames.count];
  _filterCategoriesExcludingDupes = [NSMutableArray arrayWithCapacity: categoryNames.count];
  
  //loop through the categories of CIFilter
  for (NSString *aCategoryName in categoryNames)
  {
    
    //Create a FilterCategoryInfo object for this category
    FilterCategoryInfo *aCategoryInfo = [[FilterCategoryInfo alloc] init];
    aCategoryInfo.categoryName = aCategoryName;
    NSArray *filters = [CIFilter filterNamesInCategory: aCategoryName];
    
    aCategoryInfo.filterRecords = [NSMutableArray arrayWithCapacity: filters.count];
    for (NSString *aFilterName in filters)
    {
      CIFilter *aFilter = [CIFilter filterWithName: aFilterName];
      
      NSDictionary *attributes = [aFilter attributes];
      NSString *filterDisplayName = attributes[kCIAttributeFilterDisplayName];
      FilterRecord *aFilterRecord = [[FilterRecord alloc] init];
      aFilterRecord.filterName = aFilterName;
      aFilterRecord.filterDisplayName = filterDisplayName;
      
      if ([_uniqueFilterNames containsObject: aFilterName])
      {
        duplicateCount++;
        //NSLog(@"duplicate filter named %@", aFilterName);
        aFilterRecord.filterIsDuplicate = YES;
      }
      else
      {
        [_uniqueFilterNames addObject: aFilterName];
      }
      [aCategoryInfo.filterRecords addObject: aFilterRecord];
    }
    
    //Find all the filters in this category that are not duplicates
    NSMutableArray *noDupesArray = [NSMutableArray new];
    for (FilterRecord *aFilterRecord in aCategoryInfo.filterRecords)
      if (!aFilterRecord.filterIsDuplicate)
        [noDupesArray addObject: aFilterRecord];
    aCategoryInfo.filterRecordsWithNoDuplicates = [noDupesArray copy];
    [_filterCategories addObject: aCategoryInfo];
    
    if (aCategoryInfo.filterRecordsWithNoDuplicates.count > 0)
      [_filterCategoriesExcludingDupes addObject: aCategoryInfo];
  }
  
  return self;
}


- (NSString *) description;
{
  NSMutableString *result = [NSMutableString new];
  [result appendFormat: @"%lu Categories\n\n(\n", (unsigned long)self.filterCategories.count];
  for (FilterCategoryInfo *aCategoryInfo in _filterCategoriesExcludingDupes)
  {
    [result appendFormat: @"\t%@", aCategoryInfo];
  }
  [result appendString:@")\n"];
  return result;
}
//-----------------------------------------------------------------------------------------------------------
#pragma mark -	UITableViewDataSource methods
//-----------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  return  nil;
}

//-----------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  return 0;
}

//-----------------------------------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
  return 0;
}

@end

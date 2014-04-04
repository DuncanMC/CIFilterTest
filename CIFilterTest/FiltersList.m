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
#pragma mark -	instance methods
//-----------------------------------------------------------------------------------------------------------

- (NSString *) filterNameForIndexPath: (NSIndexPath *) indexPath;
{
  FilterCategoryInfo *selectedCategory = (FilterCategoryInfo*)_filterCategoriesExcludingDupes[indexPath.section];
  
  FilterRecord *theRecord = selectedCategory.filterRecordsWithNoDuplicates[indexPath.row-1];
  
  NSString* title =  theRecord.filterName;

  return title;
}

//-----------------------------------------------------------------------------------------------------------

- (NSString *) filterDisplayNameForIndexPath: (NSIndexPath *) indexPath;
{
  FilterCategoryInfo *selectedCategory = (FilterCategoryInfo*)_filterCategoriesExcludingDupes[indexPath.section];
  
  FilterRecord *theRecord = selectedCategory.filterRecordsWithNoDuplicates[indexPath.row-1];
  
  NSString* title =  theRecord.filterDisplayName;
  
  return title;
}

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
  __block int duplicateCount = 0;
  
  self = [super init];
  if (!self)
    return nil;
  _hideDuplicates = YES;
  
  _uniqueFilterNames = [NSMutableArray new];
  NSMutableArray *missingCategories = [NSMutableArray new];

  
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
  
  void (^processFilterBlock)(NSString *aCategoryName, BOOL checkForMissingCategories)  =
  ^(NSString *aCategoryName, BOOL checkForMissingCategories)
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
      //----------------
      if (checkForMissingCategories)
      {
        NSArray *thisFilterCategories = attributes[kCIAttributeFilterCategories];
        for (NSString *aCategory in thisFilterCategories)
        {
          if (![categoryNames containsObject: aCategory])
          {
            if (![missingCategories containsObject: aCategory])
            {
              NSLog(@"category \"%@\" not in list of categories!", aCategory);
              [missingCategories addObject: aCategory];
            }
          }
        }
      }
      //----------------
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
  };
  
  
  //Do a pass through all the categories, adding them to our list.
  //On this pass, make note of any categories that are not in the categoryNames array
  for (NSString *aCategoryName in categoryNames)
  {
    processFilterBlock(aCategoryName, YES);
  }
  
  //Now process any filter categories that were not in the categoryNames array
  for (NSString *aCategoryName in missingCategories)
  {
    processFilterBlock(aCategoryName, NO);
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
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: self.cellIdentfier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: self.cellIdentfier];

  FilterCategoryInfo *thisCategory = theFiltersList.filterCategoriesExcludingDupes[indexPath.section];
  
  if (indexPath.row == 0)
  {
    cell.textLabel.text = thisCategory.categoryName;
    CGFloat pointsize =cell.textLabel.font.pointSize;
    cell.textLabel.font = [UIFont boldSystemFontOfSize: pointsize];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
  }
  else
  {
    CGFloat pointsize =cell.textLabel.font.pointSize;
    cell.textLabel.font = [UIFont systemFontOfSize: pointsize];
    NSString *filterName = ((FilterRecord *)thisCategory.filterRecordsWithNoDuplicates[indexPath.row - 1]).filterDisplayName;
    cell.textLabel.text = [NSString stringWithFormat: @"  %@", filterName];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
  }
  return  cell;
}

//-----------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  NSInteger result;
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
  FilterCategoryInfo *theCategory = ((FilterCategoryInfo *)theFiltersList.filterCategoriesExcludingDupes[section]);
  if (theCategory.expandThisCategory)
    result = theCategory.filterRecordsWithNoDuplicates.count+1;
  else
    result = 1;
  return result;
}

//-----------------------------------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];

  NSInteger result = theFiltersList.filterCategoriesExcludingDupes.count;
  return result;
}


- (NSIndexPath *) indexPathForFilterNamed: (NSString *) filterName;
{
  FilterCategoryInfo *aCategory;
  FilterRecord *aFilterRectord;
  NSIndexPath *result = nil;
  int row=0;
  int section = 0;
  BOOL found = NO;
  
  for (section = 0; section < _filterCategoriesExcludingDupes.count; section++)
  {
    aCategory = _filterCategoriesExcludingDupes[section];
    for (row = 0; row < aCategory.filterRecordsWithNoDuplicates.count; row++)
    {
      aFilterRectord = aCategory.filterRecordsWithNoDuplicates[row];
      if ([aFilterRectord.filterName isEqualToString: filterName])
      {
        found = YES;
        result = [NSIndexPath indexPathForRow: row+1 inSection: section];
        break;
      }
    }
    if (found)
      break;
  }
  return result;
}

@end

//
//  SelectInAppPurchaseController.m
//  ChromaKey
//
//  Created by Duncan Champney on 8/17/12.
//
//

#import "SelectFilterController.h"
#import "FiltersList.h"
#import "FilterCategoryInfo.h"
#import "FilterRecord.h"

//#import "PopupListItem.h"

#define kCartTag 100

@interface SelectFilterController ()

@end

@implementation SelectFilterController

//-----------------------------------------------------------------------------------------------------------
#pragma mark - property  methods
//-----------------------------------------------------------------------------------------------------------

- (void) setSelectedItemIndexPath:(NSIndexPath *) newValue;
{
  NSUInteger section = newValue.section;
  FiltersList *theFiltersList = [FiltersList sharedFiltersList];
  FilterCategoryInfo *theSelectedCategory = theFiltersList.filterCategoriesExcludingDupes[section];
  theSelectedCategory.expandThisCategory = YES;
  [super setSelectedItemIndexPath: newValue];
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - instance  methods
//-----------------------------------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL)animated
{
  theTableView.dataSource = [FiltersList sharedFiltersList];
  [super viewWillAppear: animated];
}

- (void) doInitSetup
{
  self.cellIdentifier = @"FilterCell";
  [FiltersList sharedFiltersList].cellIdentfier = self.cellIdentifier;
  [super doInitSetup];
}


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
  NSString *className;
  NSString *thisNibName;
  
  const char* classNameCString;
  if (nibName && [nibName length])
    return [super initWithNibName: nibName bundle: nibBundle];
  else
  {
    classNameCString = object_getClassName(self);
    className = [NSString stringWithCString: classNameCString encoding: NSUTF8StringEncoding];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
      thisNibName = [NSString stringWithFormat: @"%s%@", classNameCString, @"_iPhone"];
    }
    else
    {
      thisNibName = [NSString stringWithFormat: @"%s%@", classNameCString, @"_iPad"];
    }
    self = [self initWithNibName: thisNibName bundle:nil];
    
  }
  if (!self) return nil;
  [self doInitSetup];
  
  return self;
}
//-----------------------------------------------------------------------------------------------------------
#pragma mark - table view methods
//-----------------------------------------------------------------------------------------------------------

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  return 80;
//}

//-----------------------------------------------------------------------------------------------------------

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    FiltersList *theFilterList = [FiltersList sharedFiltersList];
    FilterCategoryInfo *theSelectedCategory = theFilterList.filterCategoriesExcludingDupes[indexPath.section];
    BOOL expandThisCategory = !theSelectedCategory.expandThisCategory;
    theSelectedCategory.expandThisCategory = expandThisCategory;
    int count = theSelectedCategory.filterRecordsWithNoDuplicates.count;
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity: count];
    NSUInteger section = indexPath.section;
    for (int index = 1; index <= count; index++)
    {
      NSIndexPath *anIndexPath = [NSIndexPath indexPathForItem: index inSection: section];
      [indexPaths addObject: anIndexPath];
    }
    
    if (expandThisCategory)
    {
      [theTableView insertRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationAutomatic];
      
    }
    else
      [theTableView deleteRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationAutomatic];
    
    return nil;
    
  }
  else
    return indexPath;
}

//-----------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView: tableView didSelectRowAtIndexPath: indexPath];
}

//-----------------------------------------------------------------------------------------------------------


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSUInteger row = [indexPath row];
  NSString *thisIdenifier = self.cellIdentifier;
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: thisIdenifier];
  
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: thisIdenifier];
  
  NSString *anItem = [self.namesArray objectAtIndex: row];
  cell.textLabel.text = anItem;
  
  
  
  cell.contentView.opaque = NO;
  cell.contentView.backgroundColor = [UIColor whiteColor];
  
  
  
  
  return cell;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - IBAction methods
//-----------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------




@end

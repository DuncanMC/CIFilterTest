//
//  SelectInAppPurchaseController.m
//  ChromaKey
//
//  Created by Duncan Champney on 8/17/12.
//
//

#import "SelectFilterController.h"
//#import "PopupListItem.h"

#define kCartTag 100

@interface SelectFilterController ()

@end

@implementation SelectFilterController


- (void) doInitSetup
{
  [super doInitSetup];
  self.cellIdentifier = @"FilterCell";
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

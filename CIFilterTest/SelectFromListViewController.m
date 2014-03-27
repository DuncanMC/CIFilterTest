//
//  SelectFromListViewController.m
//  Coloset
//
//  Created by Duncan Champney on 10/21/11.
//  Copyright (c) 2011 WareTo. All rights reserved.
//

#import "SelectFromListViewController.h"
#import "PopupListItem.h"


#define kDefaultCellIdentifier @"cell"

@implementation SelectFromListViewController

@synthesize namesArray;
@synthesize delegate;
@synthesize selectedItemIndex;
@synthesize headerString;
@synthesize dontAllow90DegreeRotation;

//-----------------------------------------------------------------------------------------------------------
#pragma mark - object lifecycle
//-----------------------------------------------------------------------------------------------------------

- (void) doInitSetup
{
//NSLog(@"Entering %s", __PRETTY_FUNCTION__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
      [self doInitSetup];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - property  methods
//-----------------------------------------------------------------------------------------------------------

- (void) setSelectedItemIndex:(NSInteger) newValue;
{
  selectedItemIndex = newValue;
  [self showSelectedItemAnimated: FALSE];
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - instance  methods
//-----------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------
#pragma mark - View lifecycle
//-----------------------------------------------------------------------------------------------------------

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
//  [self sizeTableToContainerView];
  [self showSelectedItemAnimated: TRUE];
}

//-----------------------------------------------------------------------------------------------------------

- (void) sizeTableToContainerView
{
  CGFloat adjustment = 0;
  // CGFloat tableHeight = tableViewContainerView.bounds.size.height;
  CGRect tableviewFrame = theTableView.frame;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
  {
    cancelButton.hidden = FALSE;
    adjustment = tableViewContainerView.bounds.size.height - cancelButton.frame.origin.y + 20;
    CGFloat tableHeight = tableViewContainerView.bounds.size.height - adjustment;
    
    tableviewFrame.size.width = tableViewContainerView.bounds.size.width;
    tableviewFrame.size.height = tableHeight;
  }
  theTableView.frame = tableviewFrame;
  [theTableView setNeedsDisplay];
  
}

//-----------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
  if (!_cellIdentifier)
    self.cellIdentifier = kDefaultCellIdentifier;
  
//  UINib * cellNib = [UINib nibWithNibName: _cellIdentifier bundle: nil];
//  [theTableView registerNib: cellNib forCellReuseIdentifier: _cellIdentifier];
  self.preferredContentSize = self.view.frame.size;
  //NSLog(@"view height = %.0f. Table view height = %.0f", self.view.frame.size.height, theTableView.frame.size.height);
  theTableView.backgroundColor = [UIColor clearColor];
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    self.selectNavItem.leftBarButtonItem = nil;
  [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------

- (void) showSelectedItemAnimated: (BOOL) animated
{
  NSIndexPath* theIndexPath = [NSIndexPath indexPathForRow: selectedItemIndex inSection: 0];
  
  [theTableView selectRowAtIndexPath: theIndexPath 
                            animated: animated 
                      scrollPosition: UITableViewScrollPositionMiddle];
  
  [theTableView scrollToRowAtIndexPath: theIndexPath atScrollPosition:UITableViewScrollPositionNone animated: animated];

}

//-----------------------------------------------------------------------------------------------------------

- (void)viewDidUnload
{
  cancelButton = nil;
  tableViewContainerView = nil;
  [self setSelectNavItem:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

//-----------------------------------------------------------------------------------------------------------

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//  BOOL result;
//    // Return YES for supported orientations
//  if (!dontAllow90DegreeRotation)
//    return TRUE;
//  else 
//  {
//    result =  (UIInterfaceOrientationIsPortrait(interfaceOrientation) == UIInterfaceOrientationIsPortrait(self.interfaceOrientation));
//    return result;
//  }
//}
//

//This is the iOS 6 way of returning the supported orientations. It is the "master" logic for the orientations
//This VC supports.

- (NSUInteger) supportedInterfaceOrientations
{
  NSUInteger supportedOrientations;
  if (!dontAllow90DegreeRotation)
    supportedOrientations = UIInterfaceOrientationMaskAll;
  else
  {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
      supportedOrientations = UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    else
      supportedOrientations = UIInterfaceOrientationMaskLandscape;
  }
  return supportedOrientations;
}

//-----------------------------------------------------------------------------------------------------------

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  //Ask the iOS 6 method which orientations are valid.
  NSUInteger supportedOrientations = [self supportedInterfaceOrientations];
  
  //Now return true if the bit flag for the requested orientation is set in supportedInterfaceOrientations
  BOOL ok = (supportedOrientations & (1 << interfaceOrientation)) != 0;
  return ok;
}
//-----------------------------------------------------------------------------------------------------------

- (void)viewWillAppear:(BOOL)animated
{
  _selectNavItem.title = self.headerString;
//  listHeader.text = self.headerString;
//  [theTableView scrollToNearestSelectedRowAtScrollPosition: UITableViewScrollPositionNone animated: FALSE];
//  [self sizeTableToContainerView];
  [self showSelectedItemAnimated: NO];
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - table view methods
//-----------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger row = [indexPath row];
  selectedItemIndex = row;
  [delegate userSelectedRow: row 
                     sender: self];
}

//-----------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  NSString *thisIdenifier = self.cellIdentifier;
  
  if (!thisIdenifier)
    thisIdenifier = kDefaultCellIdentifier;
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: thisIdenifier];
//  UITableViewCell* cell =  [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
//                                                  reuseIdentifier: _cellIdentifier];
  
  PopupListItem *anItem = [namesArray objectAtIndex: [indexPath row]];
  cell.textLabel.text = anItem.title;
  cell.textLabel.backgroundColor = [UIColor clearColor];
  
  
  cell.textLabel.textColor = anItem.available ? [UIColor whiteColor]: [UIColor grayColor];

  cell.contentView.opaque = NO;
  cell.contentView.backgroundColor = [UIColor clearColor];
  return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}


//-----------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [namesArray count];
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - IBAction methods
//-----------------------------------------------------------------------------------------------------------

- (IBAction)handleCancelButton:(id)sender 
{
  //Send a -1 (indicates cancel)
  [delegate userSelectedRow: -1
                     sender: self];
  
}

//-----------------------------------------------------------------------------------------------------------

- (IBAction)noneButtonAction:(id)sender
{
//NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  [delegate userSelectedRow: -2
                     sender: self];
  self.selectedItemIndex = 0;

}

//-----------------------------------------------------------------------------------------------------------


@end

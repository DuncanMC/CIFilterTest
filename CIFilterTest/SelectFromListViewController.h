//
//  SelectFromListViewController.h
//  Coloset
//
//  Created by Duncan Champney on 10/21/11.
//  Copyright (c) 2011 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewSelectionProtocol.h"

@interface SelectFromListViewController : UIViewController

{
//-----------------------------------------------------------------------------------------------------------
#pragma mark - Outlets
//-----------------------------------------------------------------------------------------------------------

  IBOutlet UITableView* theTableView;
  __weak IBOutlet UIButton *cancelButton;
  __weak IBOutlet UIView *tableViewContainerView;
}

@property (nonatomic, strong) NSArray* namesArray;
@property (nonatomic, weak)   id<TableViewSelectionProtocol> delegate;
@property (nonatomic)         NSInteger selectedItemIndex;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property (nonatomic, copy)   NSString *headerString;
@property (nonatomic, assign) BOOL dontAllow90DegreeRotation;
@property (nonatomic, copy)   NSString *cellIdentifier;
@property (weak, nonatomic)   IBOutlet UINavigationItem *selectNavItem;
@property (nonatomic) NSInteger popupTag;

- (void) doInitSetup;


- (IBAction)handleCancelButton:(id)sender;

//-----------------------------------------------------------------------------------------------------------
#pragma mark - table view methods
//-----------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)noneButtonAction:(id)sender;

@end

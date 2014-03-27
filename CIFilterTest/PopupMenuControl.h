//
//  PopupMenuControl.h
//  ContainerViewTest
//
//  Created by Duncan Champney on 1/3/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#define kUIOrientationWillChangeNotice  @"UIOrientationWillChangeNotice"
#define kUIOrientationDidChangeNotice  @"UIOrientationDidChangeNotice"

#import <UIKit/UIKit.h>
#import "TableViewSelectionProtocol.h"

//-----------------------------------------------------------------------------------------------------------

/*
 This class creates a popup menu style control. It presents an array of choices from its choices property
 using a table view. For iPad, the list of choices is presented in a popover control. For iPhone,
 the table view is presented as a modal view controller.
 
 You can optionally specify a headerString which is displayed as 
 It works in concert with a SelectFromListViewController object.
*/

@interface PopupMenuControl : UIButton <TableViewSelectionProtocol, UIPopoverControllerDelegate>

{
  NSUInteger selectedIndex;
  NSMutableArray *choices;
  __weak id<TableViewSelectionProtocol> delegate;
  __weak UIView *popoverSourceView;
  id willRotateObserver;
  id didRotateObserver;
  id popoverDismissedObserver;
  BOOL shifted;
  
  UILabel *popupLabel;

}

@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *choices;
@property (nonatomic, strong) UIPopoverController* thePopover;
@property (nonatomic, weak) id<TableViewSelectionProtocol> delegate;
@property (nonatomic, copy) NSString *headerString;
@property (nonatomic, copy) NSString *popupVCClassName;
@property (nonatomic, copy) NSString *popupVCClassNibName;

//If you set dontAllow90DegreeRotation to true, the popup won't allow 90 degree rotations on iPhone when the
//modal view controller is visible.

@property (nonatomic, assign) BOOL dontAllow90DegreeRotation;



@end

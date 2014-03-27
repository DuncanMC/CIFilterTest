//
//  PopupMenuControl.m
//  ContainerViewTest
//
//  Created by Duncan Champney on 1/3/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#import "PopupMenuControl.h"
#import "SelectFromListViewController.h"
#import "PopupListItem.h"
#import "MyTypes.h"
//#import "PopoverButton.h"

//#define kPopoverDismissedNotice  @"PopoverDismissedNotice"

@implementation PopupMenuControl

@synthesize selectedIndex;
@synthesize choices;
@synthesize thePopover;
@synthesize delegate;
@synthesize headerString;
@synthesize dontAllow90DegreeRotation;


//-----------------------------------------------------------------------------------------------------------
#pragma mark - property methods
//-----------------------------------------------------------------------------------------------------------

- (void) setSelectedIndex:(NSUInteger)newSelectedIndex;
{
  selectedIndex = newSelectedIndex;
  NSString *anItem = [self.choices objectAtIndex: selectedIndex];
  NSString* title =  anItem;
  if (choices && title)
  {
    popupLabel.text = title;
    

  }
  if (!delegate)
  {
    //NSLog(@"In %s, no delegate defined!", __PRETTY_FUNCTION__);
    return;
  }
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - instance methods
//-----------------------------------------------------------------------------------------------------------

- (void)awakeFromNib
{
  [super awakeFromNib];

  [self setTitle: @"" forState: UIControlStateNormal];
  [self setTitle: @"" forState: UIControlStateSelected];
  
  CGRect labelFrame = self.bounds;
  labelFrame.size.width -= 23;  //Don't use the right "disclosure triangle" part of the popup for the title.
  popupLabel = [[UILabel alloc] initWithFrame: labelFrame];
  UIColor *labelTextColor = [self titleColorForState: UIControlStateNormal];
  popupLabel.textColor = labelTextColor;
  popupLabel.backgroundColor = [UIColor clearColor];
  popupLabel.minimumScaleFactor  = 12.0 / popupLabel.font.pointSize;
  popupLabel.adjustsFontSizeToFitWidth = TRUE;
  popupLabel.opaque = NO;

  popupLabel.font = self.titleLabel.font;
  popupLabel.textAlignment = NSTextAlignmentCenter;
  
  [self addSubview: popupLabel];

}

//-----------------------------------------------------------------------------------------------------------

- (void) showPopover;
{
  
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  if (!willRotateObserver)
    willRotateObserver = [notificationCenter addObserverForName: kUIOrientationWillChangeNotice
                                                         object: nil
                                                          queue: nil
                                                     usingBlock:
                          ^(NSNotification *note) {
                            //NSLog(@"in willRotate block");
                            [self.thePopover dismissPopoverAnimated: FALSE];
                          }
                          ];
  
  if (!didRotateObserver)
    didRotateObserver = [notificationCenter addObserverForName:  kUIOrientationDidChangeNotice
                                                        object: nil
                                                         queue: nil
                                                    usingBlock:
                         ^(NSNotification *note) {
                           //NSLog(@"in didRotate block");
                           [self showPopover];
                         }
                         ];
  if (!popoverDismissedObserver)
    popoverDismissedObserver = [notificationCenter addObserverForName:  kPopoverDismissedNotice
                                                               object: nil
                                                                queue: nil
                                                           usingBlock:
                                ^(NSNotification *note) {
                                  //NSLog(@"in popoverDismissed block");
                                  [self removeObservers];
                                }
                                ];


  CGRect thesegementedControlRect = [popoverSourceView
                                     convertRect: popoverSourceView.bounds
                                     toView: popoverSourceView.window.rootViewController.view];
  
  [self.thePopover presentPopoverFromRect: thesegementedControlRect
                                   inView: popoverSourceView.window.rootViewController.view
                 permittedArrowDirections: UIPopoverArrowDirectionAny
                                 animated: TRUE];

}

//-----------------------------------------------------------------------------------------------------------

- (void) showArrayOfItems: (NSArray*) theArray
          inPopoverAtView: (UIView*) targetView
{
  SelectFromListViewController* thePopoverViewController = nil;
  popoverSourceView = targetView;
  
  if (_popupVCClassName)
  {
    NSBundle *theBundle = [NSBundle mainBundle];
    thePopoverViewController = (SelectFromListViewController*)[[[theBundle classNamed: _popupVCClassName] alloc] initWithNibName: _popupVCClassNibName bundle: nil];
  }
  else
  {
    thePopoverViewController = [[SelectFromListViewController alloc]
                                initWithNibName: @"SelectFromListViewController"
                                bundle: nil];
  }
  thePopoverViewController.popupTag = self.tag;
  
  thePopoverViewController.dontAllow90DegreeRotation = self.dontAllow90DegreeRotation;
  thePopoverViewController.headerString = self.headerString;
  thePopoverViewController.namesArray = theArray;
  thePopoverViewController.delegate = self;
  thePopoverViewController.selectedItemIndex = self.selectedIndex;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
  {
    //presentViewController: animated: completion
    [targetView.window.rootViewController presentViewController: thePopoverViewController
                                                            animated: TRUE
                                                     completion: nil];
    
//    [targetView.window.rootViewController presentModalViewController: thePopoverViewController
//                                                            animated: TRUE];
  }
  else
  {
    self.thePopover = [[UIPopoverController alloc] initWithContentViewController: thePopoverViewController];
    
    self.thePopover.delegate = self;
    [self showPopover];
    
  }
  
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - TableViewSelectionProtocol methods
//-----------------------------------------------------------------------------------------------------------

- (void) userSelectedRow: (NSInteger) row
                  sender: (id) sender;
{
  //NSLog(@"In %s", __PRETTY_FUNCTION__);
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated: TRUE
                                                                                       completion:
     ^{
       int adjustedRow = (int) row;
       if (adjustedRow != -1)
       {
         BOOL changed = selectedIndex != row;
         if (adjustedRow == -2)
           adjustedRow = 0;
         self.selectedIndex = adjustedRow;
         if (changed)
           [delegate userSelectedRow: adjustedRow
                              sender: self];
       }
     }];
  else
  {
    [thePopover dismissPopoverAnimated: TRUE];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName: kPopoverDismissedNotice object: self];

    if (row != -1)
    {
      int adjustedRow = (int) row;
      BOOL changed = selectedIndex != row;
      if (adjustedRow == -2)
        adjustedRow = 0;
      self.selectedIndex = adjustedRow;
      if (changed)
        [delegate userSelectedRow: adjustedRow
                           sender: self];
      

    }
  }
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - init methods
//-----------------------------------------------------------------------------------------------------------

- (void) doInitSetup
{
  UIEdgeInsets insets = UIEdgeInsetsMake(13, 6, 13, 23);
  UIImage *stretchImage = [UIImage imageNamed: @"Popup menu stretchable"];
  UIImage *backgroundImage = [stretchImage resizableImageWithCapInsets: insets];
  [self setBackgroundImage: backgroundImage forState:UIControlStateNormal];
  
  //DMC: leave the color that's set in IB.
//  UIColor *translucentBlackColor = [UIColor colorWithRed: 0.0
//                                                   green: 0.0
//                                                    blue: 0.0
//                                                   alpha: .6];
//  [self setTitleColor:translucentBlackColor forState:UIControlStateNormal];
  
  
  [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self addTarget: self 
           action: @selector(popupTapped) 
 forControlEvents: UIControlEventTouchUpInside];

}

- (id)initWithFrame:(CGRect)frame 
{
  if (self = [super initWithFrame:frame]) 
	{
		[self doInitSetup];
	}
  return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder;
{
	if (self = [super initWithCoder: aDecoder])
		[self doInitSetup];
	return self;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - IBAction methods
//-----------------------------------------------------------------------------------------------------------

- (IBAction) popupTapped
{
//NSLog(@"In %s", __PRETTY_FUNCTION__);
//  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
//  {
//    self.selectedIndex = (selectedIndex+1) % [choices count];
//    return;
//  }
  //NSLog(@"Entering %s. popupVCClass = %@", __PRETTY_FUNCTION__, _popupVCClass);

  [self showArrayOfItems: self.choices
         inPopoverAtView: self];

}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - UIPopoverControllerDelegate methods
//-----------------------------------------------------------------------------------------------------------

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
  BOOL result = TRUE;
  return result;
}

//-----------------------------------------------------------------------------------------------------------

- (void) removeObservers;
{
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  if (willRotateObserver)
    [notificationCenter removeObserver: willRotateObserver];
  if (didRotateObserver)
    [notificationCenter removeObserver: didRotateObserver];
  if (popoverDismissedObserver)
    [notificationCenter removeObserver: popoverDismissedObserver];

  willRotateObserver = nil;
  didRotateObserver = nil;
  popoverDismissedObserver = nil;

}

//-----------------------------------------------------------------------------------------------------------

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
  self.thePopover = nil;
  [self removeObservers];
  
}

@end

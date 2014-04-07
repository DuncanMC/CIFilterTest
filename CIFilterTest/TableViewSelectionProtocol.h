//
//  TableViewSelectionProtocol.h
//  Coloset
//
//  Created by Duncan Champney on 10/22/11.
//  Copyright (c) 2011 WareTo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewSelectionProtocol <NSObject>

//This method is for table views that use a single-section table view.
//Not used in this project.
- (void) userSelectedRow: (NSInteger) row 
                  sender: (id) sender;

- (void) userSelectedIndexPath: (NSIndexPath *) indexPath
                  sender: (id) sender;
@end

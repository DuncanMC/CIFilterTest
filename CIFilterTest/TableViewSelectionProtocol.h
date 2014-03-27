//
//  TableViewSelectionProtocol.h
//  Coloset
//
//  Created by Duncan Champney on 10/22/11.
//  Copyright (c) 2011 WareTo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewSelectionProtocol <NSObject>
- (void) userSelectedRow: (NSInteger) row 
                  sender: (id) sender;

- (void) userSelectedIndexPath: (NSIndexPath *) indexPath
                  sender: (id) sender;
@end

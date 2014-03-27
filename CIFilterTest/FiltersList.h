//
//  FiltersList.h
//  CIFilterTest
//
//  Created by Duncan Champney on 3/27/14.
//  Copyright (c) 2014 WareTo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FiltersList: NSObject <UITableViewDataSource>
{
}

@property (nonatomic, assign) BOOL hideDuplicates;
@property (nonatomic, strong) NSMutableArray *filterCategories;
@property (nonatomic, strong) NSMutableArray *filterCategoriesExcludingDupes;
@property (nonatomic, strong) NSMutableArray *uniqueFilterNames;


+ (FiltersList*) sharedFiltersList;

//-----------------------------------------------------------------------------------------------------------
#pragma mark -	UITableViewDataSource methods
//-----------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

@end

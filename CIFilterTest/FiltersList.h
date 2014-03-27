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

@property (nonatomic, strong) NSString *cellIdentfier;



+ (FiltersList*) sharedFiltersList;

//-----------------------------------------------------------------------------------------------------------
#pragma mark -	instance methods
//-----------------------------------------------------------------------------------------------------------

- (NSString *) filterNameForIndexPath: (NSIndexPath *) indexPath;
- (NSString *) filterDisplayNameForIndexPath: (NSIndexPath *) indexPath;

//-----------------------------------------------------------------------------------------------------------
#pragma mark -	UITableViewDataSource methods
//-----------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSIndexPath *) indexPathForFilterNamed: (NSString *) filterName;

@end

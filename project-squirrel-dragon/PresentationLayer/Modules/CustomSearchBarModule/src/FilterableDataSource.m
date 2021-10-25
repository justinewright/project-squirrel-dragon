//
//  FilterableDataSource.m
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/14.
//

#import "FilterableDataSource.h"

@implementation FilterableDataSource

-(instancetype)initWithViewModel:(CustomSearchBarViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

// MARK: - Table View DataSource Methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"forIndexPath:indexPath];
    if (self.viewModel.isFiltered) {
        cell.textLabel.text = self.viewModel.filteredList.reverseObjectEnumerator.allObjects[indexPath.row];
    } else {
        cell.textLabel.text = self.viewModel.list.reverseObjectEnumerator.allObjects[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.isFiltered ? self.viewModel.filteredList.count : self.viewModel.list.count;
}

@end

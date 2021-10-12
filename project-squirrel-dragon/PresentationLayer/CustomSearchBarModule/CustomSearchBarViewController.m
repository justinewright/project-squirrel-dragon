//
//  CustomSearchBarViewController.m
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/12.
//

#import "CustomSearchBarViewController.h"

@interface CustomSearchBarViewController ()

@end

@implementation CustomSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* objects = {@"1", @"2", @"3"};
    self.viewModel = [[CustomSearchBarViewModel alloc] initWithList: objects];
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView sizeToFit];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];


    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillLayoutSubviews {
    [super updateViewConstraints];
    self.tableHeight.constant = self.tableView.contentSize.height;
}

- (void)updateTableContentInset {
    NSInteger numRows = [self.tableView numberOfRowsInSection:0];
    CGFloat contentInsetTop = self.tableView.bounds.size.height;
    for (NSInteger i = 0; i < numRows; i++) {
        contentInsetTop -= [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (contentInsetTop <= 0) {
            contentInsetTop = 0;
            break;
        }
    }
    self.tableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
    dispatch_async(dispatch_get_main_queue(), ^{
            //This code will run in the main thread:
        [self.tableView sizeToFit];
            CGRect frame = self.tableView.frame;
            frame.size.height = self.tableView.contentSize.height;
            self.tableView.frame = frame;
        });
//    self.tableHeight.constant = self.tableView.contentSize.height;
}

- (IBAction)addButtonPressed:(id)sender {
    NSLog(@"add set");
}

// MARK: - Table View DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"forIndexPath:indexPath];
    if (self.viewModel.isFiltered) {
        cell.textLabel.text = self.viewModel.filteredList.reverseObjectEnumerator.allObjects[indexPath.row];
    } else {
        cell.textLabel.text = self.viewModel.list.reverseObjectEnumerator.allObjects[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.isFiltered ?self.viewModel.filteredList.count: self.viewModel.list.count;
}

// MARK: - Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.viewModel.isFiltered = false;
        [self.searchBar endEditing:YES];
    } else {
        self.viewModel.isFiltered = true;
        self.viewModel.filteredList = [[NSMutableArray alloc]init];

        for (NSString *item in self.viewModel.list) {
            NSRange range = [item rangeOfString:searchText];

            if (range.location != NSNotFound) {
                [self.viewModel.filteredList addObject: item];
            }
        }
    }
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
            //This code will run in the main thread:
            CGRect frame = self.tableView.frame;
            frame.size.height = self.tableView.contentSize.height;
            self.tableView.frame = frame;
        });
}

@end
// private variables in implemntation
//@implementation GLObject(PrivateMethods)
//- (void)secretFeature;
//@end

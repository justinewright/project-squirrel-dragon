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
// MARK: - private variables
NSString* searchText = @"";
float maxTableHeight = 150.0;
BOOL keyboardUp = NO;

// MARK: - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;

    id objects [] = {@"1", @"2", @"3"};
    NSUInteger count = sizeof(objects) / sizeof(id);
    NSArray* list = [NSArray arrayWithObjects:objects count:count];
    self.viewModel = [[CustomSearchBarViewModel alloc]initWithList:list];

    self.dataSource = [[FilterableDataSource alloc] initWithViewModel:self.viewModel];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];
    [self.tableView setHidden:YES];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [self.view addGestureRecognizer: panGesture];

    CALayer* borderr = [[CALayer alloc]init];
    borderr.frame = CGRectMake(140, 0, 100, 1);
    borderr.backgroundColor = [[UIColor grayColor] CGColor];

    [self.searchLabel.layer addSublayer:borderr];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillLayoutSubviews {
    [super updateViewConstraints];
    self.tableViewHeight.constant = self.tableView.contentSize.height;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//MARK: Keyboard Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    keyboardUp = YES;
    [self.tableView setHidden:NO];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    double keyboardDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.containerViewBottomAnchor.constant = keyboardSize.height - self.view.safeAreaInsets.bottom;
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    keyboardUp = NO;
    [self.tableView setHidden:YES];
    double keyboardDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.containerViewBottomAnchor.constant = 0;
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

//MARK: Buttons
- (IBAction)addButtonPressed:(id)sender {
    NSLog(@"add set");
}

-(void)hideSearchBarKeyboard {
    [self.view endEditing:YES];
    [_searchBar resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_searchBar.text = searchText;
        self.searchLabel.text = searchText;
        });
}

//MARK: TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideSearchBarKeyboard];
    if (_viewModel.isFiltered){
        searchText = _viewModel.filteredList[_viewModel.filteredList.count-(indexPath.row+1)] ;
        return;
    }
    searchText = _viewModel.list[_viewModel.list.count-(indexPath.row+1)] ;
}

//MARK: Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.viewModel.isFiltered = NO;

    } else {
        self.viewModel.isFiltered = YES;
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
        self.tableViewHeight.constant = MIN(self.tableView.contentSize.height, maxTableHeight);;
        });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.viewModel.isFiltered = NO;
}

//MARK: Gestures
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(keyboardUp){
        [self hideSearchBarKeyboard];
        searchText = @"";
    }

}
- (void)panRecognized:(UIPanGestureRecognizer *)rec
{
    if (keyboardUp)
        return;
    CGPoint vel = [rec velocityInView:self.view];

    if (vel.y > 0 && self.searchBar.isHidden)
    {
        [self hideSearchLabel];

        [self showSearchBar];
        [self showAddButton];
    }
    else if (vel.y < 0 && self.searchLabel.isHidden)
    {
        [self hideSearchBar];
        [self hideAddButton];

        [self showSearchLabel];

    }
}

-(void)showSearchBar {
    [self fadeIn:_searchBar];
}
-(void)hideSearchBar {
    [self fadeOut:_searchBar];
}
-(void)showSearchLabel {
    [self fadeIn:_searchLabel];

}
-(void)hideSearchLabel {
    [self fadeOut:_searchLabel];
}
-(void)showAddButton {
    [self fadeIn:_addButton];

}
-(void)hideAddButton {
    [self fadeOut:_addButton];
}

- (void)send:(nonnull NSString *)data {
    NSLog(data);
}

-(void)fadeIn: (UIView*) view {
    view.alpha = 0;
    view.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
}

-(void)fadeOut: (UIView*) view {
    [view setHidden:YES];
}

@end

// private variables in implemntation
//@implementation GLObject(PrivateMethods)
//- (void)secretFeature;
//@end

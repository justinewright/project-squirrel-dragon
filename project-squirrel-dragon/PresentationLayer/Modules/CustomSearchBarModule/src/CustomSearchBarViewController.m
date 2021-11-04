//
//  CustomSearchBarViewController.m
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/12.
//

#import "CustomSearchBarViewController.h"

//MARK: - Protected Variables
@interface CustomSearchBarViewController ()
@property (retain, nonatomic) CustomSearchBarViewModel* viewModel;
@property (retain, nonatomic) FilterableDataSource* dataSource;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeight;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

- (IBAction)addButtonPressed:(id)sender;
@end

@implementation CustomSearchBarViewController
// MARK: - Private Variables

NSString* searchFilter = @"";
float maxTableHeight = 200;
BOOL keyboardUp = NO;
float keyboardHeight = 300;
BOOL hideAddButton = NO;

double keyboardDownConstraint;
// MARK: - Initialize Method
- (void)configure: (CustomSearchBarViewModel*)viewModel withAddButton: (BOOL)hasAddButton {
    keyboardDownConstraint = self.containerViewBottomAnchor.constant;

    self.viewModel = viewModel;
    self.dataSource = [[FilterableDataSource alloc] initWithViewModel:self.viewModel];
    hideAddButton = !hasAddButton;
    [_addButton setHidden: hideAddButton];
    [self.tableView reloadData];
}

// MARK: - Setup Methods

- (void)setupTableView {
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];
    [self.tableView setHidden:YES];
}

- (void)setupSearchBar {
    self.searchBar.delegate = self;
    [self applyStyle];
}

- (void)applyStyle {
    CALayer* borderr = [[CALayer alloc]init];
    borderr.frame = CGRectMake(140, 0, 100, 1);
    borderr.backgroundColor = [[UIColor grayColor] CGColor];

    [self.searchLabel.layer addSublayer:borderr];
}

// MARK: - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupSearchBar];
    [self.backgroundView setUserInteractionEnabled:NO];
    [self.backgroundView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillLayoutSubviews {
    [super updateViewConstraints];
    self.tableViewHeight.constant = MIN(self.tableView.contentSize.height, maxTableHeight);
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
    [self.backgroundView setHidden:NO];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.tableView setHidden:NO];
    [self.addButton setHidden:YES];

    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;
    double keyboardDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.containerViewBottomAnchor.constant = keyboardSize.height - (hideAddButton ? 34 : 85);
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    keyboardUp = NO;
    [self.backgroundView setUserInteractionEnabled:NO];
    [self.backgroundView setHidden:YES];
    [self.addButton setHidden:NO || hideAddButton];

    [self.tableView setHidden:YES];

    double keyboardDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.containerViewBottomAnchor.constant = keyboardDownConstraint;
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

//MARK: Buttons
- (IBAction)addButtonPressed:(id)sender {
    [self.viewModel addSets];
}

- (void)hideSearchBarKeyboard {
    [self.view endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_searchBar.text = searchFilter;
        self.searchLabel.text = searchFilter;
        });
}

//MARK: TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideSearchBarKeyboard];
    if (self.viewModel.isFiltered){
        searchFilter = _viewModel.filteredList[_viewModel.filteredList.count-(indexPath.row+1)] ;
    } else {
        searchFilter = _viewModel.list[_viewModel.list.count-(indexPath.row+1)] ;
    }

    [_viewModel filter:searchFilter];
}

//MARK: Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchFilter = searchText;
    if (searchText.length == 0) {
        [self hideSearchBarKeyboard];
    }
    [self.viewModel filter:searchText];
    [self.tableView reloadData];
    self.tableViewHeight.constant = MIN(self.tableView.contentSize.height, maxTableHeight);
}

//MARK: Gestures

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (keyboardUp) {
        [self hideSearchBarKeyboard];
    }
}

- (void)handleScroll:( CGPoint *)scrollVelocity {
    if (scrollVelocity->y > 0 && self.searchBar.isHidden){
        [self fadeOut:_searchLabel];
        [self fadeIn:_searchBar];
        [self fadeIn:_addButton];
    } else if (scrollVelocity->y < 0 && self.searchLabel.isHidden){
        [self fadeOut:_searchBar];
        [self fadeOut:_addButton];
        [self fadeIn:_searchLabel];
    }
}

//MARK: Animations
- (void)fadeIn: (UIView*) view {
    view.alpha = 0;
    view.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
}

- (void)fadeOut: (UIView*) view {
    [view setHidden:YES];
}

@end

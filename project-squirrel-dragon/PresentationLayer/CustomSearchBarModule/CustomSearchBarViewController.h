//
//  CustomSearchBarViewController.h
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"
#import "CustomSearchBarViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface CustomSearchBarViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

- (IBAction)addButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

@property CustomSearchBarViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END

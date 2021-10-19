//
//  CustomSearchBarViewController.h
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"
#import "CustomSearchBarViewModel.h"
#import "FilterableDataSource.h"


NS_ASSUME_NONNULL_BEGIN

@interface CustomSearchBarViewController : UIViewController<UITableViewDelegate, UISearchBarDelegate>

-(void)configure: (CustomSearchBarViewModel*)viewModel;

@end

NS_ASSUME_NONNULL_END

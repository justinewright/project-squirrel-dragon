//
//  FilterableDataSource.h
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/14.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"
#import "CustomSearchBarViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FilterableDataSource : NSObject<UITableViewDataSource>
- (instancetype)initWithViewModel: (CustomSearchBarViewModel *) viewModel;
@property CustomSearchBarViewModel* viewModel;

@end

NS_ASSUME_NONNULL_END

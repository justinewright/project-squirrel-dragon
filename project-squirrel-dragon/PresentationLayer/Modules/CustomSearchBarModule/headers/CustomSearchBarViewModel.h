//
//  CustomSearchBarViewModel.h
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/11.
//

#ifndef CustomSearchBarViewModel_h
#define CustomSearchBarViewModel_h
#import <Foundation/Foundation.h>
@class CustomSearchBarViewModel;
@protocol CustomSearchbarViewModelDelegate <NSObject>
- (void)updateDisplay:(CustomSearchBarViewModel *)sender
     withSearchFilter: (NSString*)searchFilter;
@end

@interface CustomSearchBarViewModel: NSObject

- (instancetype)initWithList: (NSArray *) list
                 andDelegate: (id<CustomSearchbarViewModelDelegate>) delegate;
@property NSArray *list;
@property NSMutableArray *filteredList;
@property BOOL isFiltered;

-(void) filter: (NSString *)searchWord;

@end

#endif /* CustomSearchBarViewModel */

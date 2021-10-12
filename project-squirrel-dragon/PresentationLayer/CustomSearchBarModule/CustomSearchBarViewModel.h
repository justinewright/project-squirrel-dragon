//
//  CustomSearchBarViewModel.h
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/11.
//

#ifndef CustomSearchBarViewModel_h
#define CustomSearchBarViewModel_h
#import <Foundation/Foundation.h>

@protocol CustomSearchbarViewDelegate <NSObject>



@end

@interface CustomSearchBarViewModel: NSObject

- (instancetype)initWithList: (NSArray *) list;
@property NSArray *list;
@property NSMutableArray *filteredList;
@property BOOL isFiltered;
@end

#endif /* CustomSearchBarViewModel */

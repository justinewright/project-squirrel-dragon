//
//  SearchBarViewModel.m
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import "CustomSearchBarViewModel.h"

@interface CustomSearchBarViewModel()
@property (weak, nonatomic) id<CustomSearchbarViewDelegate> delegate;
@end

@implementation CustomSearchBarViewModel


-(instancetype)initWithList: (NSArray *) list andDelegate:(id<CustomSearchbarViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _isFiltered = NO;
        if ([delegate conformsToProtocol: @protocol(CustomSearchbarViewDelegate)]){
            self.delegate = delegate;
            self.list = list;
        }
    }
    return self;
}

-(void) updateFilteredList: (NSMutableArray *)list {
    self.filteredList = list;
    _isFiltered = list.count > 0;
}

- (void)filter:(NSString *)searchWord {
    NSMutableArray* searchResults = [[NSMutableArray alloc]init];
    if ([searchWord length] > 0) {
        searchResults = [[NSMutableArray alloc]init];

        for (NSString *item in _list) {
            NSRange range = [[item lowercaseString] rangeOfString:[searchWord lowercaseString]];

            if (range.location != NSNotFound) {
                [searchResults addObject: item];
            }
        }
    }
    [self updateFilteredList:searchResults];
    if ([self.delegate respondsToSelector:@selector(updateDisplay: withSearchFilter:)]) {
        [self.delegate updateDisplay:self withSearchFilter:searchWord];
    }
}

@end

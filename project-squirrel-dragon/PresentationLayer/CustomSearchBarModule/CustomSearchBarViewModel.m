//
//  SearchBarViewModel.m
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import "CustomSearchBarViewModel.h"

@implementation CustomSearchBarViewModel

-(instancetype)initWithList: (NSArray *) list {
    self = [super init];
    id objects [] = {@"1", @"2", @"3"};
    NSUInteger count = sizeof(objects) / sizeof(id);
    self.list = [NSArray arrayWithObjects:objects count:count];
    return self;
}



@end

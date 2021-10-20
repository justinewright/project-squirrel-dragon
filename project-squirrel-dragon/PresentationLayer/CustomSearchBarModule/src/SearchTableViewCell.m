//
//  SearchTableViewCell.m
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/12.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.numberOfLines = 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

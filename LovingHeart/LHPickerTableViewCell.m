//
//  LHPickerTableViewCell.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/31.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHPickerTableViewCell.h"

@implementation LHPickerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

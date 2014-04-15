//
//  LHUserInfoTCell.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/15.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHUserInfoTableViewCell.h"

@implementation LHUserInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
  self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.width / 2;
  self.userAvatarImageView.layer.masksToBounds = YES;
  self.userAvatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

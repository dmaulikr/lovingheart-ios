//
//  LHUserInfoCell.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/14.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHUserInfoCell.h"

@implementation LHUserInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
  self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.width / 2;
  self.userAvatarImageView.layer.masksToBounds = YES;
  self.userAvatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  StoryCell.m
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "StoryCell.h"

@implementation StoryCell

- (void)awakeFromNib {
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.avatarView.layer.cornerRadius = 25;
    self.avatarView.layer.masksToBounds = YES;
    self.pictureView.clipsToBounds = YES;
  
  _progressOverlayView = [[DAProgressOverlayView alloc] init];
  [self.pictureView addSubview:_progressOverlayView];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

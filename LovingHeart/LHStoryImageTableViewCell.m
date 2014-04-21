//
//  LHStoyImageTableViewCell.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/21.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoryImageTableViewCell.h"

@implementation LHStoryImageTableViewCell

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

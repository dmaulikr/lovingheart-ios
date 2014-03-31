//
//  LHIdeaSmallCell.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/31.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdeaCardCell.h"

@implementation LHIdeaCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
  self.ideaImageView.clipsToBounds = YES;
  _progressOverlayView = [[DAProgressOverlayView alloc] init];
  [self.ideaImageView addSubview:_progressOverlayView];
}

@end

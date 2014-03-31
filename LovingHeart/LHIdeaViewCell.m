//
//  LHIdeaViewCell.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdeaViewCell.h"

@implementation LHIdeaViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.ideaCardTitleLabel.text == nil || self.ideaCardTitleLabel.text.length <= 0) {
    self.ideaCardTitleLabel.hidden = YES;
  }
  [self.ideaContentLabel sizeToFit];
}

@end

//
//  IdeaCardView.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/24.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdeaCardView.h"

@implementation LHIdeaCardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
  NSLog(@"awake from nib");
  self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.ideaDescriptionLabel setNumberOfLines:0];
  [self.ideaDescriptionLabel sizeToFit];
  
  self.bounds = CGRectInset(self.frame, 10.f, 10.f);
}

@end

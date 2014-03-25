//
//  IdeaCardView.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/24.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdeaCardView.h"

@implementation LHIdeaCardView

- (id)init {
  if (self = [super init]) {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LHIdeaCardView" owner:self options:nil];
    self = [subviewArray objectAtIndex:0];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//
//- (UIView *)viewFromNib {
//  Class class = [self class];
//  NSString *nibName = NSStringFromClass(class);
//  NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
//  UIView *view = [nibViews objectAtIndex:0];
//  return view;
//}
//
//
//- (void)addSubviewFromNib {
//  UIView *view = [self viewFromNib];
//  view.frame = self.bounds;
//  [self addSubview:view];
//}

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

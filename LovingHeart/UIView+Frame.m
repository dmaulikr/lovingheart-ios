//
//  UIView+Frame.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/31.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)top {
  return self.frame.origin.y;
}

- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)left {
  return self.frame.origin.y;
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (CGFloat)height {
  return self.frame.size.height;
}

@end

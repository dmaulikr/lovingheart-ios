//
//  LHUser.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/25.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHGraphicImage.h"


@interface LHUser : PFUser

@property (nonatomic, strong) LHGraphicImage *avatar;
@property (nonatomic, strong) NSString *name;

@end

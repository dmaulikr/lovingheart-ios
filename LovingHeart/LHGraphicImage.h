//
//  LHGraphicImage.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/25.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LHGraphicImage : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *imageType;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) PFFile *imageFile;

@end

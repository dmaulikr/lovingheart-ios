//
//  LHFlag.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/5/2.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHFlag : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *Status;
@property (nonatomic, strong) NSString *Reason;
@property (nonatomic, strong) NSString *Object;
@property (nonatomic, strong) NSString *ObjID;

@end

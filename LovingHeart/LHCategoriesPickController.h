//
//  LHCategoriesPickController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/2.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CategoryPickDidSelectRowAtIndexPath)(NSIndexPath *indexPath, LHCategory *category);

@interface LHCategoriesPickController : PFQueryTableViewController

@property (nonatomic, strong) LHCategory *selectedCategory;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;

- (void)setDidSelectedRowAtIndexPath:(CategoryPickDidSelectRowAtIndexPath)didSelectRowAtIndexPath;

@end

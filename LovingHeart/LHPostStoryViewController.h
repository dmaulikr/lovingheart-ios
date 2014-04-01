//
//  LHPostStoryViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GCPlaceholderTextView.h>
#import <CoreLocation/CoreLocation.h>

@interface LHPostStoryViewController : UIViewController
<
  UITextViewDelegate,
  CLLocationManagerDelegate
>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButtonItem;
@property (weak, nonatomic) IBOutlet UITextView *userInputTextView;
@property (weak, nonatomic) IBOutlet UIToolbar *additionalToolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

//
//  LHStoryReviewViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/11.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoryReviewViewController.h"

@interface LHStoryReviewViewController ()

@end

@implementation LHStoryReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  self.cancelButtonItem.target = self;
  self.cancelButtonItem.action = @selector(cancelButtonPressed:);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)cancelButtonPressed:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

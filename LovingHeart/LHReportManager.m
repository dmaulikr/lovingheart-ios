//
//  LHReportManager.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/8.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHReportManager.h"

@implementation LHReportManager

- (NSString *)analyzeStoriesTags:(NSMutableArray *)tags withUser:(LHUser *)user {
  NSString *reportOne;
  NSMutableDictionary *tagsDictionary = [[NSMutableDictionary alloc] init];
  for (NSString *eachTag in tags) {
    NSString *trimmedTag = [eachTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [tagsDictionary setObject:([NSNumber numberWithInt:((NSNumber *)[tagsDictionary objectForKey:eachTag]).intValue + 1]) forKey:trimmedTag];
  }
  NSArray *sortedTagArray = [tagsDictionary keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [(NSNumber *)obj2 compare:(NSNumber *)obj1];
  }];
  
  if (sortedTagArray.count > 0) {
    int maxToShow = 5;
    NSString *tagsReport = [[NSString alloc] init];
    for (int i = 0; i< sortedTagArray.count; i++) {
      tagsReport = [tagsReport stringByAppendingString:[sortedTagArray objectAtIndex:i]];
      if ((i + 1)>=maxToShow) {
        break;
      } else {
        tagsReport =[tagsReport stringByAppendingString:@", "];
      }
    }
    reportOne = [NSString stringWithFormat:@"%@ 是一個 %@ 的人。", user.name, tagsReport];
  }
  return reportOne;
}

@end

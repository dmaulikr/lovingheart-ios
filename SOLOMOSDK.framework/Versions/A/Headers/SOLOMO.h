//
//  SOLOMO.h
//  SOLOMO_API
//
//  Created by Jie on 13/10/1.
//  Copyright (c) 2013年 Jie Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * 接收透過API回傳的資料
 */
@protocol SOLOMODelegate <NSObject>

/**
 * 要求成功
 * @param resultDict 回傳的Dictionary格式
 */
- (void)SOLOMORequestDidSucceed:(NSDictionary*)resultDict;
/**
 * 要求失敗
 * @param error 回傳的錯誤
 */
- (void)SOLOMORequestDidFail:(NSError*)error;

@end

/** SOLOMO API參數使用說明
 
 使用之前需引用
 
 - AdSupport.framework
 - CoreLocation.framework
 
 並且實做 SOLOMODelegate
 
 登入流程說明：
 
 - Hiiir 登入

 需自行製作UIWebView內嵌設定的網址 (從 webLogin 取得)

 監控UIWebView的網址，有

 adpower.hiiir.com

 字樣者，網址後token資訊

 呼叫 setToken: 後才可使用其餘需登入功能
 
 - Facebook 登入

 需使用指定AppID做登入，

 呼叫 loginWithFacebookToken:location: 後

 ，得到登入 Token 資訊
 呼叫 setToken: 後才可使用其餘需登入功能
 
 */
@interface SOLOMO : NSObject

/**
 * 連接並初始化SOLOMO SDK
 * @param appKey 提供的應用程式金鑰
 */
- (void)connectWithAppKey:(NSString *)appKey;

/** 連接並初始化SOLOMO SDK
 * @param appKey 提供的應用程式金鑰
 * @param open 使否開啟除錯
 */
- (void)connectWithAppKey:(NSString *)appKey debug:(BOOL)open;

/** 取得SDK目前版本號
 * @return SDK版本號
 */
- (NSString *)getSDKVersion;

/**
 * 呼叫取得優惠視窗 (Milestone使用)
 * @param level 遊戲等級
 * @param location 目前的位置
 */
- (void)getRewordWithLevel:(NSString *)level location:(CLLocation*)location;

/**
 * 與伺服器檢查版本號
 * @param location 目前的位置
 */
- (void)checkAPIVersionWithLocation:(CLLocation *)location;

/**
 * 取得優惠牆資訊 (OfferWall使用)
 * @param accountId 使用者的會員ID (未登入者傳入 0)
 * @param location 目前的位置
 * @param searchRange 搜尋的半徑(單位為英里)
 * @param keyword 關鍵字搜尋，帶空字串則無使用關鍵字
 * @param categoryIds 想要搜尋的分類
 * @param filters 預設帶DISTANCE字串
 * @param includeMission 是否要回傳包含mission的優惠
 * @param start 從第幾筆優惠資訊開始查
 * @param limit 回傳資料的筆數，預設為20
 */
- (void)getOfferListWithAccountId:(NSNumber*)accountId location:(CLLocation*)location
                      searchRange:(NSNumber*)searchRange keyword:(NSString*)keyword
                      categoryIds:(NSArray*)categoryIds filters:(NSArray*)filters
                   includeMission:(NSNumber*)includeMission start:(NSNumber*)start
                            limit:(NSNumber*)limit;

/**
 * 取得單筆的優惠資訊
 * @param accountId 使用者的會員ID
 * @param offerLocationId 優惠牆的優惠ID (可從 getOfferListWithAccountId:location:searchRange:keyword:categoryIds:filters:includeMission:start:limit: 取得)
 */
- (void)getOfferDetailsWithAccountId:(NSNumber*)accountId
                     offerLocationId:(NSNumber *)offerLocationId;

/**
 * 取得我的口袋的優惠清單
 * @param accountId 使用者的會員ID (未登入者傳入 nil)
 * @param location 目前的位置
 * @param redeemed 傳入 1 則回傳已經兌換過的優惠，傳入 0 則回傳尚未兌換的優惠
 */
- (void)getWalletOffersWithAccountId:(NSNumber*)accountId location:(CLLocation*)location
                            redeemed:(NSNumber*)redeemed;

/**
 * 增加單筆優惠資料到我的口袋
 * @param accountId 使用者的會員ID
 * @param offerLocationId 優惠牆的優惠ID(可從 getOfferListWithAccountId:location:searchRange:keyword:categoryIds:filters:includeMission:start:limit: 取得 或 getRewordWithLevel:location: 取得)
 */
- (void)addWalletWithAccountId:(NSNumber*)accountId offerLocationId:(NSNumber*)offerLocationId;

/**
 * 從我的口袋移除單筆優惠資料
 * @param accountId 使用者的會員ID
 * @param transactionId 口袋優惠ID
 */
- (void)removeWalletWithAccountId:(NSNumber*)accountId transactionId:(NSNumber*)transactionId;

/**
 * 取得追蹤清單
 * @param accountId 使用者的會員ID
 * @param location 目前的位置
 */
- (void)getFavoritesWithAccountId:(NSNumber*)accountId location:(CLLocation*)location;

/**
 * 加入至追蹤清單 (需登入)
 * @param accountId 使用者的會員ID
 * @param offerLocationId 優惠牆的優惠ID (可從 getOfferListWithAccountId:location:searchRange:keyword:categoryIds:filters:includeMission:start:limit: 取得)
 */
- (void)addFavoriteWithAccountId:(NSNumber*)accountId offerLocationId:(NSNumber*)offerLocationId;

/**
 * 從追蹤清單移除優惠 (需登入)
 * @param accountId 使用者的會員ID
 * @param offerLocationId 優惠牆的優惠ID (可從 getOfferListWithAccountId:location:searchRange:keyword:categoryIds:filters:includeMission:start:limit: 取得)
 */
- (void)removeFavoriteWithAccountId:(NSNumber*)accountId offerLocationId:(NSNumber*)offerLocationId;


/**
 * Hiiir帳號登入
 * @return 帳號登入網址 (使用內嵌UIWebView開啓)
 */
- (NSString *)webLogin;

/**
 * Facebook 登入
 * @param token Facebook登入所取得的Token
 * @param location 目前的位置
 */
- (void)loginWithFacebookToken:(NSString*)token location:(CLLocation*)location;

/**
 * 設定Token (可從Hiiir登入跳轉網址取得, loginWithFacebookToken:location: 取得)
 * 有需登入的字樣的API都需要透過setToken設定後才能使用
 * @param token 登入Token
 */
- (void)setToken:(NSString *)token;

/**
 * 取得使用者的資訊 (需登入)
 */
- (void)getUserProfile;

/**
 * 取得分類列表
 * @param categoryId 分類列表的ID(傳入 0 回傳最上層的所有分類)
 */
- (void)getCategoriesWithCategoryId:(NSNumber*)categoryId;


/**
 * 更新我的優惠資料的狀態 (兌換優惠卷)
 * @param accountId 使用者的會員ID
 * @param offerTransactionId 兌換時所傳入的優惠ID (可從 getWalletOffersWithAccountId:location:redeemed: 取得)
 * @param voucherStatus 更新後的狀態 (傳入 2 代表已兌換)
 * @param offerLocationId 優惠牆的優惠ID (可從 getOfferListWithAccountId:location:searchRange:keyword:categoryIds:filters:includeMission:start:limit: 取得)
 */
- (void)updateVoucherStatusWithAccountId:(NSNumber *)accountId
                      offerTransactionId:(NSNumber *)offerTransactionId
                                  status:(NSNumber *)voucherStatus
                         offerLocationId:(NSNumber *)offerLocationId;

/**
 * 與伺服器註冊推播
 * @param deviceToken 推播取得的deviceToken
 */
- (void)apnsRegisterWithDeviceToken:(NSString *)deviceToken;

/**
 * 更改密碼 (需登入)
 * @param password 原始密碼
 * @param newPassword 新的密碼
 */
- (void)changePassword:(NSString *)password newPassword:(NSString *)newPassword;

/**
 * 聯繫Qbon客服
 * @param email 聯絡的信箱
 * @param mobile 聯絡的手機
 * @param questionType 問題種類
 * @param content 問題內容 (可傳入 1.註冊/登入問題  2.手機系統問題  3.APP功能使用問題 4.店家資訊問題 5.功能建議)
 * @param location 目前的位置
 */
- (void)customerServiceCenterWithEmail:(NSString *)email mobile:(NSString *)mobile
                          questionType:(NSString *)questionType content:(NSString *)content
                              location:(CLLocation*)location;


- (void)getPointListWithPage:(NSNumber *)page;

- (void)getBannerList;

@property (nonatomic, weak) id<SOLOMODelegate>delegate;

@end

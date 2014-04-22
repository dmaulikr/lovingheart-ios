//
//  Qbon.h
//  QbonWidget_Source
//
//  Created by Jie on 13/10/22.
//  Copyright (c) 2013年 Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 接收透過API回傳的資料
 */
@protocol QbonDelegate <NSObject>

@optional

/**
 * 登入成功結果
 * @param qbon 本身物件
 * @param userData 回傳的Dictionary格式
 */
- (void)qbon:(id)qbon loginResult:(NSDictionary *)userData;

/**
 * 關閉通知
 * @param qbon 本身物件
 * @param complete 已關閉(回傳YES)
 */
- (void)qbon:(id)qbon close:(BOOL)complete;

@end

/**
 QbonWidget 畫面外掛
 
 使用之前需引用
 
 - SDWebImage 資料夾
 - FacebookSDK.framework
 - SOLOMOSDK.framework
 - AdSupport.framework
 - CoreLocation.framework
 - MapKit.framework
 - QuartzCore.framework
 - SystemConfiguration.framework
 - ImageIO.framework
 
 並且實做 QbonDelegate

 */
@interface Qbon : UIView

@property (nonatomic, strong) id<QbonDelegate> delegate;

/**
 * 連接並初始化QbonWidget
 * @param appKey 提供的應用程式金鑰
 * @param open 使否開啟除錯
 */
+ (void)connectAppKey:(NSString *) appKey debug:(BOOL)open;

/**
 * 連接並初始化QbonWidget
 * @param appKey 提供的應用程式金鑰
 */
+ (void)connectAppKey:(NSString *) appKey;

/**
 * 與Server註冊推播機器
 * @param deviceToken 推播取得的deviceToken
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;

/**
 * 隱藏左上角的關閉按鈕
 * @param hide 傳入 YES 代表要隱藏
 */
- (void)hideCloseButton:(BOOL)hide;

/**
 * 取得使用者的資料
 * @return 使用者的資料
 */
- (NSDictionary *)getUserData;

/**
 * 打開登入畫面
 */
- (void)openLogin;

/**
 * 打開優惠牆畫面
 */
- (void)openOfferWall;

/**
 * 打開我的優惠畫面
 */
- (void)openWallet;

/**
 * 打開獲得優惠的畫面(取得優惠)
 * @param level 遊戲等級
 * @param descPicImageNamed 領取優惠之後所顯示圖片圖檔名稱
 * 此圖為開發者自行製作，主要是標示出Qbon位於開發者APP的入口
 */
- (void)openPopupWithLevel:(NSInteger)level descPicImageNamed:(NSString *)descPicImageNamed;

@end

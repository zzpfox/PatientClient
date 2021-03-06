//
//  AppDelegate.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/10/29.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EMClientDelegate {

    var window: UIWindow?
    var locationManager:AMapLocationManager = AMapLocationManager()
    var lon:String = "0"
    var lat:String = "0"
    var departData = [String:[String]]()
    var tabBarController: UITabBarController?
    var homeMainVc:Home_main?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        bugly 配置
        Bugly.start(withAppId: StaticClass.BuglyAPPID)
//        Hud设置
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
        
        
//        获取基本数据
        self.initData()
//        百度推送
        self.setUpBaiDuPush(application, didFinishLaunchingWithOptions: launchOptions)
//        高德地图
        self.setUpMap()
//        环信
        self.setupHuanxin()
//        本地数据库
        DBHelper.setUpDB()
//        微信支付
        WXApi.registerApp(StaticClass.weixinAPPID)
//        友盟社交化分享
        self.setUpUmeng()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
        APPLICATION.homeMainVc?.updateView()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BPush.registerDeviceToken(deviceToken)
        BPush.bindChannel(completeHandler: {result, error in
            if error != nil {return}
            if result != nil {
                // 获取channel_id
                let BaiDu_Channel_id = BPush.getChannelId()
                dPrint(message: BaiDu_Channel_id)
                user_default.setUserDefault(key: user_default.channel_id, value: BaiDu_Channel_id!)
            }
        })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        if user_default.username.getStringValue() == nil {
            let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            APPLICATION.window?.rootViewController = vc_login
        }else {
            AlertUtil.popAlert(vc: (APPLICATION.window?.rootViewController!)!, msg: "有新的消息，点击查看", okhandler: {
                let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "mineMsg") as! Mine_msg_main
                APPLICATION.window?.rootViewController?.present(vc, animated: false, completion: nil)
            })
        }
        // App 收到推送的通知
        BPush.handleNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dPrint(message: error)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //支付宝支付
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url as URL!, standbyCallback: {
                (resultDic) -> Void in
                //调起支付结果处理
                AliPayManager.aliSdkManager.showResult(result: resultDic! as NSDictionary);
            })
        }
        // 微信支付
        WXApi.handleOpen(url, delegate: WeChatPayManager.wechatPayManager)
        // 友盟分享
        UMSocialManager.default().handleOpen(url)
//        [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        return true
    }
    
    
    // 强制退出 回调
    func userAccountDidLoginFromOtherDevice() {
        user_default.logout("账号在其他设备登录")
    }
    
    func userAccountDidRemoveFromServer() {
        user_default.logout("账号异常")
    }
    
    // MARK: - private method
    private func setUpBaiDuPush(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if (UIDevice.current.systemVersion as NSString).floatValue >= 10.0 {
            let center =  UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.alert,.badge,.sound], completionHandler: { (granted, error) in
                if granted {
                    application.registerForRemoteNotifications()
                }
            })
        }
        BPush.registerChannel([:], apiKey:StaticClass.TuisongAPIKey , pushMode: BPushMode.production, withFirstAction: "打开", withSecondAction: "关闭", withCategory: "test", useBehaviorTextInput: true, isDebug: true)
        //        关闭地理推送
        BPush.disableLbs()
        
        //        初始化百度推送
        let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
        if userInfo != nil{
            BPush.handleNotification(userInfo as! [AnyHashable : Any])
        }
    }
    
    private func setUpMap() {
        AMapServices.shared().apiKey = StaticClass.GaodeAPIKey
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.locationTimeout = 2
        
        locationManager.reGeocodeTimeout = 2
        
        MapUtil.singleLocation(successHandler: {location, reGeocode in
            if reGeocode != nil {
                if user_default.username.getStringValue() != nil {
                    if let province = reGeocode?.province,let city = reGeocode?.city, let district = reGeocode?.district {
                        NetWorkUtil.init(method: API.updatelocation(APPLICATION.lon, APPLICATION.lat, province, city,district)).newRequestWithOutHUD(successhandler: nil)
                    }
                    
                }
            }
        }, failHandler: {})
    }
    
    private func setupHuanxin() {
        let options = EMOptions.init(appkey: StaticClass.HuanxinAppkey)
        EMClient.shared().initializeSDK(with: options)
        EMClient.shared().add(self, delegateQueue: nil)
        
    }
    
    private func initData() {
        // 获取部门数据
        NetWorkUtil.getDepartMent(success: { response in
            let json = JSON(response)
            let data = json["data"].arrayValue
            for i in 0..<data.count{
                // 处理数据
                let one = data[i]["first"].stringValue
                let two = data[i]["second"].arrayObject as! [String]
                if one != "" {
                    self.departData[one] = two
                }
            }
        }, failture:{ error in dPrint(message: error)
        })
    }
    
    private func setUpUmeng() {
        UMSocialManager.default().umSocialAppkey = StaticClass.UmengAPPID
        
        /* 微信聊天 */
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wxd97a67a007393b4e", appSecret: "q7uv1349nx0da2pto9cmo8gku3zs6nx9", redirectURL: "http://mobile.umeng.com/social")
//        qq
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "1106692942", appSecret: "H0E2H0OFWbxMaGVG", redirectURL: "http://mobile.umeng.com/social")
//        微博
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "1234957746", appSecret: "b3564b393bfcb42672d8e84f084ea550", redirectURL: "https://sns.whalecloud.com/sina2/callback")
        
    }
    


}


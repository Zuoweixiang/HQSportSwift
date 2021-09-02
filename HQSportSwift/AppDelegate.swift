//
//  AppDelegate.swift
//  HQSportSwift
//
//  Created by jmf-mac on 2021/8/11.
//

import UIKit
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
/*
     
     //XMGetSecretApi un = 13333333333  baseUrl = https://gw.sit.qiuhui.com
     
     [HQRequest requestWithUrl:@"jmfen-sport-passport/v2/gt" header:@{} method:@"POST" params:@{@"un":@"13333333333"} resoneseParser:^id _Nullable(id  _Nonnull responseObj) {
         if ([responseObj isKindOfClass:NSDictionary.class] || [responseObj isKindOfClass:NSArray.class]) {
             NSString *tk = responseObj[@"tk"];
             return tk;
         }
         return  nil;
     } timeout:30 success:^(id  _Nonnull responseObj) {
         
     } fail:^(NSString * _Nonnull msg, NSError * _Nonnull err) {
         
     }];
     */


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        HQRequest.reuest(url:"/jmfen-sport-passport/v2/gt", header:Dictionary(), method: HTTPMethod.post, parameters: ["un":"13333333333"]) { responseDist  in
            print(responseDist)
        } fail: { msg, error in
            
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


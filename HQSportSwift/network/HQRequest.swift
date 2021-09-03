//
//  HQRequest.swift
//  HQSportSwift
//
//  Created by jmf-mac on 2021/8/17.
//

import Foundation
import Alamofire
import CryptoKit
import CommonCrypto
import CryptoTokenKit
typealias ReqSuccess = (_:Dictionary<String, Any>)->Void

class HQRequest {

    enum BaseUrl:String {
        case sit = "https://gw.sit.qiuhui.com"
        case dev = "https://gw.dev.qiuhui.com"
    }
    public static let baseUrl:String = HQRequest.BaseUrl.sit.rawValue
    
    public static var indexSet:IndexSet{
        get{
            var indexSet:IndexSet = IndexSet()
            indexSet.insert(integersIn: 200...299)
            indexSet.insert(400)
            indexSet.insert(401)
            indexSet.insert(403)
            indexSet.insert(500)
            return indexSet
        }
    }
    class func reuest(url:String,header:Dictionary<String,String>, method:HTTPMethod, parameters:Dictionary<String,String>, success:@escaping (_ s:Dictionary<String, Any>)->Void,fail:@escaping(_ msg :String,_ err:Error)->Void ){
        
        //tip对于post方法query传参方式，直接放在URL传参就好了[jmfen-sport-passport/v2/gt%@，un];
        AF.sessionConfiguration.timeoutIntervalForRequest = 10
        AF.request(baseUrl+url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: HTTPHeaders(header),interceptor: nil, requestModifier: nil)
//            .response(responseSerializer:JSONResponseSerializer()){
//            response  in
//                //print(response.data)
//                print(response.result)
////                do{
////                    let JSONDict = try JSONDecoder().decode(Dictionary<String,>.self, from: response.data!)
////
////                    print(JSONDict)
////                }catch let error{
////                    print(error)
////                }
////
////                let jsonDict = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers)
////
////               success(jsonDict as! Dictionary<String, Any>)
//            }.validate(statusCode:self.indexSet)
            .response(responseSerializer: JSONResponseSerializer()) { response in
                switch response.result {
                case .success(let value):do {
                    print(value )
                    success(value as! Dictionary<String, Any>)
                    break
                }
                case .failure(let error ):do{
                    print(error)
                    fail("shibai", error)
                    break
                
                }
                }
            }
       
    }
   
    class func startMonitor(){
        NetworkReachabilityManager.default?.startListening(onQueue: DispatchQueue.global(), onUpdatePerforming: { status in
            switch status {
            case .unknown:
                break
            case .notReachable:
                break
            case .reachable(.cellular):
                break
            case .reachable(.ethernetOrWiFi):
                break
            default: break
            }
        })
    }
    
    class func stopMonitor(){
        NetworkReachabilityManager.default!.stopListening()
    }
    
    class func isReachable()->Bool{
        return NetworkReachabilityManager.default!.isReachable
    }
    
    class func isReachableViaWAN()->Bool{
        return NetworkReachabilityManager.default!.isReachableOnCellular
    }
    
    class func isReachableWiFi()->Bool{
        return NetworkReachabilityManager.default!.isReachableOnEthernetOrWiFi
    }
    
    public class var is_Reachable:Bool {
        return NetworkReachabilityManager.default!.isReachable
    }
    
    class func httpHeader()->Dictionary<String,String>?{
        var header:Dictionary = Dictionary<String, String>()
        let userAgent = "AppStore/\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String) (\(UIDevice.current.model); iOS \(UIDevice.current.systemVersion); Scale/\(String(format:"%.2f",UIScreen.main.scale))) channel/AppStore"
        let timestamp:String? = self.getTimeString
        let none:String? = self.xmRandomString
        let sign:String? = self.md5String(string: timestamp!+none!)
        let idfv:String = UIDevice.current.identifierForVendor!.uuidString
        
        header.updateValue("application/json", forKey: "Content-Type")
        header.updateValue("gzip", forKey: "Accept-Encoding")

        header.updateValue(userAgent, forKey: "User-Agent")
        header.updateValue(timestamp ?? "", forKey: "timestamp")
        header.updateValue(sign ?? "", forKey: "sign")
        header.updateValue(none!, forKey: "none")
        header.updateValue("https://ios.qiuhui.com", forKey: "referer")
        if (idfv.count > 0) {
            header.updateValue(idfv, forKey: "device_id")
        }
        let userToken:String? = nil
        if (userToken != nil) {
            header.updateValue(String("Bearer \(userToken)"), forKey: "Authorization")
        }else{
            header.updateValue("Basic YXBwOmFwcA==", forKey: "Authorization")
        }
        
        return header
    }
    
    static var getTimeString: String?{
        String(format:"%.0f" , Date().timeIntervalSince1970*1000)
    }
    
    static var randomString:String?{
        let uuid = UUID().uuidString
        if (uuid.count != 0) {
            return uuid
        }
        return self.xmRandomString
    }
    
    static var xmRandomString:String {
        let kNum = 32
        let sourceString:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var resultString:String = String()
        for _ in  0...kNum  {
            let offset:Int = Int(arc4random()/36)
            let index:String.Index? = sourceString.index(sourceString.startIndex, offsetBy: offset, limitedBy: sourceString.endIndex)
            let subString = sourceString[(index ?? sourceString.startIndex) as String.Index]
            print(subString)
            resultString.append(subString)
        }
        return resultString
    }
    
    class func md5String(string:String)->String?{
        let utf8 = string.cString(using: .utf8)
        var digest = [CUnsignedChar](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8,CC_LONG(utf8!.count-1),&digest)
        return digest.reduce(""){
            return $0+String(format:"%02X", $1)
        }
    }
}
/*

 + (NSString *)djj_md5:(NSString *)str
 {
     NSData* inputData = [str dataUsingEncoding:NSUTF8StringEncoding];
     unsigned char outputData[CC_MD5_DIGEST_LENGTH];
     CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
     
     NSMutableString* hashStr = [NSMutableString string];
     int i = 0;
     for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
     {
         [hashStr appendFormat:@"%02x", outputData[i]];
     }
     return hashStr;
 }

 + (NSString *)xm_randomString{
     NSString *result =  [[NSUUID UUID] UUIDString];
     if (result.length) {
         return result;
     }else{
         return [self getRandomString];
     }
     
 }
 + (NSString *)getRandomString
 {
     //声明并赋值字符串长度变量
     static NSInteger kNumber = 32;
     //随机字符串产生的范围（可自定义）
     NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
     //可变字符串
     NSMutableString *resultString = [NSMutableString string];
     //使用for循环拼接字符串
     for (NSInteger i = 0; i < kNumber; i++) {
         //36是sourceString的长度，也可以写成sourceString.length
         [resultString appendString:[sourceString substringWithRange:NSMakeRange(arc4random() % 36, 1)]];
     }
     return resultString;
 }
 
 // 为某些Service需要拼凑额外的HTTP Header（如 基础参数basicParams）
 + (NSDictionary *)extraHttpHeadParmas
 {
     NSMutableDictionary *extraHeaderDict = [NSMutableDictionary dictionary];
     NSString *userAgent = nil;
     userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f) channel/%@",@"AppStore", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale],@"AppStore"];
     NSString *timestamp = [self  getTimeString];
     NSString *nonce = [self  xm_randomString];
     NSString *sign = [self djj_md5:[NSString stringWithFormat:@"%@%@", timestamp,nonce]];
     NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
     [extraHeaderDict setValue:@"application/json" forKey:@"Content-Type"];
     [extraHeaderDict setValue:userAgent forKey:@"User-Agent"];
     [extraHeaderDict setValue:timestamp forKey:@"timestamp"];
     [extraHeaderDict setValue:sign forKey:@"sign"];
     [extraHeaderDict setValue:nonce forKey:@"nonce"];
     [extraHeaderDict setValue:@"gzip" forKey:@"Accept-Encoding"];
     [extraHeaderDict setValue:@"https://ios.qiuhui.com" forKey:@"referer"];
     if (idfv.length) {
         [extraHeaderDict setValue:idfv forKey:@"device_id"];
     }
 //    if ([XMAppConfigure sharedConfigure].deviceToken!=nil) {
 //        [extraHeaderDict setValue:[XMAppConfigure sharedConfigure].deviceToken forKey:@"devicetoken"];
 //    }
 //    NSString *registrationID = [XMAppConfigure sharedConfigure].registrationID;
 //    if (registrationID.length) {
 //        [extraHeaderDict setValue:registrationID forKey:@"registrationid"];
 //    }
     NSString *userToken = [GLJAccountTool account].token;
     if (userToken) {
         [extraHeaderDict setValue:[NSString stringWithFormat:@"%@ %@", @"Bearer", userToken] forKey:@"Authorization"];
     } else {
         [extraHeaderDict setValue:@"Basic YXBwOmFwcA==" forKey:@"Authorization"];
     }
     return extraHeaderDict;
 }*/


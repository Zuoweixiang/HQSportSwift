//
//  HQRequest.swift
//  HQSportSwift
//
//  Created by jmf-mac on 2021/8/17.
//

import Foundation
import Alamofire
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
    class func reuest(url:String,header:Dictionary<String,String>, method:HTTPMethod, parameters:Dictionary<String,String>, success:@escaping (_ s:Dictionary<String, Any>)->Void,fail:(_ msg :String,_ err:Error)->Void ){
        
        AF.sessionConfiguration.timeoutIntervalForRequest = 10
        AF.request(baseUrl+url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: HTTPHeaders(header),interceptor: nil, requestModifier: nil)
            .response{
            response  in
            print(response)
                let jsonDict = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers)
                
               success(jsonDict as! Dictionary<String, Any>)
            }.validate(statusCode:self.indexSet)
        
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
    
    
}



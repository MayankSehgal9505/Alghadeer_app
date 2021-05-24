//
//  NetworkManager.swift
//  Equal Infotech
//  Created by Equal Infotech on 14/06/19.
//  Copyright © 2019 Equal Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

 enum HTTPSMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
/// Class for making Api calls
public class NetworkManager {
    
    //MARK: Variable declaration
    static let sharedInstance = NetworkManager()
    static var viewControler: UIViewController?
    //MARK:- Check Internet Connectivity
    func isInternetAvailable() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    //MARK:- Common Network Service Call
    func commonApiCall(url:String,method:HTTPSMethod,jsonObject:Bool = false, parameters : [String:Any]?,completionHandler:@escaping (JSON?,String?)->Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        switch method {
        case .get:
            break
        case .post,.put:
            if jsonObject {
                let jsonData = try? JSONSerialization.data(withJSONObject: parameters as Any)
                request.httpBody = jsonData
                request.addValue("application/json;", forHTTPHeaderField: "Content-Type")
            } else {
                let postString = self.getPostString(params: parameters!)
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpBody = postString.data(using: .utf8)
            }
        default:
                break
        }

        if let token = Defaults.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 45.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let dataRecieved = data {
                    let json = try JSON.init(data: dataRecieved,options: .allowFragments)
                    print(json)
                    if let sessionExpired = json["Authorization"].bool, sessionExpired == false,let vc = NetworkManager.viewControler {
                        DispatchQueue.main.async {
                            vc.showSessionExpiredAlert()
                        }
                        completionHandler(json,nil)
                    } else {
                        completionHandler(json,nil)
                    }
                } else {
                    completionHandler(nil,"error")
                }
            } catch {
                completionHandler(nil,error.localizedDescription)
            }
        })

        task.resume()
    }

    func uploadDocuments(url:String,method:HTTPMethod,imagesDict:[String:Data],parameters : [String:Any]?,headers: HTTPHeaders? = nil,completionHandler:@escaping (JSON?,String?)->Void) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let params = parameters {
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
                
            for (key, value) in imagesDict {
                multipartFormData.append(value, withName: "\(key)", fileName: "\(key).jpg", mimeType: "image/jpg")
            }
          }, usingThreshold: UInt64.init(), to: url, method: .post,headers: headers) { (result) in
              switch result{
              case .success(let upload, _, _):
                  upload.responseJSON { response in
                      print("Succesfully uploaded  = \(response)")
                      if let err = response.error{
                        completionHandler(nil,err.localizedDescription)
                          print(err)
                          return
                      }
                    if let data = response.value{
                        let json = JSON(data)
                        completionHandler(json,nil)
                        return
                    }
                  }
              case .failure(let error):
                completionHandler(nil,error.localizedDescription)
              }
          }

  }
  


}
//Class ends here

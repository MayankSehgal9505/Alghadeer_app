//
//  NetworkManager.swift
//  Equal Infotech
//  Created by Equal Infotech on 14/06/19.
//  Copyright © 2019 Equal Infotech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Class for making Api calls
public class NetworkManager {
    
    //MARK: Variable declaration
    static let sharedInstance = NetworkManager()
    
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
    func commonApiCall(url:String,method:HTTPMethod,parameters : [String:Any]?,completionHandler:@escaping (JSON?,String?)->Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        switch method {
        case .get:
            break
        case .post:
            let postString = self.getPostString(params: parameters!)
            request.httpBody = postString.data(using: .utf8)
        default:
                break
        }

        if let token = Defaults.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSON.init(data: data!)
                print(json)
                //let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                completionHandler(json,nil)
            } catch {
                completionHandler(nil,error.localizedDescription)
            }
        })

        task.resume()
        /* AF.request(URL.init(string: url)!, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            print("response \(response)")
            switch response.result {
            case .success(_):
                if let data = response.value{
                    let json = JSON(data)
                    print(json)
                    completionHandler(json,nil)
                    return
                }
                break
            case .failure(let error):
                completionHandler(nil,error.localizedDescription)
                break
            }
        }*/
    }
}
//Class ends here

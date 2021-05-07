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
            do {
                let json = try JSON.init(data: data!)
                print(json)
                if let sessionExpired = json["Authorization"].bool, sessionExpired == false,let vc = NetworkManager.viewControler {
                    DispatchQueue.main.async {
                        vc.showSessionExpiredAlert()
                    }
                    completionHandler(json,nil)
                } else {
                    completionHandler(json,nil)
                }
            } catch {
                completionHandler(nil,error.localizedDescription)
            }
        })

        task.resume()
    }
}
//Class ends here

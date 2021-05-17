//
//  NetworkManager.swift
//  Equal Infotech
//  Created by Equal Infotech on 14/06/19.
//  Copyright © 2019 Equal Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

 enum HTTPMethod: String {
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
    func commonApiCall(url:String,method:HTTPMethod,jsonObject:Bool = false, parameters : [String:Any]?,completionHandler:@escaping (JSON?,String?)->Void) {
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
                request.httpBody = postString.data(using: .utf8)
            }
        default:
                break
        }

        if let token = Defaults.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let session = URLSession.shared
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
    func API_POST_FORM_DATA(url:String,method:HTTPMethod, parameters : [String:Any]?,imagesDict:[String:Data],completionHandler : @escaping (JSON?,String?)->Void)
    {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()

        //define the multipart request type

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


        let body = NSMutableData()
        let fname = "profile"
        let mimetype = "image/png"

        //define the data post parameter

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)

        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)

        if let imageRawData = imagesDict[fname]
        {
            body.append("Content-Disposition:form-data; name=\"song\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageRawData)
        }
        body.append("\r\n".data(using: String.Encoding.utf8)!)

        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

        for (key, value) in parameters!
        {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }

        request.httpBody = body as Data

        // return body as Data
        print("Fire....")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
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

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }


  


}
//Class ends here

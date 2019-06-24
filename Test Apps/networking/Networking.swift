//
//  Networking.swift
//  Test Apps
//
//  Created by Arief Zainuri on 24/06/19.
//  Copyright © 2019 Arief Zainuri. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking: NSObject {
    
    static let instance = Networking()

    func getPropertyTypes(completionHandler: @escaping(_ list: [Property]?, _ error: String?) -> Void) {
        
        var url = URLRequest(url: URL(string: "http://didin.api.iprop-dev.com/api/property-types")!)
        url.setValue("Bearer \(UserDefaults.standard.string(forKey: StaticKey.token) ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: url as URLRequest) { (data, response, e) in

            if let error = e {
                completionHandler(nil, error.localizedDescription)
                return
            }

            do {
                let properties = try JSONDecoder().decode([Property].self, from: data!)
                completionHandler(properties, nil)
            } catch let err { completionHandler(nil, err.localizedDescription) }

        }.resume()
    }
    
    func postProperty(property: String, completion: @escaping(_ error: String?) -> Void) {
        let url = "http://didin.api.iprop-dev.com/api/property-types"
        let body : [String: String] = [
            "name": property
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: StaticKey.token) ?? "")"
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let responseSuccess):
                let data = JSON(responseSuccess)
                completion(nil)
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription)
            }
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping(_ message: String?) -> Void) {
        let param: [String : String] = [
            "email": "didinonpqcms@gmail.com",
            "password": "testing12345"
        ]
        
        let url = "http://didin.api.iprop-dev.com/api/login"
        
        Alamofire.request(url, method: .post, parameters: param as Parameters).responseJSON { (response) in
            switch response.result {
            case .success(let responseSuccess):
                let data = JSON(responseSuccess)
                let token = data["token"].string
                print(token ?? "")
                UserDefaults.standard.set(token, forKey: StaticKey.token)
                UserDefaults.standard.set(true, forKey: StaticKey.isLogin)
                completionHandler(nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(error.localizedDescription)
            }
            
        }
    }
}

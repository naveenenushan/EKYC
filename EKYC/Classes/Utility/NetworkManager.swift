//
//  NetworkManager.swift
//  nConnect
//
//  Created by Mac  on 20/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NetworkManager {
    
    private static var sharedNetworkManager: NetworkManager = {
        
        let networkManager = NetworkManager()
        return networkManager
    }()
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    func getAccessToken(_ parameters:[String:Any], completion: @escaping (_ success: Bool, _ jsonResponse: JSON, _ error: Error?) -> ()) {
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        print(headers)
        let url = URL(string: eKYCApiConst.BASEURL+"core/connect/token")
        AF.request(url!, method: .post, parameters: parameters, encoding: URLEncoding(), headers: nil).response { (response) in
           print(response)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if (response.error != nil) {
                completion(false, JSON(), response.error)
            } else {
                do {
                    let jsonResponse = try JSON(data: response.data!)
                    completion(true, jsonResponse, nil)
                }
                catch _ {
                    completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
                }
            }
        }
        
    }

    func getLivenessCredentials(_ parameters:[String:Any], completion: @escaping (_ success: Bool, _ jsonResponse: JSON, _ error: Error?) -> ()) {
        
        SVProgressHUD.show()
       SVProgressHUD.setDefaultMaskType(.clear)
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(EKYCTOKEN)",
            "subscription": SUBSCRIPTION,
        ]
        
        let url = URL(string: eKYCApiConst.EKYCBASEURL+"liveness-credentials")
        AF.request(url!, method: .get, parameters: parameters, encoding: URLEncoding(), headers: headers).response { (response) in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if (response.error != nil) {
                completion(false, JSON(), response.error)
            } else {
                do {
                    let jsonResponse = try JSON(data: response.data!)
                    completion(true, jsonResponse, nil)
                }
                catch _ {
                    completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
                }
            }
        }
        
    }
    
    func uploadOcrImage(_ image: UIImage, side: String = "FRONT", completion: @escaping (_ success: Bool, _ jsonResponse: JSON, _ error: Error?) -> ()) {
       
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let url = eKYCApiConst.EKYCBASEURL+"ocrinfo?referenceId=\(REFERENCEID)&country=\(COUNTRYCODE)&documentType=\(DOCUMENTTYPE)&side=\(side)"
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(EKYCTOKEN)",
            "subscription": SUBSCRIPTION,
        ]
          
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image.wxCompress().jpegData(compressionQuality: 1)!, withName: "image", fileName: "image.png", mimeType: "image/jpeg")
            
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers).response { (response) in
            
                print(response.data ?? "default value")
            
               
             
            switch response.result {
            case .success(let resut):
                
               

                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }

                    do {
                        let jsonResponse = try JSON(data: response.data ?? Data())
                        completion(true, jsonResponse, nil)
                    }
                    catch _ {
                        completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
                    

                }
            case .failure(let error):
                completion(false, JSON(), error)

                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        }
        
    }
    
    func updateOcrInfo(_ parameters:[String:Any], completion: @escaping (_ success: Bool, _ jsonResponse: JSON, _ error: Error?) -> ()) {
        
        SVProgressHUD.show()
       SVProgressHUD.setDefaultMaskType(.clear)
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(EKYCTOKEN)",
            "subscription": SUBSCRIPTION,
            "content-type": "application/json"
        ]
        
        let url = URL(string: eKYCApiConst.EKYCBASEURL+"ocrinfo")
        AF.request(url!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { (response) in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if (response.error != nil) {
                completion(false, JSON(), response.error)
            } else {
                do {
                    let jsonResponse = try JSON(data: response.data!)
                    completion(true, jsonResponse, nil)
                }
                catch _ {
                    completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
                }
            }
        }
        
    }
    
    func getLivenessDetection(_ parameters:[String:Any], completion: @escaping (_ success: Bool, _ jsonResponse: JSON, _ error: Error?) -> ()) {
        
       SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(EKYCTOKEN)",
            "subscription": SUBSCRIPTION,
            "content-type": "application/json"
        ]
        
        let url = URL(string: eKYCApiConst.EKYCBASEURL+"liveness")
        AF.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { (response) in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if (response.error != nil) {
                completion(false, JSON(), response.error)
            } else {
                do {
                    let jsonResponse = try JSON(data: response.data!)
                    completion(true, jsonResponse, nil)
                }
                catch _ {
                    completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
                }
            }
        }
    }
    
    func getFaceCompare(_ parameters:[String:Any], completion: @escaping (_ success: Bool, _ jsonResponse: JSON, _ error: Error?) -> ()) {
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(EKYCTOKEN)",
            "subscription": SUBSCRIPTION,
            "content-type": "application/json"
        ]
        
        let url = URL(string: eKYCApiConst.EKYCBASEURL+"facecompare")
        AF.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { (response) in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if (response.error != nil) {
                completion(false, JSON(), response.error)
            } else {
                do {
                    let jsonResponse = try JSON(data: response.data!)
                    completion(true, jsonResponse, nil)
                }
                catch _ {
                    completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
                }
            }
        }
    }
    
    func getSummaryDetails(_ parameters:[String:Any], completion: @escaping (_ success: Bool, _ jsonResponse: JSON, _ error: Error?) -> ()) {
//
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(EKYCTOKEN)",
            "subscription": SUBSCRIPTION,
            "content-type": "application/json"
        ]
        
        let url = URL(string: eKYCApiConst.EKYCBASEURL+"summarydetails?referenceId=\(REFERENCEID)")
        
        AF.request(url!, method: .get, parameters: parameters, encoding: URLEncoding(), headers: headers).response { (response) in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }

            if (response.error != nil) {
                completion(false, JSON(), response.error)
            } else {
                do {
                    let jsonResponse = try JSON(data: response.data!)
                    completion(true, jsonResponse, nil)
                }
                catch _ {
                    completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
                }
            }
        }
    }
    
    func submitKYC(_ parameters:[String:Any], completion: @escaping(_ success:Bool, _ jsonResponse: JSON, _ error: Error?) -> ()){
        SVProgressHUD.show()
       SVProgressHUD.setDefaultMaskType(.clear)
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(EKYCTOKEN)",
            "subscription": SUBSCRIPTION,
            "content-type": "application/json"
        ]
        
        let url = URL(string: eKYCApiConst.EKYCBASEURL+"/ekyc/submit")
        AF.request(url!, method: .post, parameters: parameters, encoding: URLEncoding(), headers: headers).response { (response) in

            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }

            if (response.error != nil) {
                completion(false, JSON(), response.error)
            } else {
//                do {
//                    let jsonResponse = (response.data != nil) as Bool
//
//                    if(jsonResponse){
                    completion(true, JSON(), nil)
//                    }
//                    else{
//                      completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Submission fail"]))
//                    }
//                }
//                catch _ {
//                    completion(false, JSON(), NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid Json"]))
//                }
            }
        }
    }
    
}

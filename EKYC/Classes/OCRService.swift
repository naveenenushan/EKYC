//
//  OCRService.swift
//  ekyc
//
//  Created by Mac  on 29/08/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AAILivenessSDK
import IQKeyboardManager
import SVProgressHUD

public protocol eKYCResultCallback {
    func onKYCSuccess(kycResult: KYCResult)
    func onKYCError(kycResult: KYCError)
}

public class KoKuKYCSDK {
    
    public var delegate: eKYCResultCallback? = nil
    
    var livenessId = ""
    var livenessSnapshotId = ""
    var ocrAttachmentId = ""
    
    public init(client_id: String, secret: String, subscription: String, countryCode isoCountryCode: String, callBackUrl url: String, referenceID referenceId: String, enableResultScreen EnableResultScreen: Bool, allowImageUploadfromGallery: Bool, environment: EkycEnvironment, verificationImageSingleSide: Bool = false, ignoreOCRScreen: Bool = false){
        CLIENTID = client_id
        SECRET = secret
        SUBSCRIPTION = subscription
        COUNTRYCODE = isoCountryCode
        CALLBACKURL = url
        REFERENCEID = referenceId
        ENABLERESULTSCREEN = EnableResultScreen
        ALLOWIMAGEUPLOADFROMGALLERY = allowImageUploadfromGallery
        ONLYFRONTSIDE = verificationImageSingleSide
        IGNOREOCRSCREEN = ignoreOCRScreen
        
        setEnvironment(environment: environment)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    public func setTitleTextColor(color: UIColor){
        TITLETEXTCOLOR = color
    }
    
    public func setTitleBackgroundColor(color: UIColor){
        TITLEBACKGROUNDCOLOR = color
    }
    
    public func setBackgroundColor(color: UIColor){
        BACKGROUNDCOLOR = color
    }
    
    public func setButtonColor(color: UIColor){
        BUTTONCOLOR = color
    }
    
//    public func setNavigationBackIcon(image: UIImage){
//
//    }
    
    func setEnvironment(environment: EkycEnvironment){
        switch environment {
        case .DEVELOPMENT:
            eKYCApiConst.BASEURL = "https://kokuglobalauthdev.azurewebsites.net/"
            eKYCApiConst.EKYCBASEURL = "https://kokuekycapidev.azurewebsites.net/api/v1.0/ekyc/"
        case .STAGING:
            eKYCApiConst.BASEURL = "https://kokuglobalauthdev.azurewebsites.net/"
            eKYCApiConst.EKYCBASEURL = "https://kokuekycapidev.azurewebsites.net/api/v1.0/ekyc/"
        case .PRODUCTION:
            eKYCApiConst.BASEURL = "https://auth.credid.io/"
            eKYCApiConst.EKYCBASEURL = "https://hub.credid.io/ekycapi/v1.0/ekyc/"
        case .RESTRICTED_DEVELOPMENT:
            eKYCApiConst.BASEURL = "https://kokuglobalauthdev.azurewebsites.net/"
            eKYCApiConst.EKYCBASEURL = "https://kokuekycapidev.azurewebsites.net/api/v1.0/ekyc/"
        case .RESTRICTED_STAGING:
            eKYCApiConst.BASEURL = "https://kokuglobalauthdev.azurewebsites.net/"
            eKYCApiConst.EKYCBASEURL = "https://kokuekycapidev.azurewebsites.net/api/v1.0/ekyc/"
        case .RESTRICTED_PRODUCTION:
            eKYCApiConst.BASEURL = "https://kokuglobalauthprod.azurewebsites.net/"
            eKYCApiConst.EKYCBASEURL = "https://hub.koku.io/ekycapi/v1.0/ekyc/"
        }
        
    }
    
    public func startEkyc(){
        
        let parameters = ["grant_type":eKYCApiConst.GRANT_TYPE,
                          "client_id":CLIENTID,
                          "client_secret":SECRET,
                          "scope":eKYCApiConst.SCOPE]
        
        NetworkManager.shared().getAccessToken(parameters) { (status, jsonResponse, error) in
            
            if (error != nil) {
                self.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
            } else {
                if jsonResponse["error"].stringValue != ""{
                    self.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["error"].stringValue))
                }else{
                    EKYCTOKEN = jsonResponse["access_token"].stringValue
                    self.getLivenessCredentials()
                }
            }
            
        }
        
    }
    
    func getLivenessCredentials() {
        
        NetworkManager.shared().getLivenessCredentials(["":""]) { (status, jsonResponse, error) in
            
            if (error != nil) {
                self.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
            } else {
                if jsonResponse["code"].stringValue != ""{
                    self.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["code"].stringValue))
                }else{
                    
                    DispatchQueue.main.async {
                        AAILivenessSDK.initWithAccessKey(jsonResponse["accessKey"].stringValue, secretKey: jsonResponse["secretKey"].stringValue, market: AAILivenessMarketIndonesia)
                        
                        let myBundle = Bundle(for: IdentityVerificationViewController.self)
                        let myStoryboard = UIStoryboard(name: "Storyboard", bundle: myBundle)
                        let IdentityVCNav = myStoryboard.instantiateViewController(withIdentifier: "IdentityVC") as! UINavigationController
                        
                        let IdentityVC = IdentityVCNav.viewControllers[0] as! IdentityVerificationViewController
                        IdentityVC.manager = self
                        
                        UIApplication.shared.keyWindow?.rootViewController?.present(IdentityVCNav, animated: true, completion: nil)
                    }
                }
            }
            
        }
        
    }
    
}

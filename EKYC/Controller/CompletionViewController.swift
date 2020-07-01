//
//  CompletionViewController.swift
//  ekyc
//
//  Created by Mac  on 19/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompletionViewController: MainViewController{

    var manager: KoKuKYCSDK!
    
    var ocrResponse: OCRResponse!
    var livenessResponse: LivenessResponse!
    var faceComparisonResponse: FaceComparisonResponse!
    @IBOutlet weak var completionView: UIView!
    @IBOutlet weak var completeBtn: UIButton!
    var isFail: Bool = false
    @IBOutlet weak var completeMessage: UILabel!
    @IBOutlet weak var completeViewImage: UIImageView!
    @IBOutlet weak var completeActionIcon: UIImageView!
    @IBOutlet weak var faceMatchNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        completionView.layer.cornerRadius = 5
        completionView.clipsToBounds = true
        completeBtn.layer.cornerRadius = 5
        
        completeBtn.backgroundColor = BUTTONCOLOR
        
        updateLableText()
        
        if(isFail){
           notSuccessful()
            return
        }
        
        self.getSummaryDetails()
        
        // Do any additional setup after loading the view.
    }
    
    func updateLableText(){
        self.faceMatchNavigationItem.title = NSLocalizedString("faceMatch", bundle: getBundle()!, comment: "")
        
        completeMessage.text = NSLocalizedString("submitSuccessMsg", bundle: getBundle()!, comment: "")
        completeBtn.setTitle(NSLocalizedString("complete", bundle: getBundle()!, comment: ""), for: .normal)
    }
    
    func getSummaryDetails(){
        NetworkManager.shared().getSummaryDetails(["":""]) { (status, jsonResponse, error) in
            
            if (error != nil) {
                self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
                self.notSuccessful()
            } else {
                if jsonResponse["code"].stringValue != ""{
                    self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["code"].stringValue))
                    self.notSuccessful()
                }else{
                    
                    let ocrData = jsonResponse["ocrInfo"]
                    let livenessInfo = jsonResponse["livenessInfo"]
                    let livenessInfoSnapShot = livenessInfo["snapshot"]
                    
                    self.ocrResponse = OCRResponse(ocrAttachmentId: OCRATTACHMENTID, ocrInfo: OcrInfo(addressLine: ocrData["addressLine"].stringValue, bloodType: ocrData["bloodType"].stringValue, city: ocrData["city"].stringValue, dateOfBirth: ocrData["dateOfBirth"].stringValue, district: ocrData["district"].stringValue, expiryDate: ocrData["expiryDate"].stringValue, gender: ocrData["gender"].stringValue, idNumber: ocrData["idNumber"].stringValue, documentType: DOCUMENTTYPE, maritalStatus: ocrData["maritalStatus"].stringValue, name: ocrData["name"].stringValue, nationality: ocrData["nationality"].stringValue, occupation: ocrData["occupation"].stringValue, placeOfBirth: ocrData["placeOfBirth"].stringValue, province: ocrData["province"].stringValue, religion: ocrData["religion"].stringValue, village: ocrData["village"].stringValue, zipCode: ocrData["zipCode"].stringValue, race: ocrData["race"].stringValue, snapShot: Snapshot(id: ocrData["name"].stringValue, link: ocrData["id"].stringValue, name: ocrData["link"].stringValue)), ocrInfoId: OCRINFOID, referenceId: REFERENCEID)
                    
                    self.livenessResponse = LivenessResponse(livenessId: LIVENESSID, livenessScore: livenessInfo["livenessScore"].doubleValue, livenessSnapshotId: LIVENESSSNAPSHOTID, referenceId: REFERENCEID, snapShot: Snapshot(id: livenessInfoSnapShot["id"].stringValue, link: livenessInfoSnapShot["link"].stringValue, name: livenessInfoSnapShot["name"].stringValue))
                }
            }
        }
        
    }
    
    func submitEKYC(){
        var parameter = JSON().dictionaryObject
        
        parameter!["referenceId"] = REFERENCEID
        parameter!["notifyUrl"] = CALLBACKURL
        
        NetworkManager.shared().submitKYC(parameter!) { (status, jsonResponse, error) in
             if (error != nil) {
                           self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
                       } else {
                if(status){
                    self.manager.delegate?.onKYCSuccess(kycResult: KYCResult(ocrResponse: self.ocrResponse, livenessResponse: self.livenessResponse, faceComparisonResponse: self.faceComparisonResponse))
                            self.navigationController?.dismiss(animated: true, completion: nil)
                }
                       }
        }
    }
    
    func notSuccessful(){
        isFail = true
        completeMessage.text = NSLocalizedString("submitFailMsg", bundle: getBundle()!, comment: "")
        completeViewImage.image = UIImage(named: "img_error", in: getBundle(), compatibleWith: nil)
        completeActionIcon.image = UIImage(named: "ic_action_refresh", in: getBundle(), compatibleWith: nil)
        completeBtn.setTitle(NSLocalizedString("resubmit", bundle: getBundle()!, comment: ""), for: .normal)
    }
    
    @IBAction func completionAct(_ sender: Any) {
        if(isFail){
//            manager.delegate?.onKYCError(kycResult: KYCError(error: .UNKNOWN_ERROR, message: ""))
//            self.navigationController?.dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController(animated: true)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: OCRViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
            return
        }
        
        if(!ENABLERESULTSCREEN){
            submitEKYC()
            return
        }
        
        let myBundle = Bundle(for: VerificationRefultViewController.self)
        let myStoryboard = UIStoryboard(name: "Storyboard", bundle: myBundle)
        let vc = myStoryboard.instantiateViewController(withIdentifier: "verificationResultVC") as! VerificationRefultViewController
        vc.manager = self.manager
        vc.faceComparisonResponse = self.faceComparisonResponse
        vc.ocrResponse = self.ocrResponse
        vc.livenessResponse = self.livenessResponse
        self.navigationController?.pushViewController(vc, animated: true)

    }
    

}

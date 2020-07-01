//
//  UploadVerificationViewController.swift
//  ekyc
//
//  Created by Chamara on 1/7/20.
//  Copyright © 2020 Think. All rights reserved.
//

import UIKit
import AAILivenessSDK
class UploadVerificationViewController: MainViewController{
    @IBOutlet weak var FrontSideView: UIView!
    @IBOutlet weak var backSideView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var UploadVerificationView: UIView!
    @IBOutlet weak var continoueBtn: UIButton!
    @IBOutlet weak var frontImageBackgroundView: UIView!
    @IBOutlet weak var backImageBackgroundView: UIView!
    var imagePicker: ImagePicker!
    var manager: KoKuKYCSDK!
    var currentBtnTag: Int = 0
    var ocrFrontImage: UIImage?
    var ocrBackImage: UIImage?
    var livenessSnapshotId = ""
    var faceComparisonResponse: FaceComparisonResponse!
    var isFailed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FrontSideView.layer.cornerRadius = 5
        backSideView.layer.cornerRadius = 5
        UploadVerificationView.layer.cornerRadius = 5
        continoueBtn.layer.cornerRadius = 5
        frontImageBackgroundView.layer.cornerRadius = 5
        backImageBackgroundView.layer.cornerRadius = 5
        
         self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    @IBAction func frontImageBtnClicked(_ sender: UIButton) {
        currentBtnTag = sender.tag
        
        self.imagePicker.present(from: sender)
    }

    @IBAction func backImageBtnClicked(_ sender: UIButton) {
        currentBtnTag = sender.tag
        
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        self.ocrInfoFront()
    }
    
    func ocrInfoFront() {
            NetworkManager.shared().uploadOcrImage(ocrFrontImage!) { (status, jsonResponse, error) in
                
                if (error != nil) {
                    self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
                } else {

                    OCRATTACHMENTID = jsonResponse["ocrAttachmentId"].stringValue
                    
                    if jsonResponse["code"].stringValue != ""{
    //                    self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["code"].stringValue))
                        if(jsonResponse["code"].stringValue == "INVALID_ID"){
                            CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""),message: NSLocalizedString("incorrectIdPhoto", bundle: self.getBundle()!, comment: ""))
                                .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                                    })
                                .build().show(animated: true)
                            return
                        }
                        else if(jsonResponse["code"].stringValue == "IMAGE_PROCESSING_FAILED"){
                            CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""),message: NSLocalizedString("detactionFail", bundle: self.getBundle()!, comment: ""))
                                .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                                    })
                                .build().show(animated: true)
                            return
                        }
                        else{
                            CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""),message: jsonResponse["message"].stringValue)
                                                      .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                                                          })
                                                      .build().show(animated: true)
                                                  return
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.ocrInfoBack()
                        }
                    }
                    
                }
                
            }
            
        }
    
    func ocrInfoBack(){
        NetworkManager.shared().uploadOcrImage(ocrBackImage!, side: "BACK") { (status, jsonResponse, error) in
                       
                       if (error != nil) {
                           self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
                       } else {

                           OCRATTACHMENTID = jsonResponse["ocrAttachmentId"].stringValue
                           
                           if jsonResponse["code"].stringValue != ""{
           //                    self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["code"].stringValue))
                               if(jsonResponse["code"].stringValue == "INVALID_ID"){
                                   CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""),message: NSLocalizedString("incorrectIdPhoto", bundle: self.getBundle()!, comment: ""))
                                       .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                                           })
                                       .build().show(animated: true)
                                   return
                               }
                               else if(jsonResponse["code"].stringValue == "IMAGE_PROCESSING_FAILED"){
                                   CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""),message: NSLocalizedString("detactionFail", bundle: self.getBundle()!, comment: ""))
                                       .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                                           })
                                       .build().show(animated: true)
                                   return
                               }
                               else{
                                   CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""),message: jsonResponse["message"].stringValue)
                                                             .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                                                                 })
                                                             .build().show(animated: true)
                                                         return
                               }
                           }else{
                               
                               DispatchQueue.main.async {

                                   let myBundle = Bundle(for: OCRViewController.self)
                                   let myStoryboard = UIStoryboard(name: "Storyboard", bundle: myBundle)
                                   let vc = myStoryboard.instantiateViewController(withIdentifier: "OCRVC") as! OCRViewController
                                   vc.ocrJsonResponse = jsonResponse
                                   
                                   OCRINFOID = jsonResponse["ocrInfoId"].stringValue
                                   
                                   vc.manager = self.manager
                                   
                                   let ocrData = jsonResponse["ocrInfo"]
                                   
                                   if(DOCUMENTTYPE == "ID" && COUNTRYCODE == "ID"){
                                       var ocrGender = ocrData["gender"].stringValue.lowercased()
                                       var gender: String?
                                       
                                       if(ocrGender == "male" || ocrGender == "laki-laki" || ocrGender == "m"){
                                           gender = "M"
                                       }
                                       else{
                                           gender = "F"
                                       }
                                       
                                       if(!Utils().isValidIdNumberWithDOB(idNumber: ocrData["idNumber"].stringValue, gender: gender!, dob: ocrData["dateOfBirth"].stringValue)){
                                               CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""), message: "Invalid id number")
                                                          .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                                                          })
                                                          .build().show(animated: true)
                                               
                                               return
                                       }
                                   }
                                   
                                   vc.ocrInfo = OcrInfo(addressLine: ocrData["addressLine"].stringValue, bloodType: ocrData["bloodType"].stringValue, city: ocrData["city"].stringValue, dateOfBirth: ocrData["dateOfBirth"].stringValue, district: ocrData["district"].stringValue, expiryDate: ocrData["expiryDate"].stringValue, gender: ocrData["gender"].stringValue, idNumber: ocrData["idNumber"].stringValue, documentType: DOCUMENTTYPE, maritalStatus: ocrData["maritalStatus"].stringValue, name: ocrData["name"].stringValue, nationality: ocrData["nationality"].stringValue, occupation: ocrData["occupation"].stringValue, placeOfBirth: ocrData["placeOfBirth"].stringValue, province: ocrData["province"].stringValue, religion: ocrData["religion"].stringValue, village: ocrData["village"].stringValue, zipCode: ocrData["zipCode"].stringValue, race: ocrData["race"].stringValue, snapShot: nil)
                                   
                                if(IGNOREOCRSCREEN){
                                        self.startLivenessDetection()
                                }
                                else{
                                   self.navigationController?.pushViewController(vc, animated: true)
                                }
                               }
                           }
                           
                       }
                       
                   }
                   
    }
    
    func startLivenessDetection(){
            isFailed = false
            
            let vc = AAILivenessViewController()
            vc.delegate = self
            vc.title = NSLocalizedString("faceMatch", bundle: getBundle()!, comment: "")
    //        vc.setNeedsStatusBarAppearanceUpdate()
            vc.navigationItem.leftBarButtonItem = createNavigationButton()
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        // MARK:- configure Navigation bar
        func createNavigationButton() -> UIBarButtonItem{
                   let bundel = getBundle()
           
             let button: UIButton = UIButton (type: UIButton.ButtonType.custom)
             button.setImage(UIImage(named: "back-inverse", in: bundel, compatibleWith: nil), for: .normal)
             button.addTarget(self, action: #selector(navigationBtnPressed(btn:)), for: UIControl.Event.touchUpInside)
             button.frame = CGRect(x:0, y:0, width:30, height:30)
             let barButton = UIBarButtonItem(customView: button)
             
             return barButton
         }
        
          // MARK:- Navigation back button action
        @objc func navigationBtnPressed(btn: UIButton) {
              DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("exit", bundle: self.getBundle()!, comment: ""), message: NSLocalizedString("exitMsg", bundle: self.getBundle()!, comment: ""), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("no", bundle: self.getBundle()!, comment: ""), style: UIAlertAction.Style.default, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("yes", bundle: self.getBundle()!, comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
    //                for controller in self.navigationController!.viewControllers as Array {
    //                    if controller.isKind(of: IdentityVerificationViewController.self) {
    //                        self.navigationController!.popToViewController(controller, animated: true)
    //                        break
    //                    }
    //                }
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
              }
          }
    
    func getLivenessDetection() {
        
        let parameters = [
            "referenceId": REFERENCEID,
            "livenessId": LIVENESSID
            ] as [String : Any]
        
        NetworkManager.shared().getLivenessDetection(parameters) { (status, jsonResponse, error) in
            
            if (error != nil) {
                self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
                
                self.getSummaryDetailsFail()
            } else {
                if jsonResponse["code"].stringValue != ""{
                    self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["code"].stringValue))
                    
                    self.getSummaryDetailsFail()
                }else{
                    LIVENESSSNAPSHOTID = jsonResponse["livenessSnapshotId"].stringValue
                    self.getFaceCompare()
                }
            }
            
        }
        
    }
    
    func getFaceCompare(){
        
        let parameters = [
            "referenceId": REFERENCEID,
            "ocrAttachmentId": OCRATTACHMENTID,
            "livenessSnapshotId": LIVENESSSNAPSHOTID
            ] as [String : Any]
        
        NetworkManager.shared().getFaceCompare(parameters) { (status, jsonResponse, error) in
            
            if (error != nil) {
                self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
                
                self.getSummaryDetailsFail()
            } else {
                if jsonResponse["code"].stringValue != ""{
                    self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["code"].stringValue))
                    
                    self.getSummaryDetailsFail()
                }else{
                    self.faceComparisonResponse = FaceComparisonResponse(faceCompareInfo: FaceCompareInfo(similarity: jsonResponse["faceCompareInfo"]["similarity"].doubleValue), referenceId: jsonResponse["referenceId"].stringValue)
                    DispatchQueue.main.async {
                        self.getSummaryDetailsSuccess()
                    }
                }
            }
            
        }
        
    }
    
    func getSummaryDetailsSuccess(){
        
        let myBundle = Bundle(for: CompletionViewController.self)
        let myStoryboard = UIStoryboard(name: "Storyboard", bundle: myBundle)
        let vc = myStoryboard.instantiateViewController(withIdentifier: "CompletionVC") as! CompletionViewController
        vc.manager = self.manager
        vc.faceComparisonResponse = self.faceComparisonResponse
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getSummaryDetailsFail(){
        isFailed = true
        
        let myBundle = Bundle(for: CompletionViewController.self)
        let myStoryboard = UIStoryboard(name: "Storyboard", bundle: myBundle)
        let vc = myStoryboard.instantiateViewController(withIdentifier: "CompletionVC") as! CompletionViewController
        vc.manager = self.manager
        vc.faceComparisonResponse = nil
        vc.isFail = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UploadVerificationViewController: ImagePickerDelegate{
    
    func didSelect(image: UIImage?) {
        if let ocrImage = image{
            if(currentBtnTag == 1){
                self.frontImageView.image = ocrImage
                
                self.ocrFrontImage = ocrImage
                
                self.frontImageBackgroundView.layer.borderWidth = 1
                self.frontImageBackgroundView.layer.borderColor = UIColor.blue.cgColor
                
                if(ocrBackImage != nil){
                    continoueBtn.isUserInteractionEnabled = true
                    continoueBtn.backgroundColor = BUTTONCOLOR
                }
            }
            else{
                self.backImageView.image = ocrImage
                
                self.ocrBackImage = ocrImage
                
                self.backImageBackgroundView.layer.borderWidth = 1
                self.backImageBackgroundView.layer.borderColor = UIColor.blue.cgColor
                
                if(ocrFrontImage != nil){
                    continoueBtn.isUserInteractionEnabled = true
                    continoueBtn.backgroundColor = BUTTONCOLOR
                }
            }
                }
    }
}

extension UploadVerificationViewController: livenessCallback{
    
      func getLivenessId(_ livenessID: String) {
           LIVENESSID = livenessID
                 self.getLivenessDetection()
       }
       
       func getLivenessImage(_ livenessImage: UIImage) {
           LIVENESSIMAGE = livenessImage
       }
       
       func livenessError() {
           self.manager.delegate?.onKYCError(kycResult: KYCError(error: KycError.LIVENESS_FAILED))
           
            let alert = UIAlertController(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""), message: NSLocalizedString("livenessDetactionFail", bundle: self.getBundle()!, comment: ""), preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                           self.getSummaryDetailsFail()
                       }))
                       self.present(alert, animated: true, completion: nil)
       }
       
       func onBackBtnAction() {
           let alert = UIAlertController(title: NSLocalizedString("exit", bundle: self.getBundle()!, comment: ""), message: NSLocalizedString("exitMsg", bundle: self.getBundle()!, comment: ""), preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: NSLocalizedString("no", bundle: self.getBundle()!, comment: ""), style: UIAlertAction.Style.default, handler: nil))
           alert.addAction(UIAlertAction(title: NSLocalizedString("yes", bundle: self.getBundle()!, comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
           }))
           present(alert, animated: true, completion: nil)
       }
}

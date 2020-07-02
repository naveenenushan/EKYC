//
//  OCRViewController.swift
//  ekyc
//
//  Created by Mac  on 18/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftyJSON
import AAILivenessSDK
//import ekyc
import SVProgressHUD

class OCRViewController: MainViewController{
     
    @IBOutlet weak var addressTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var bloodTypeTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var cityTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var dobTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var districtTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var genderTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var expiryDateTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var idNumberTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var martialStatusTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var nameTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var nationlityTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var occupationTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var placeOfBirthTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var provinceTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var religionTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var villageTextBox: JVFloatLabeledTextField!
    @IBOutlet weak var zipCodeTextBox: JVFloatLabeledTextField!
    
    var ocrInfo: OcrInfo!
    var ocrJsonResponse = JSON()
    
    var livenessSnapshotId = ""
    
    var manager: KoKuKYCSDK!
    
    var faceComparisonResponse: FaceComparisonResponse!
    @IBOutlet weak var ocrView: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    let datePicker = UIDatePicker()
    var isFailed = false
    
    @IBOutlet weak var identityVerificationNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFields = [addressTextBox,bloodTypeTextBox,cityTextBox,dobTextBox,districtTextBox,genderTextBox,expiryDateTextBox,idNumberTextBox,martialStatusTextBox,nameTextBox,nationlityTextBox,occupationTextBox,placeOfBirthTextBox,provinceTextBox,religionTextBox,villageTextBox,zipCodeTextBox]
        
        self.updateTextFieldColor(textFields as! [JVFloatLabeledTextField])
        
        self.updateLableText()
        
        self.updateOcrFields()
        
        ocrView.layer.cornerRadius = 5
        ocrView.clipsToBounds = true
        proceedBtn.layer.cornerRadius = 5
        
        nameTextBox.delegate = self
        addressTextBox.delegate = self
        bloodTypeTextBox.delegate = self
        cityTextBox.delegate = self
        dobTextBox.delegate = self
        districtTextBox.delegate = self
        genderTextBox.delegate = self
        expiryDateTextBox.delegate = self
        idNumberTextBox.delegate = self
        martialStatusTextBox.delegate = self
        nationlityTextBox.delegate = self
        occupationTextBox.delegate = self
        placeOfBirthTextBox.delegate = self
        provinceTextBox.delegate = self
        religionTextBox.delegate = self
        villageTextBox.delegate = self
        zipCodeTextBox.delegate = self
        
        showDatePicker(textField: dobTextBox)
        
        proceedBtn.backgroundColor = BUTTONCOLOR
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if(isFailed){
//            startLivenessDetection()
//        }
//        startLivenessDetection()
    }
    
    override func backButtonPressed(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateOcrFields() {
        
        if(ocrInfo != nil){
        addressTextBox.text = ocrInfo.addressLine
        bloodTypeTextBox.text = ocrInfo.bloodType
        cityTextBox.text = ocrInfo.city
        dobTextBox.text = ocrInfo.dateOfBirth
        districtTextBox.text = ocrInfo.district
        genderTextBox.text = ocrInfo.gender
        expiryDateTextBox.text = ocrInfo.expiryDate
        idNumberTextBox.text = ocrInfo.idNumber
        martialStatusTextBox.text = ocrInfo.maritalStatus
        nameTextBox.text = ocrInfo.name
        nationlityTextBox.text = ocrInfo.nationality
        occupationTextBox.text = ocrInfo.occupation
        placeOfBirthTextBox.text = ocrInfo.placeOfBirth
        provinceTextBox.text = ocrInfo.province
        religionTextBox.text = ocrInfo.religion
        villageTextBox.text = ocrInfo.village
        zipCodeTextBox.text = ocrInfo.zipCode
            
            if(DOCUMENTTYPE == "ID"){
                idNumberTextBox.placeholder = NSLocalizedString("idNumber", bundle: getBundle()!, comment: "")
            }
            else if(DOCUMENTTYPE == "PASSPORT"){
                idNumberTextBox.placeholder = NSLocalizedString("passportNumber", bundle: getBundle()!, comment: "")
            }
            else{
                idNumberTextBox.placeholder = NSLocalizedString("licenseNumber", bundle: getBundle()!, comment: "")
            }
        }

    }
    
    func updateLableText(){
        nameTextBox.placeholder = NSLocalizedString("name", bundle: getBundle()!, comment: "")
        idNumberTextBox.placeholder = NSLocalizedString("idNumber", bundle: getBundle()!, comment: "")
        expiryDateTextBox.placeholder = NSLocalizedString("expiryDate", bundle: getBundle()!, comment: "")
        placeOfBirthTextBox.placeholder = NSLocalizedString("placeOfBirth", bundle: getBundle()!, comment: "")
        dobTextBox.placeholder = NSLocalizedString("dateOfBirth", bundle: getBundle()!, comment: "")
        genderTextBox.placeholder = NSLocalizedString("gender", bundle: getBundle()!, comment: "")
        addressTextBox.placeholder = NSLocalizedString("address", bundle: getBundle()!, comment: "")
        cityTextBox.placeholder = NSLocalizedString("city", bundle: getBundle()!, comment: "")
        provinceTextBox.placeholder = NSLocalizedString("province", bundle: getBundle()!, comment: "")
        districtTextBox.placeholder = NSLocalizedString("district", bundle: getBundle()!, comment: "")
        villageTextBox.placeholder = NSLocalizedString("village", bundle: getBundle()!, comment: "")
        zipCodeTextBox.placeholder = NSLocalizedString("zipCode", bundle: getBundle()!, comment: "")
        nationlityTextBox.placeholder = NSLocalizedString("nationality", bundle: getBundle()!, comment: "")
        occupationTextBox.placeholder = NSLocalizedString("occupation", bundle: getBundle()!, comment: "")
        martialStatusTextBox.placeholder = NSLocalizedString("maritalStatus", bundle: getBundle()!, comment: "")
        bloodTypeTextBox.placeholder = NSLocalizedString("bloodType", bundle: getBundle()!, comment: "")
        religionTextBox.placeholder = NSLocalizedString("religion", bundle: getBundle()!, comment: "")
        proceedBtn.setTitle(NSLocalizedString("proceed", bundle: getBundle()!, comment: ""), for: .normal)
        
        identityVerificationNavigationItem.title = NSLocalizedString("identityVerification", bundle: getBundle()!, comment: "")
    }

    @IBAction func proceedAct(_ sender: Any) {
        var emptyTextFields: [String] = []
        var textFieldFocous:[UITextField] = []
        
        if(nameTextBox.text?.isEmpty ?? true){
            emptyTextFields.append("'\(nameTextBox.placeholder!)'")
            textFieldFocous.append(nameTextBox)
        }
        
        if(idNumberTextBox.text?.isEmpty ?? true){
            emptyTextFields.append("'\(idNumberTextBox.placeholder!)'")
            textFieldFocous.append(idNumberTextBox)
        }
        
        if(placeOfBirthTextBox.text?.isEmpty ?? true){
            emptyTextFields.append("'\(placeOfBirthTextBox.placeholder!)'")
            textFieldFocous.append(placeOfBirthTextBox)
        }
        
        if(dobTextBox.text?.isEmpty ?? true){
            emptyTextFields.append("'\(dobTextBox.placeholder!)'")
            textFieldFocous.append(dobTextBox)
        }
        
        if(addressTextBox.text?.isEmpty ?? true){
            emptyTextFields.append("'\(addressTextBox.placeholder!)'")
            textFieldFocous.append(addressTextBox)
        }
        
        if(!emptyTextFields.isEmpty){
            var connectEmptyTextField = ""
            
            textFieldFocous[0].becomeFirstResponder()
            
            for i in emptyTextFields{
                if(connectEmptyTextField == ""){
                connectEmptyTextField = i
                }
                else{
                    connectEmptyTextField += ", \(i)"
                }
            }
            
            let completeMessage = connectEmptyTextField + " are requied to complete your KYC information submission.Please fill in the correct information and proceed."
            
            CustomAlertView.CustomAlertViewBuilder(title: NSLocalizedString("error", bundle: self.getBundle()!, comment: ""),message: completeMessage)
                .setRightButton(text: NSLocalizedString("ok", bundle: self.getBundle()!, comment: ""), completionHandler: { () -> Void in
                })
                .build().show(animated: true)
            
            return
        }
        
        let idNumber = idNumberTextBox.text ?? ""
        let name = nameTextBox.text ?? ""
        let addressline = addressTextBox.text ?? ""
        let bloodType = bloodTypeTextBox.text ?? ""
        let city = cityTextBox.text ?? ""
        let dob = dobTextBox.text ?? ""
        let district = districtTextBox.text ?? ""
        let gender = genderTextBox.text ?? ""
        let expiryDate = expiryDateTextBox.text ?? ""
        let maritalStatus = martialStatusTextBox.text ?? ""
        let nationality = nationlityTextBox.text ?? ""
        let occupation = occupationTextBox.text ?? ""
        let placeOfBirth = placeOfBirthTextBox.text ?? ""
        let provice = provinceTextBox.text ?? ""
        let religion = religionTextBox.text ?? ""
        let village = villageTextBox.text ?? ""
        let zipCode = zipCodeTextBox.text ?? ""
        var race: String = ""
        
        if(ocrInfo != nil){
            race = ocrInfo.race
        }
        
        
        let parameters = ["addressLine": addressline,
                          "bloodType": bloodType,
                          "city": city,
                          "dateOfBirth" : dob,
                          "district" : district,
                          "gender" : gender,
                          "expiryDate" : expiryDate,
                          "idNumber": idNumber,
                          "maritalStatus": maritalStatus,
                          "name": name,
                          "nationality": nationality,
                          "occupation": occupation,
                          "placeOfBirth": placeOfBirth,
                          "province": provice,
                          "religion": religion,
                          "village": village,
                          "zipCode": zipCode,
                          "race": race]
        
        let fullParameters = ["referenceId": REFERENCEID,
                              "ocrInfoId": OCRINFOID,
                              "ocrInfo": parameters] as [String: Any]

        NetworkManager.shared().updateOcrInfo(fullParameters) { (status, jsonResponse, error) in
            
            if (error != nil) {
                self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(error!.localizedDescription))
            } else {
                if jsonResponse["code"].stringValue != ""{
                    self.manager.delegate?.onKYCError(kycResult: KycError.checkErrorCode(jsonResponse["code"].stringValue))
                }else{
                    DispatchQueue.main.async {
                        self.startLivenessDetection()
//                        LIVENESSID = "264e14b7-9330-48b8-8557-3dabbbceac95"
//                             self.getLivenessDetection()
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

extension OCRViewController: UITextFieldDelegate{
    func updateTextFieldColor(_ textFields: [JVFloatLabeledTextField]) {
        for textField in textFields{
            textField.floatingLabel.backgroundColor = UIColor.white
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == dobTextBox){
            showDatePicker(textField: dobTextBox)
        }
         return true
    }
}

extension OCRViewController: livenessCallback{
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
    
    func getLivenessImage(_ livenessImage: UIImage) {
        LIVENESSIMAGE = livenessImage
    }

    public func getLivenessId(_ livenessID: String) {
        LIVENESSID = livenessID
        self.getLivenessDetection()
    }

}

extension OCRViewController{
    
    //MARK: - Date Picker Functions
       func showDatePicker(textField: UITextField){
           
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
           toolbar.setItems([done], animated: false)
           textField.inputAccessoryView = toolbar
           textField.inputView = datePicker
        
                 datePicker.datePickerMode = .date
        
        if (ocrInfo != nil){
            if(ocrInfo.dateOfBirth != ""){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
            datePicker.date = formatter.date(from: ocrInfo.dateOfBirth) ?? Date()
        }
        }
        
           datePicker.maximumDate = Date()
       }
       
       @objc func donePressed() {
           self.view.endEditing(true)
           
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy"
        dobTextBox.text = formatter.string(from: datePicker.date)
       }
}

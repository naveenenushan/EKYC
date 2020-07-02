//
//  VerificationRefultViewController.swift
//  ekyc
//
//  Created by Chamara Thennakoon on 5/11/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftyJSON

class VerificationRefultViewController: MainViewController{
    var manager: KoKuKYCSDK!
    
    var ocrResponse: OCRResponse!
    var livenessResponse: LivenessResponse!
    var faceComparisonResponse: FaceComparisonResponse!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var matchingStattusLable: UILabel!
    @IBOutlet weak var presentageLable: UILabel!
    @IBOutlet weak var matchingprogressView: UIProgressView!
    @IBOutlet weak var nameTextfield: JVFloatLabeledTextField!
    @IBOutlet weak var idNumberTextField: JVFloatLabeledTextField!
    @IBOutlet weak var expiryDateTextField: JVFloatLabeledTextField!
    @IBOutlet weak var pobTextField: JVFloatLabeledTextField!
    @IBOutlet weak var dobTextField: JVFloatLabeledTextField!
    @IBOutlet weak var genderTextField: JVFloatLabeledTextField!
    @IBOutlet weak var addressTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cityTextField: JVFloatLabeledTextField!
    @IBOutlet weak var proviceTextField: JVFloatLabeledTextField!
    @IBOutlet weak var villageTextField: JVFloatLabeledTextField!
    @IBOutlet weak var districtTextField: JVFloatLabeledTextField!
    @IBOutlet weak var zipCodeTextField: JVFloatLabeledTextField!
    @IBOutlet weak var nationalityTextField: JVFloatLabeledTextField!
    @IBOutlet weak var occupationTextField: JVFloatLabeledTextField!
    @IBOutlet weak var martialStatustextField: JVFloatLabeledTextField!
    @IBOutlet weak var bloodTypeTextField: JVFloatLabeledTextField!
    @IBOutlet weak var religionTextField: JVFloatLabeledTextField!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var moreDetailArrow: UIImageView!
    @IBOutlet weak var faceMatchingView: UIView!
    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var detailStackViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var topViewConstaraint: NSLayoutConstraint!
    @IBOutlet weak var faceMatching: UILabel!
    @IBOutlet weak var personProbability: UILabel!
    @IBOutlet weak var moreDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFields = [nameTextfield, idNumberTextField, expiryDateTextField, pobTextField, dobTextField, genderTextField, addressTextField, cityTextField,proviceTextField, villageTextField, districtTextField, zipCodeTextField, nationalityTextField, occupationTextField, martialStatustextField, bloodTypeTextField, religionTextField]
        
        self.updateTextFieldColor(textFields as! [JVFloatLabeledTextField])

        updateLableText()
        
        matchingprogressView.layer.cornerRadius = 5
        matchingprogressView.layer.sublayers![1].cornerRadius = 5
        matchingprogressView.clipsToBounds = true
        matchingprogressView.subviews[1].clipsToBounds = true
        
        proceedBtn.layer.cornerRadius = 5
        faceMatchingView.layer.cornerRadius = 5
        faceMatchingView.clipsToBounds = true
        moreDetailsView.layer.cornerRadius = 5
        moreDetailsView.clipsToBounds = true
        
        detailStackViewHeightConstaint.constant = 0
        topViewConstaraint.constant = 665
        detailStackView.isHidden = true
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        
        proceedBtn.backgroundColor = BUTTONCOLOR
        
        fillDetails()

        // Do any additional setup after loading the view.
    }
    
    func fillDetails(){
        let ocrInfo = ocrResponse.ocrInfo
        nameLable.text = ocrInfo?.name
        matchingStattusLable.text = getFaceMatchingStatus()
        presentageLable.text = "\(Int(faceComparisonResponse.faceCompareInfo.similarity))%"
        nameTextfield.text = ocrInfo?.name
        idNumberTextField.text = ocrInfo?.idNumber
        expiryDateTextField.text = ocrInfo?.expiryDate
        pobTextField.text = ocrInfo?.placeOfBirth
        dobTextField.text = ocrInfo?.dateOfBirth
        genderTextField.text = ocrInfo?.gender
        addressTextField.text = ocrInfo?.addressLine
        cityTextField.text = ocrInfo?.city
        proviceTextField.text = ocrInfo?.province
        villageTextField.text = ocrInfo?.village
        districtTextField.text = ocrInfo?.district
        zipCodeTextField.text = ocrInfo?.zipCode
        nationalityTextField.text = ocrInfo?.nationality
        occupationTextField.text = ocrInfo?.occupation
        martialStatustextField.text = ocrInfo?.maritalStatus
        bloodTypeTextField.text = ocrInfo?.bloodType
        religionTextField.text = ocrInfo?.religion
        
        userImageView.image = LIVENESSIMAGE
        
        matchingprogressView.progress = Float(faceComparisonResponse.faceCompareInfo.similarity) / 100.0
    }
    
    func updateLableText(){
        nameTextfield.placeholder = NSLocalizedString("name", bundle: getBundle()!, comment: "")
        idNumberTextField.placeholder = NSLocalizedString("idNumber", bundle: getBundle()!, comment: "")
        expiryDateTextField.placeholder = NSLocalizedString("expiryDate", bundle: getBundle()!, comment: "")
        pobTextField.placeholder = NSLocalizedString("placeOfBirth", bundle: getBundle()!, comment: "")
        dobTextField.placeholder = NSLocalizedString("dateOfBirth", bundle: getBundle()!, comment: "")
        genderTextField.placeholder = NSLocalizedString("gender", bundle: getBundle()!, comment: "")
        addressTextField.placeholder = NSLocalizedString("address", bundle: getBundle()!, comment: "")
        cityTextField.placeholder = NSLocalizedString("city", bundle: getBundle()!, comment: "")
        proviceTextField.placeholder = NSLocalizedString("province", bundle: getBundle()!, comment: "")
        districtTextField.placeholder = NSLocalizedString("district", bundle: getBundle()!, comment: "")
        villageTextField.placeholder = NSLocalizedString("village", bundle: getBundle()!, comment: "")
        zipCodeTextField.placeholder = NSLocalizedString("zipCode", bundle: getBundle()!, comment: "")
        nationalityTextField.placeholder = NSLocalizedString("nationality", bundle: getBundle()!, comment: "")
        occupationTextField.placeholder = NSLocalizedString("occupation", bundle: getBundle()!, comment: "")
        martialStatustextField.placeholder = NSLocalizedString("maritalStatus", bundle: getBundle()!, comment: "")
        bloodTypeTextField.placeholder = NSLocalizedString("bloodType", bundle: getBundle()!, comment: "")
        religionTextField.placeholder = NSLocalizedString("religion", bundle: getBundle()!, comment: "")
        faceMatching.text = NSLocalizedString("faceMatching", bundle: getBundle()!, comment: "")
        personProbability.text = NSLocalizedString("personProbability", bundle: getBundle()!, comment: "")
        moreDetail.text = NSLocalizedString("moreDetail", bundle: getBundle()!, comment: "")
        
        proceedBtn.setTitle(NSLocalizedString("proceed", bundle: getBundle()!, comment: ""), for: .normal)
    }
    
    @IBAction func proceedBtnClicked(_ sender: UIButton) {
        submitEKYC()
    }
    
    
    @IBAction func moreDetailBtnClicked(_ sender: UIButton) {
        detailStackView.isHidden = false
        
        moreDetailArrow.image = UIImage(named: "arrow-down-sign-to-navigate", in: getBundle(), compatibleWith: nil)
        
        detailStackViewHeightConstaint.constant = 1360
        topViewConstaraint.constant = 2025

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
    
    func getFaceMatchingStatus() -> String{
        if(faceComparisonResponse.faceCompareInfo.similarity <= 70.0){
            return  "Low"
        }
        else if(faceComparisonResponse.faceCompareInfo.similarity > 70 && faceComparisonResponse.faceCompareInfo.similarity < 80){
            return "Medium"
        }
        else{
            return "High"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VerificationRefultViewController{
    
    func updateTextFieldColor(_ textFields: [JVFloatLabeledTextField]) {
        for textField in textFields{
            textField.floatingLabel.backgroundColor = UIColor.white
        }
    }
}

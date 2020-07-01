//
//  Util.swift
//  nConnect
//
//  Created by Mac  on 20/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit
import SwiftyJSON

public struct eKYCApiConst {
    static let GRANT_TYPE = "client_credentials"
    static let SCOPE = "ekycApi"
//    static let BASEURL = "https://kokudorpidserver.azurewebsites.net/"
      static var BASEURL = "https://kokuglobalauthdev.azurewebsites.net/"
//    static let EKYCBASEURL = "https://kokuekycapidorp.azurewebsites.net/api/v1.0/ekyc/"
    static var EKYCBASEURL = "https://kokuekycapidev.azurewebsites.net/api/v1.0/ekyc/"
}

class Utils{
    
    func displayError(title: String = "Error", message: String){
        CustomAlertView.CustomAlertViewBuilder(title: title,
                                               message: message)
            .setRightButton(text: "Ok", completionHandler: { () -> Void in
            })
            .build().show(animated: true)
    }
    
    func isValidIdNumberWithDOB(idNumber: String, gender: String, dob: String) -> Bool{
        if(dob != ""){
        let idFormatter = DateFormatter()
        idFormatter.dateFormat = "dd-MM-yyyy"
        let dobFormatter = DateFormatter()
        dobFormatter.dateFormat = "ddMMyy"
        
        var dobDate = idFormatter.date(from: dob)
        
            let dobRange = idNumber.index(idNumber.startIndex, offsetBy: 6)..<idNumber.index(idNumber.startIndex, offsetBy: 12)
            let idDob = idNumber[dobRange]
        var idDate = idDob.prefix(2)
        
            let monthRange = idDob.index(idDob.startIndex, offsetBy: 2)..<idDob.index(idDob.endIndex, offsetBy: -2)
            let idMonth = idDob[monthRange]
            let idYear = idDob.suffix(2)
        
        if(gender == "F"){
            let dateCorrection = Int(String(idDate))! - 40
            idDate = Substring(String(dateCorrection))
        }
        
            let extractedDate = dobFormatter.date(from: "\(idDate)\(idMonth)\(idYear)")
        
        return dob == idFormatter.string(from: extractedDate!)
        }
        
        return true
    }
}

var CLIENTID = ""
var SECRET = ""
var EKYCTOKEN = ""
var SUBSCRIPTION = ""
var COUNTRYCODE = ""
var CALLBACKURL = ""
var REFERENCEID = ""
var ENABLERESULTSCREEN = true
var DOCUMENTTYPE = "ID"
var OCRATTACHMENTID = ""
var LIVENESSID = ""
var LIVENESSSNAPSHOTID = ""
var OCRINFOID = ""
var TITLETEXTCOLOR: UIColor = UIColor.white
var TITLEBACKGROUNDCOLOR: UIColor = UIColor(red: 97/255, green: 21/255, blue: 111/255, alpha: 1)
var BACKGROUNDCOLOR : UIColor = UIColor(red: 97/255, green: 21/255, blue: 111/255, alpha: 1)
var LIVENESSIMAGE : UIImage = UIImage()
var ALLOWIMAGEUPLOADFROMGALLERY = true
var ONLYFRONTSIDE = false
var BUTTONCOLOR = UIColor(red: 254/255, green: 72/255, blue: 133/255, alpha: 1)
var IGNOREOCRSCREEN = false

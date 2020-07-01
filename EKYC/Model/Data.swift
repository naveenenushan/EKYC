//
//  Model.swift
//  ekyc
//
//  Created by Mac  on 19/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

public struct OcrInfo {
    public var addressLine = String()
    public var bloodType = String()
    public var city = String()
    public var dateOfBirth = String()
    public var district = String()
    public var expiryDate = String()
    public var gender = String()
    public var idNumber = String()
    public var documentType = String()// ID; PASSPORT; DRIVING_LICENSE
    public var maritalStatus = String()
    public var name = String()
    public var nationality = String()
    public var occupation = String()
    public var placeOfBirth = String()
    public var province = String()
    public var religion = String()
    public var village = String()
    public var zipCode = String()
    public var race = String()
    public var snapShot: Snapshot!
}

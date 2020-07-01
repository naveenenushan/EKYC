//
//  Model.swift
//  ekyc
//
//  Created by Mac  on 19/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

public struct FaceComparisonResponse{
    public var faceCompareInfo: FaceCompareInfo!
    public var referenceId = String()
}

public struct FaceCompareInfo{
    public var similarity = Double()
}

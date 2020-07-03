//
//  Model.swift
//  ekyc
//
//  Created by Mac  on 19/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

public struct KYCResult{

    // OCR Information for users' national id, refer below for more info.
    public var ocrResponse: OCRResponse?

    // FaceDetection Information including the livness score.
    public var livenessResponse: LivenessResponse?

    // FaceComparison Result with similarity score.
    public var faceComparisonResponse: FaceComparisonResponse?
}



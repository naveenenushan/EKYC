//
//  Model.swift
//  ekyc
//
//  Created by Mac  on 19/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

public struct KYCError {
    public var error: KycError
    public var message = String()
}

public enum KycError: Error {
    case OCR_FAILED
    case OCR_CANCELLED
    case LIVENESS_FAILED
    case LIVENESSS_CANCELLED
    case FACE_COMPARISON_FAILED
    case FACE_COMPARISON_CANCELLED
    case NETWORK_LOST
    case SERVER_ERROR
    case NO_CAMERA_PERMISSION
    case UNKNOWN_ERROR

    case INVALID_PARAMETER
    case INVALID_REQUEST
    case INVALID_REFERENCE_ID
    case LIVENESS_INFO_NOT_FOUND
    case INVALID_FILE_STREAM
    case INVALID_FILE_SIZE
    case IMAGE_PROCESSING_FAILED
    
    case INVALID_CLIENT

    static func checkErrorCode(_ errorCode: String) -> KYCError {
        switch errorCode {
        case "OCR_FAILED":
            return KYCError(error: .OCR_FAILED, message: "")
        case "OCR_CANCELLED":
            return KYCError(error: .OCR_CANCELLED, message: "")
        case "LIVENESS_FAILED":
            return KYCError(error: .LIVENESS_FAILED, message: "")
        case "LIVENESSS_CANCELLED":
            return KYCError(error: .LIVENESSS_CANCELLED, message: "")
        case "FACE_COMPARISON_FAILED":
            return KYCError(error: .FACE_COMPARISON_FAILED, message: "")
        case "FACE_COMPARISON_CANCELLED":
            return KYCError(error: .FACE_COMPARISON_CANCELLED, message: "")
        case "NO_CAMERA_PERMISSION":
            return KYCError(error: .NO_CAMERA_PERMISSION, message: "")
        case "LIVENESS_INFO_NOT_FOUND":
            return KYCError(error: .LIVENESS_INFO_NOT_FOUND, message: "")
        case "INVALID_PARAMETER":
            return KYCError(error: .INVALID_PARAMETER, message: "")
        case "INVALID_REQUEST":
            return KYCError(error: .INVALID_REQUEST, message: "")
        case "INVALID_REFERENCE_ID":
            return KYCError(error: .INVALID_REFERENCE_ID, message: "")
        case "LIVENESS_INFO_NOT_FOUND":
            return KYCError(error: .LIVENESS_INFO_NOT_FOUND, message: "")
        case "INVALID_FILE_STREAM":
            return KYCError(error: .INVALID_FILE_STREAM, message: "")
        case "INVALID_FILE_SIZE":
            return KYCError(error: .INVALID_FILE_SIZE, message: "")
        case "IMAGE_PROCESSING_FAILED":
            return KYCError(error: .IMAGE_PROCESSING_FAILED, message: "Image processing error")
        case "invalid_client":
            return KYCError(error: .INVALID_CLIENT, message: "")
        case "The Internet connection appears to be offline.":
            return KYCError(error: .NETWORK_LOST, message: "The Internet connection appears to be offline.")
        case "A server with the specified hostname could not be found.":
            return KYCError(error: .SERVER_ERROR, message: "A server with the specified hostname could not be found.")
        default:
            return KYCError(error: .UNKNOWN_ERROR, message: "")
        }
    }
}

//
//  Model.swift
//  ekyc
//
//  Created by Mac  on 19/09/19.
//  Copyright © 2019 Think. All rights reserved.
//

public struct LivenessResponse{
    public var livenessId = String()
    public var livenessScore = Double()
    public var livenessSnapshotId = String()
    public var referenceId = String()
    public var snapShot: Snapshot!
}

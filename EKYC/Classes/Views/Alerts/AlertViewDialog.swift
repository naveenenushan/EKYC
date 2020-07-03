//
//  DoubleButtonAlertView.swift
//  NTB-MobileBanking
//
//  Created by Sameera Jayaratna on 7/30/18.
//  Contact : +94 71 593 88 23
//  Copyright © 2018 Epic Lanka. All rights reserved.
//

import Foundation

import UIKit

class AlertViewDialog: UIView {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var btnRight: UIButton!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var viewSeperator: UIView!
    @IBOutlet var buttonSeperator: UIView!
    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageTopConstraint: NSLayoutConstraint!
    @IBOutlet var messageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var shortMessageLabel: UILabel!
}

//
//  CustomAlertView.swift
//  NTB-MobileBanking
//
//  Created by Sameera Jayaratna on 7/30/18.
//  Contact : +94 71 593 88 23
//  Copyright © 2018 Epic Lanka. All rights reserved.
//

import Foundation
import UIKit

class CustomAlertView: UIView, Modal {
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    typealias CompletionHandler = () -> Void
    
    private var leftButtoncompletion: CompletionHandler?
    private var rightButtoncompletion: CompletionHandler?
    private var autoDismissEnabled : Bool?
    
    convenience init(customAlertViewBuildr : CustomAlertViewBuilder){
        self.init(frame: UIScreen.main.bounds)
        
        self.leftButtoncompletion = customAlertViewBuildr.getLeftButtoncompletion()
        self.rightButtoncompletion = customAlertViewBuildr.getRightButtoncompletion()
        self.autoDismissEnabled = customAlertViewBuildr.isAutoDismissEnabled()
        
        initializeView(customAlertViewBuildr : customAlertViewBuildr)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeView(customAlertViewBuildr : CustomAlertViewBuilder){
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 1.0
        //backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        self.addSubview(backgroundView)
        bringSubviewToFront(backgroundView)
        
        //Creating the dialog view
        let inputView: UIView = initDoubleBtnView(customAlertViewBuildr: customAlertViewBuildr)
        self.addSubview(inputView)
    }
    
    //Right button click listener
    @objc func rigntButtonPressed(sender: UIButton){
        rightButtoncompletion!()
        if autoDismissEnabled! {
            dismiss(animated: true)
        }
    }
    
    //Left button click listener
    @objc func leftButtonPressed(sender: UIButton){
        leftButtoncompletion!()
        if autoDismissEnabled! {
            dismiss(animated: true)
        }
    }
    
    //Dismiss the dialog when background clicked
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
    //Builder class
    public class CustomAlertViewBuilder{
        private var title : String?
        private var message : String?
        private var shortMessage : String?
        private var okLeftButtonText : String?
        private var okRightButtonText : String?
        private var autoDismiss : Bool = true // Automatically dismissed the dialog when button is clicked
        private var attributeMessage: NSAttributedString?
        private var leftButtoncompletion: CompletionHandler?
        private var rightButtoncompletion: CompletionHandler?
        
        /**
         Default constructor
         */
        init(){}
        
        /**
         Title and Message is required when create an instance
         */
        init(title : String, message : String) {
            self.title = title
            self.message = message
        }
        
        init(title: String, attributeMessage: NSAttributedString){
            self.title = title
            self.attributeMessage = attributeMessage
        }
        init(title : String, message : String, shortMessage: String) {
            self.title = title
            self.message = message
            self.shortMessage = shortMessage
        }
        
        /**
         Set title
         - Parameter title: `String`
         - Returns: Currently use instance of `CustomAlertViewBuilder`
         */
        func setTitle(title: String) -> CustomAlertViewBuilder {
            self.title = title
            return self
        }
        
        /**
         Provides title of the dialog.
         - Returns: Title of the dialog
         */
        func getTitle() -> String? {
            return title
        }
        
        /**
         Set message
         - Parameter message: `String`
         - Returns: Currently use instance of `CustomAlertViewBuilder`
         */
        func setMessage(message: String) -> CustomAlertViewBuilder {
            self.message = message
            return self
        }
        
        func setAttributeMessage(attributeMessage: NSAttributedString) -> CustomAlertViewBuilder{
            self.attributeMessage = attributeMessage
            return self
        }
        
        /**
         Provides message body of the dialog.
         - Returns: Message body of the dialog
         */
        func getMessage() -> String? {
            return message
        }
        
        func getAttributeMessage() -> NSAttributedString? {
            return attributeMessage
        }
        
        /**
         Set short Message
         - Parameter message: `String`
         - Returns: Currently use instance of `CustomAlertViewBuilder`
         */
        func setShortMessage(shortMessage: String) -> CustomAlertViewBuilder {
            self.shortMessage = shortMessage
            return self
        }
        
        /**
         Provides short message of the dialog.
         - Returns: Short message of the dialog
         */
        func getShortMessage() -> String? {
            return shortMessage
        }
        
        /**
         Set automatically dismiss the dialog when click a button.
         If `true`, the dialog will be automatically dismissed when a button clicked.
         Else, can dismissed dialog manually.
         Default value is `true`.
         - Parameter autoDismiss: `true` or `false`
         - Returns: Currently use instance of `CustomAlertViewBuilder`
         */
        func setAutoDismiss(autoDismiss: Bool) -> CustomAlertViewBuilder {
            self.autoDismiss = autoDismiss
            return self
        }
        
        /**
         Provides title of the dialog.
         - Returns: If `true` retuns, the dialog will be automatically dismissed when a button clicked.
         Else, `false`.
         */
        func isAutoDismissEnabled() -> Bool {
            return autoDismiss
        }
        
        /**
         When two buttons are added. This will be the left side button.
         - Parameter text: Button text - `String`.
         - Parameter completionHandler: Button click call back listener - `CompletionHandler`.
         - Returns: Currently use instance of `CustomAlertViewBuilder`
         */
        func setLeftButton(text : String, completionHandler: @escaping CompletionHandler) -> CustomAlertViewBuilder{
            self.okLeftButtonText = text
            self.leftButtoncompletion = completionHandler
            return self
        }
        
        /**
         Provides left button text of the dialog.
         - Returns: `String`
         */
        func getLeftButtonText() -> String? {
            return okLeftButtonText
        }
        
        /**
         Provides left button click call back listener.
         - Returns: `CompletionHandler`
         */
        func getLeftButtoncompletion() -> CompletionHandler? {
            return leftButtoncompletion
        }
        
        /**
         When two buttons are added. This will be the right side button.
         - Parameter text: Button text - `String`.
         - Parameter completionHandler: Button click call back listener - `CompletionHandler`.
         - Returns: Currently use instance of `CustomAlertViewBuilder`
         */
        func setRightButton(text : String, completionHandler: @escaping CompletionHandler) -> CustomAlertViewBuilder{
            self.okRightButtonText = text
            self.rightButtoncompletion = completionHandler
            return self
        }
        
        /**
         Provides right button text of the dialog.
         - Returns: `String`
         */
        func getRightButtonText() -> String? {
            return okRightButtonText
        }
        
        /**
         Provides right button click call back listener.
         - Returns: `CompletionHandler`
         */
        func getRightButtoncompletion() -> CompletionHandler? {
            return rightButtoncompletion
        }
        
        /**
         Provides `CustomAlertView` instance.
         - Returns: `CustomAlertView`
         */
        func build() -> CustomAlertView {
            return CustomAlertView(customAlertViewBuildr : self)
        }
    }
}

extension CustomAlertView{
    
    //Create dialog with dual buttons
    func initDoubleBtnView(customAlertViewBuildr : CustomAlertViewBuilder) -> UIView{
//        let input = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?[0] as! AlertViewDialog
        let input = getBundle()?.loadNibNamed("AlertView", owner: nil, options: nil)?[0] as! AlertViewDialog
        
        //Updating title
        if customAlertViewBuildr.getTitle() != nil {
            input.lblTitle.text = customAlertViewBuildr.getTitle()
        }else{
            input.viewSeperator.isHidden = true
            input.titleTopConstraint.constant = 0
            input.titleBottomConstraint.constant = 0
        }
        
        //Updating message
        if (customAlertViewBuildr.getMessage() != nil){
            input.lblMessage.text = customAlertViewBuildr.getMessage()
            
            input.messageTextView.isHidden = true
        }
        else if(customAlertViewBuildr.getAttributeMessage() != nil){
            input.messageTextView.attributedText = customAlertViewBuildr.getAttributeMessage()
            input.messageTextView.isUserInteractionEnabled = true
            input.messageTextView.isEditable = false
            input.messageTextView.font = UIFont(name: "SourceSansPro-Light", size: 17)
            input.messageTextView.textAlignment = .center

            input.lblMessage.attributedText = customAlertViewBuildr.getAttributeMessage()
            input.lblMessage.textColor = UIColor.white
            
        }
        else{
            input.viewSeperator.isHidden = true
            input.messageTopConstraint.constant = 0
            input.messageBottomConstraint.constant = 0
        }
        
        //Updating short message
        if customAlertViewBuildr.getTitle() != nil {
            input.shortMessageLabel.text = customAlertViewBuildr.getShortMessage()
        }else{
            input.shortMessageLabel.text = ""
            input.shortMessageLabel.isHidden = true
        }
        
        //Set right button
        if customAlertViewBuildr.getRightButtonText() != nil {
            input.btnRight.addTarget(self, action: #selector(rigntButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
            input.btnRight.setTitle(customAlertViewBuildr.getRightButtonText(), for: .normal)
        }else{
            input.btnRight.isHidden = true
        }
        
        //Set left button
        if customAlertViewBuildr.getLeftButtonText() != nil {
            input.btnLeft.addTarget(self, action: #selector(leftButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
            input.btnLeft.setTitle(customAlertViewBuildr.getLeftButtonText(), for: .normal)
        }else{
            input.btnLeft.isHidden = true
//            input.buttonSeperator.isHidden = true
        }
        
        //If both buttons are not set, default OK button
        if customAlertViewBuildr.getRightButtonText() == nil && customAlertViewBuildr.getLeftButtonText() == nil {
            input.btnRight.addTarget(self, action: #selector(didTappedOnBackgroundView), for: UIControl.Event.touchUpInside)
            input.btnRight.setTitle("OK", for: .normal)
            input.btnRight.isHidden = false
//            input.buttonSeperator.isHidden = true
        }
        
        input.frame.origin = CGPoint(x: UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 10 : 128, y: frame.height/3)
        let reduceSize = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 20 : 254
        input.frame.size.width = frame.width - CGFloat(reduceSize)
        input.layoutIfNeeded()
        input.frame.size.height = input.viewBackground.frame.size.height
        input.layer.cornerRadius = 10
        input.clipsToBounds = true
        
        return input
    }
    
    func getBundle() -> Bundle? {
        var bundle: Bundle?
        if let urlString = Bundle.main.path(forResource: "EKYC", ofType: "framework", inDirectory: "Frameworks") {
            bundle = (Bundle(url: URL(fileURLWithPath: urlString)))
        }
            return bundle
    }
      
}

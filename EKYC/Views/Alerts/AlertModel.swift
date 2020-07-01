//
//  AlertModel.swift
//  NTB-MobileBanking
//
//  Created by Sameera Jayaratna on 7/30/18.
//  Copyright © 2018 Epic Lanka. All rights reserved.
//

import Foundation
import UIKit

protocol Modal {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

extension Modal where Self:UIView{
    func show(animated:Bool){
        self.backgroundView.alpha = 0
        if let currentView = UIApplication.shared.delegate?.window??.rootViewController?.view.viewWithTag(129956) {
            currentView.removeFromSuperview()
        }
        
//        let window = UIApplication.shared.keyWindow!.rootViewController?.view
//        window?.addSubview(self)
        self.tag = 129956
//        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        UIApplication.shared.delegate?.window??.rootViewController?.presentedViewController?.view.addSubview(self)
        
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.dialogView.center  = self.center
            }, completion: { (completed) in
                
            })
        }else{
            self.backgroundView.alpha = 0.66
            self.dialogView.center  = self.center
        }
    }
    
    func dismiss(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in
                
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        }else{self.backgroundView.alpha = 0
            self.removeFromSuperview()
            
        }
    }
}

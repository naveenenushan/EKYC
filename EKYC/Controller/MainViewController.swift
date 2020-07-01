//
//  MainViewController.swift
//  ekyc
//
//  Created by Chamara Thennakoon on 5/11/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = BACKGROUNDCOLOR
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .clear
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.navigationBar.backgroundColor = TITLEBACKGROUNDCOLOR
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: TITLETEXTCOLOR]
                self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barStyle = .black
        
        configureNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- configure Navigation bar
     func configureNavigationBar(){
                let bundel = getBundle()
        
          let button: UIButton = UIButton (type: UIButton.ButtonType.custom)
          let origImage = UIImage(named: "back-inverse", in: bundel, compatibleWith: nil)
          let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
          button.addTarget(self, action: #selector(backButtonPressed(btn:)), for: UIControl.Event.touchUpInside)
          button.frame = CGRect(x:0, y:0, width:30, height:30)
        button.tintColor = TITLETEXTCOLOR
          let barButton = UIBarButtonItem(customView: button)
          
          self.navigationItem.leftBarButtonItem = barButton
      }
    
    func getBundle() -> Bundle? {
        var bundle: Bundle?
        if let urlString = Bundle.main.path(forResource: "EKYC", ofType: "framework", inDirectory: "Frameworks") {
            bundle = (Bundle(url: URL(fileURLWithPath: urlString)))
        }
        
        
        
            return bundle
    }
      
      // MARK:- Navigation back button action
      @objc func backButtonPressed(btn : UIButton) {
          DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true, completion: nil)
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

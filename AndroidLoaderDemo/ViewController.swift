//
//  ViewController.swift
//  AndroidLoaderDemo
//
//  Created by Ravindra Sonkar on 08/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnAction(_ sender: Any) {
        addLoader("Please Wait for Response")
    }
    
    func addLoader(_ msgString : String?) {
        let loader = LoaderView()
        loader.msgLbl.text = msgString ?? "Please Wait" 
        loader.backgroundColor = .white
        loader.layer.cornerRadius = 5
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        mainView.backgroundColor = UIColor.clear
        mainView.tag = 1010101
        mainView.addSubview(loader)
        if let appWindow = UIApplication.shared.windows.first {
            appWindow.addSubview(mainView)
        }
        let horizontalConstraint = NSLayoutConstraint(item: loader, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: loader, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: loader, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1, constant: 30)
        let trailingConstraint = NSLayoutConstraint(item: loader, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: -30)
        let heightConstraint = NSLayoutConstraint(item: loader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70)
        mainView.addConstraints([horizontalConstraint, verticalConstraint,leadingConstraint,trailingConstraint,heightConstraint])
    }
    
    func removeLoader() {
        if let appWindow = UIApplication.shared.windows.first {
            appWindow.viewWithTag(1010101)?.removeFromSuperview()
        }
    }
}


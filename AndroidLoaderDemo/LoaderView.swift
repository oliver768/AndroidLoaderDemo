//
//  LoaderView.swift
//  AndroidLoaderDemo
//
//  Created by Ravindra Sonkar on 08/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    var msgLbl = UILabel()
    var fnLoaded = FNLoader()
    convenience init() {
        self.init(frame : CGRect(x: 30, y: UIScreen.main.bounds.height/2, width: (UIScreen.main.bounds.width - 60), height: 80))
        setUpUI()
    }
    
    func setUpUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        msgLbl.translatesAutoresizingMaskIntoConstraints = false
        msgLbl.lineBreakMode = .byWordWrapping
        msgLbl.numberOfLines = 0
        msgLbl.font = msgLbl.font.withSize(10)
        msgLbl.textAlignment = .left
        msgLbl.center = self.center
        fnLoaded.add()
        fnLoaded.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK:- FNLoader
        self.addSubview(fnLoaded)
        let verLoaderConst = NSLayoutConstraint(item: fnLoaded, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let leadLoaderConst = NSLayoutConstraint(item: fnLoaded, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        let heightLoaderConst = NSLayoutConstraint(item: fnLoaded, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45)
        let widthLoaderConst = NSLayoutConstraint(item: fnLoaded, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45)

        //MARK:- For Message Label inside Loader View
        self.addSubview(msgLbl)
        let topLblConst = NSLayoutConstraint(item: msgLbl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10)
        let bottomLblConst = NSLayoutConstraint(item: msgLbl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        let verticalLblConst = NSLayoutConstraint(item: msgLbl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let leadLblConst = NSLayoutConstraint(item: msgLbl, attribute: .leading, relatedBy: .equal, toItem: fnLoaded, attribute: .trailing, multiplier: 1, constant: 15)
        let trailLblConst = NSLayoutConstraint(item: msgLbl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30)
        self.addConstraints([verLoaderConst,leadLoaderConst,heightLoaderConst,widthLoaderConst,verticalLblConst,leadLblConst,trailLblConst,topLblConst,bottomLblConst])
    }
    
}

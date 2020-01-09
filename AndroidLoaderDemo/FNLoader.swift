//
//  FNLoader.swift
//
//  Created by Ravindra Sonkar on 08/01/20.
//  Copyright © 2019 Aditya. All rights reserved.
//


/*
 Kindly note this class is having lot of comment regarding the loader change. It is just to keep track the previous loader to check new changes are working fine or not. If they, then we will clean the code as per new requirements. Thanks
 */

import UIKit


public class FNLoaderView : UIView {
    
    public class var shared: FNLoaderView {
          struct Static {
              static let instance = FNLoaderView()
          }
          return Static.instance
      }
    
    convenience init() {
        self.init(frame: CGRect(x: 30, y: (DeviceInfo.height - 60)/2, width: DeviceInfo.width - 60, height: 60))
        self.setup()
    }

       override public init(frame: CGRect) {
           super.init(frame: frame)
           self.setup()
       }

       public required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.setup()
       }
    
    
    private func setup() {
        let indicator = FNLoader.shared
        self.addSubview(indicator)
    }
    
}

public class FNLoader: UIView {

    /*
     - Parameter: UIColor
     - Requires: UIColor
     - Description: variable to set the color of activity indicator. By default color is appThemeColor.
     */

    public var color: UIColor = UIColor.orange {
        didSet {
            indicator.strokeColor = color.cgColor
        }
    }

    /*
    - Parameter: CGFloat
    - Requires: CGFloat
    - Description: variable to set the line width of activity indicator. By default width is 4.0.
    */

    public var lineWidth: CGFloat = 4.0 {
        didSet {
            indicator.lineWidth = lineWidth
            setNeedsLayout()
        }
    }

    /*
    - Parameter: CGFloat
    - Requires: CGFloat
    - Description: variable to set the Radius of activity indicator. By default Radius is 4.0.
    */

    public var radius : CGFloat = 25 {
        didSet {
            self.frame = CGRect(x: self.center.x - 20, y: self.center.y - 20, width: radius * 2, height: radius * 2)
            setNeedsLayout()
        }
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: for make sure that only 1 object created for loader at a time.
    */

    public class var shared: FNLoader {
        struct Static {
            static let instance = FNLoader()
        }
        return Static.instance
    }

    private let indicator = CAShapeLayer()
    private let animator = FNActivityIndicatorAnimator()
    private var isAnimating = false
    private let indicatorTag = 17081993


    convenience init() {
        self.init(frame: .zero)
        self.setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Default Settings for activity indicator.
    */

    private func setup() {
        indicator.strokeColor = color.cgColor
        indicator.fillColor = nil
        indicator.lineWidth = lineWidth
        indicator.strokeStart = 0.0
        indicator.strokeEnd = 0.0
        indicator.lineCap = .round
        indicator.accessibilityValue = "FNLoader"
        indicator.accessibilityLabel = "FNLoader"
        layer.addSublayer(indicator)
    }

}

extension FNLoader {
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        indicator.frame = bounds
        let diameter =  CGFloat.minimum(bounds.size.width, bounds.size.height) - indicator.lineWidth
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: diameter / 2, startAngle: 0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
        indicator.path = path.cgPath
    }
}

extension FNLoader {

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Function to start animating the activity indicator on app window to show user that a task is running in background.
    */

    public func add() {
//        FNU.addLoadIndicator()
        guard !isAnimating else { return }
        animator.addAnimation(to: indicator)
//        setupActivityIndicatorViewOnWindow()
        isAnimating = true
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Function to stop animating the activity indicator on app window and remove all animations of loader and remove loader View.
    */

    public func remove() {
//        FNU.removeLoadIndicator()
        guard isAnimating else { return }
        animator.removeAnimation(from: indicator)
        UIApplication.shared.windows.first?.viewWithTag(indicatorTag)?.removeFromSuperview()
        isAnimating = false
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Function to set Fnloader frame on appWindow with a background view. Background View used here to Avoid any user interaction on screen. A indicator tag has been set on background view so that it can be removed when an activity completed.
    */

    private func setupActivityIndicatorViewOnWindow() {
        if let appWindow = UIApplication.shared.windows.first {
            let backGroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.frame.size =  CGSize(width: radius * 2, height: radius * 2)
            backGroundView.addSubview(self)
            backGroundView.tag = indicatorTag
            appWindow.addSubview(backGroundView)
        }
    }

}

final class FNActivityIndicatorAnimator {

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Enum made for frequently used animations of Swift Basic Animations.
    */

    private let animationDuration : TimeInterval = 2.0

    enum Animation: String {
        var key: String {
            return rawValue
        }

        case spring = "material.indicator.spring"
        case rotation = "material.indicator.rotation"
        case rotationZ = "transform.rotation.z"
        case strokeStart = "strokeStart"
        case strokeEnd = "strokeEnd"
    }

    /*
    - Parameter: CALayer
    - Requires: CALayer
    - Description: Function to start or add rotation animation with spring animation.
    */

    public func addAnimation(to layer: CALayer) {
        layer.add(rotationAnimation(), forKey: Animation.rotation.key)
        layer.add(springAnimation(), forKey: Animation.spring.key)
    }

    /*
    - Parameter: CALayer
    - Requires: CALayer
    - Description: Function to remove rotation animation with spring animation.
    */

    public func removeAnimation(from layer: CALayer) {
        layer.removeAnimation(forKey: Animation.spring.key)
    }
}

extension FNActivityIndicatorAnimator {

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs rotation animation on activity indicator using awesome swift animation CABasicAnimation. To increase the speed of animation decrease duration time using property animation.duration and vice-versa.
    */

    private func rotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.rotationZ.key)
        animation.fromValue = 0
        animation.toValue = (2.0 * .pi)
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a group of animations synchronously on activity indicator using awesome swift animation CAAnimationGroup.
    */

    private func springAnimation() -> CAAnimationGroup {
        let animation = CAAnimationGroup()
        animation.duration = self.animationDuration
        animation.isRemovedOnCompletion = false
        animation.animations = [
            rotationAnimation(),
            strokeStartAnimation(),
            strokeEndAnimation(),
            strokeCatchAnimation(),
            strokeFreezeAnimation()
        ]
        animation.repeatCount = .infinity
        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke start animations on activity indicator using awesome swift animation CABasicAnimation.
    */

    private func strokeStartAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeStart.key)
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 0
        animation.toValue = 0.15
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke end animations on activity indicator using awesome swift animation CABasicAnimation.
    */

    private func strokeEndAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeEnd.key)
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke start animations with catching the stroke from last position of stroke using awesome swift animation CABasicAnimation.
    */

    private func strokeCatchAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeStart.key)
        animation.beginTime = self.animationDuration / 2.0
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 0.15
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke freeze animation on last position of stroke using awesome swift animation CABasicAnimation.
    */

    private func strokeFreezeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeEnd.key)
        animation.beginTime = self.animationDuration / 2.0
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 1
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }

}

public struct DeviceInfo {
    
    public static var isIphone5:Bool { return DeviceInfo.typeIsLike == .iphone5 }
    public static var width:CGFloat { return UIScreen.main.bounds.size.width }
    public static var height:CGFloat { return UIScreen.main.bounds.size.height }
    public static var maxLength:CGFloat { return max(width, height) }
    public static var minLength:CGFloat { return min(width, height) }
    public static var zoomed:Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    public static var retina:Bool { return UIScreen.main.scale >= 2.0 }
    public static var phone:Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    public static var pad:Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    public static var carplay:Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    public static var tv:Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    public static var isSimulator:Bool { return UIDevice.current.isSimulator }
    public static var statusBar:CGRect { if #available(iOS 13.0, *) {
    return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? UIApplication.shared.statusBarFrame
    } else {
        return UIApplication.shared.statusBarFrame
        }
    }
    public static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
    
    public static var typeIsLike:DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        }
        else if phone && maxLength == 568 {
            return .iphone5
        }
        else if phone && maxLength == 667 {
            return .iphone6
        }
        else if phone && maxLength == 736 {
            return .iphone6plus
        }
        else if pad && !retina {
            return .iPadNonRetina
        }
        else if pad && retina && maxLength == 1024 {
            return .iPad
        }
        else if pad && maxLength == 1366 {
            return .iPadProBig
        }
        return .unknown
    }
    
    public struct Orientation {
        // indicate current device is in the LandScape orientation
        public static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        public static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}
public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    case iPadNonRetina
    case iPad
    case iPadProBig
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
}

public extension UIDevice {
    
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

//
//  KeyboardInfo.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/8.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit

struct KeyboardInfo {
  var animationCurve: UIView.AnimationCurve
  var animationDuration: Double
  var isLocal: Bool
  var frameBegin: CGRect
  var frameEnd: CGRect
}

extension KeyboardInfo {
  init?(_ notification: Notification) {
    guard notification.name == UIResponder.keyboardWillShowNotification ||
          notification.name == UIResponder.keyboardWillChangeFrameNotification else { return nil }
    let u = notification.userInfo!
    animationCurve = UIView.AnimationCurve(rawValue: u[UIWindow.keyboardAnimationCurveUserInfoKey] as! Int)!
    animationDuration = u[UIWindow.keyboardAnimationDurationUserInfoKey] as! Double
    isLocal = u[UIWindow.keyboardIsLocalUserInfoKey] as! Bool
    frameBegin = u[UIWindow.keyboardFrameBeginUserInfoKey] as! CGRect
    frameEnd = u[UIWindow.keyboardFrameEndUserInfoKey] as! CGRect
  }
}

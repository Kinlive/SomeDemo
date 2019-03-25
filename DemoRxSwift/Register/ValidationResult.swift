//
//  ValidationResult.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/2/15.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit

enum ValidationResult {
  case validating // 驗證中
  case empty // 輸入為空
  case ok(message: String) // 驗證通過
  case failed(message: String) // 驗證失敗
}

extension ValidationResult {
  var isValid: Bool {
    switch self {
    case .ok: return true
    default: return false
    }
  }
}

extension ValidationResult: CustomStringConvertible {
  var description: String {
    switch self {
    case .validating:
      return "正在驗證中"
    case .ok(let message):
      return message
    case .failed(let message):
      return message
    case .empty:
      return ""
    }
  }
}

extension ValidationResult {
  var textColor: UIColor {
    switch self {
    case .validating: return .gray
    case      .empty: return .black
    case         .ok: return UIColor(red: 0/255, green: 130/255, blue: 0/255, alpha: 1)
    case     .failed: return .red
    }
  }
}

//
//  LoginViewModel.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/2/13.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let minimalUsernameLength = 8
let minimalPasswordLength = 8

class LoginViewModel {


  // 起手式1 , 表列輸出項目
  let accountNameValid: Observable<Bool>
  let passwordValid: Observable<Bool>
  let everythingValid: Observable<Bool>

  let isUsersInfoCorrect: Observable<Bool>

  let disposeBag = DisposeBag()

  let loginModel = LoginModel()

  // 2. 將輸入轉換成輸出
  init(username: Observable<String>, password: Observable<String>) {
    accountNameValid = username
      .map { $0.count >= minimalUsernameLength }
      .share(replay: 1)
    passwordValid = password
      .map { $0.count >= minimalPasswordLength }
      .share(replay: 1)

    everythingValid = Observable<Bool>
      .combineLatest(accountNameValid, passwordValid) { $0 && $1 }
      .share(replay: 1)

    isUsersInfoCorrect = Observable
      .combineLatest(username, password)
      .map({ (username, password) in
        username == LoginModel.username &&
        password == LoginModel.password
    }).share(replay: 1)

  }

}


class LoginModel {
  static let username = "wwww1111"
  static let password = "qqqq1111"
}

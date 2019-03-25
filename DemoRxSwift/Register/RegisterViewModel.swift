//
//  RegisterViewModel.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/2/15.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewModel {

  let usernameValid: Observable<Bool>
  let passwordValid: Observable<Bool>
  let repeatPasswordValid: Observable<Bool>


//  let signupEnable: Observable<Bool>
//  let signedIn: Observable<Bool>
//  let signingIn: Observable<Bool>

  let everythingValid: Observable<Bool>

  init(input: (
    username: Observable<String>,
    password: Observable<String>,
    repeatPassword: Observable<String>,
    loginTaps: Observable<Void>)
    //, dependency: (
//    API: GitHubAPI,
//    validationService: GitHubValidationService,
//    wireframe: Wireframe)
       ) {

    usernameValid = input.username.map{ $0.count >= minimalUsernameLength }
    passwordValid = input.password.map { $0.count >= minimalPasswordLength }

    repeatPasswordValid = Observable
      .combineLatest(input.password, input.repeatPassword)
      .map{ $0 == $1 }
      .share(replay: 1)

    everythingValid = Observable
      .combineLatest(usernameValid,
                     passwordValid,
                     repeatPasswordValid)
      { usernameIsValid, passwordIsValid, repeatPasswordIsValid in
       usernameIsValid &&
        passwordIsValid &&
        repeatPasswordIsValid
      }
      .distinctUntilChanged()
      .share(replay: 1)
  }

}

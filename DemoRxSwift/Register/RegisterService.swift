//
//  RegisterService.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/2/15.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GitHubAPI {
  func usernameAvaible(_ username: String) -> Observable<Bool>
  func signup(_ username: String, _ password: String) -> Observable<Bool>
}

protocol GitHubValidationService {
  func validateUsername(_ username: String) -> Observable<ValidationResult>
  func validatePassword(_ password: String) -> ValidationResult
  func validateRepeatPassword(_ password: String, _ repeatPassword: String) -> ValidationResult
}

protocol Wireframe {
  func open(url: URL)
  // 提醒自己用泛型 func name<T: 為此泛型類別限定協定, 意思是傳入的cancelAction必須也遵循CustomStringConvertible才能帶入>
  func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

enum SignupState {
  case signedUp(signedUp: Bool)
}

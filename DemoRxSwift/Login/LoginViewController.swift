//
//  LoginViewController.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/1/31.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

  @IBOutlet weak var accountTf: UITextField!
  @IBOutlet weak var passwordTf: UITextField!
  @IBOutlet weak var userNameValidOutlet: UILabel!
  @IBOutlet weak var passwordValidOutlet: UILabel!
  @IBOutlet weak var confirmBtn: UIButton!

  let minimalUsernameLength = 8
  let minimalPasswordLength = 8
  let disposeBag = DisposeBag()

  private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

      /** 尚未改成MVVM架構的狀態
      let acountNameValid = accountTf.rx.text.orEmpty
        .map { $0.count >= self.minimalUsernameLength }
        .share(replay: 1)

      //用户名是否有效 -> 密码输入框是否可用
      acountNameValid
        .bind(to: passwordTf.rx.isEnabled)
        .disposed(by: disposeBag)

      // 用戶名是否有效, 提示訊息是否顯示
      acountNameValid
        .bind(to: tipMessage.rx.isHidden)
        .disposed(by: disposeBag)

      let passwordValid = passwordTf.rx.text.orEmpty
        .map { $0.count >= self.minimalPasswordLength }
        .share(replay: 1)

      passwordValid
        .bind(to: passwordTf.rx.isHidden)
        .disposed(by: disposeBag)

      let everythingValid = Observable
        .combineLatest(acountNameValid, passwordValid)
        { $0 && $1 } // 取用戶名和密碼同時有效
        .share(replay: 1)

      everythingValid
        .bind(to: confirmBtn.rx.isEnabled)
        .disposed(by: disposeBag)

      confirmBtn.rx.tap.subscribe(onNext: { [weak self] in self?.showAlert()})
        .disposed(by: disposeBag)
       */

      // 初始先隱藏
      userNameValidOutlet.isHidden = true
      passwordValidOutlet.isHidden = true

      bindEverything()

  }
    

  // 3. 在controller這邊進行對viewModel的綁定
  func bindEverything() {

    // 建立viewModel以將username及password的輸入轉換成viewModel輸出
    viewModel = LoginViewModel(
      username: accountTf.rx.text.orEmpty.asObservable(),
      password: passwordTf.rx.text.orEmpty.asObservable()
    )

    // 綁定以用戶名是否有效來控制 密碼輸入的啟用以及用戶名是否有效的提示訊息顯示
    viewModel.accountNameValid
      .bind(to: passwordTf.rx.isEnabled)
      .disposed(by: disposeBag)

    viewModel.accountNameValid
      .bind(to: userNameValidOutlet.rx.isHidden)
      .disposed(by: disposeBag)

    // 以密碼輸入是否有效來控制密碼提示訊息的顯示
    viewModel.passwordValid
      .bind(to: passwordValidOutlet.rx.isHidden)
      .disposed(by: disposeBag)

    // 以combineLatest(usernameValid, passwordValid) 兩者是否有效狀態控制 登入按鈕是否啟用
    viewModel.everythingValid
      .bind(to: confirmBtn.rx.isEnabled)
      .disposed(by: disposeBag)

    // 按鈕的touch event設定.
    confirmBtn.rx.tap
      .subscribe(onNext: { [unowned self] in
        var message: String = ""
        self.viewModel.isUsersInfoCorrect.subscribe(onNext: { userInfoCorrect in
          message = userInfoCorrect ? "Login success" : "username or password incorrect !!"
        }).disposed(by: self.disposeBag)
        self.showAlert(message: message)
      })
      .disposed(by: disposeBag)
  }

  func showAlert(message: String) {
    let alertView = UIAlertController(title: "Test rx", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertView.addAction(ok)
    present(alertView, animated: true, completion: nil)
  }
}

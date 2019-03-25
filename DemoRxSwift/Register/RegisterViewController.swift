//
//  RegisterViewController.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/2/15.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RegisterViewController: UIViewController {

  // UIs
  private let usernameTf: UITextField! = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.placeholder = "輸入註冊的使用者名稱"
    return tf
  }()

  private let usernameValidLbl: UILabel! = {
    let lb = UILabel()
    lb.backgroundColor = .darkGray
    return lb
  }()

  var usernameTipHeightConstraint: NSLayoutConstraint?

  private let passwordTf: UITextField! = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.placeholder = "輸入設定的密碼"
    return tf
  }()

  let tipMessageHeight: CGFloat = 20
  var passwordTipHeightCons: NSLayoutConstraint?
  private let passwordValidLabel: UILabel! = {
    let label = UILabel()
    label.backgroundColor = .darkGray
    return label
  }()

  private let repeatPasswordTf: UITextField! = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.placeholder = "再次輸入密碼"
    return tf
  }()

  var repeatPasswordTipHeightCons: NSLayoutConstraint?
  private let repeatPasswordValidLabel: UILabel! = {
    let label = UILabel()
    label.backgroundColor = .darkGray
    return label
  }()

  private let confirnBtn: UIButton! = {
    let btn = UIButton(type: .system)
    btn.titleLabel?.lineBreakMode = .byTruncatingTail
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    btn.backgroundColor = UIColor(red: 0/255, green: 180/255, blue: 0/255, alpha: 1.0)
    return btn
  }()

  var viewModel: RegisterViewModel!

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray
    setupUIConstraints { [unowned self] in
      self.bindUIs()
    }

    

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reloadInputViews()
  }

  func bindUIs() {
    viewModel = RegisterViewModel(
      input:(
      usernameTf.rx.text.orEmpty.asObservable(),
      passwordTf.rx.text.orEmpty.asObservable(),
      repeatPasswordTf.rx.text.orEmpty.asObservable(),
      confirnBtn.rx.tap.asObservable()
      )
//      , dependency: (
//        API: GitHubAPI,
//        validationService: GitHubValidationService,
//        wireframe: Wireframe)
    )

    // Username
    viewModel.usernameValid
      .bind(to: passwordTf.rx.isEnabled)
      .disposed(by: disposeBag)

    viewModel.usernameValid
      .map{ $0 }
      .subscribe(onNext: { [unowned self] isValid in
        self.usernameValidLbl.text = isValid ? "username correct" : "username's length must over than \(minimalUsernameLength)."
//        self.usernameValidLbl.isHidden = isValid
        self.usernameTipHeightConstraint?.constant = isValid ? 0 : self.tipMessageHeight
        self.view.autoresizesSubviews = true
      })
      .disposed(by: disposeBag)

    // Password
    viewModel.passwordValid
      .bind(to: repeatPasswordTf.rx.isEnabled)
      .disposed(by: disposeBag)

    viewModel.passwordValid
      .map { $0 }
      .subscribe(onNext: { [unowned self] isValid in
        self.passwordValidLabel.text = isValid ? "password ok" : "password length must over than \(minimalPasswordLength)"
//        self.passwordValidLabel.isHidden = isValid
        self.passwordTipHeightCons?.constant = isValid ? 0 : self.tipMessageHeight
        self.view.autoresizesSubviews = true
      })
      .disposed(by: disposeBag)

    // Repeat password
    viewModel.repeatPasswordValid
      .observeOn(MainScheduler.init())
      .map{ $0 }
      .subscribe(onNext: { [unowned self] isValid in
        self.repeatPasswordValidLabel.text = isValid ? "password correct" : "it's different with password"
//        self.repeatPasswordValidLabel.isHidden = isValid
        self.repeatPasswordTipHeightCons?.constant = isValid ? 0 : self.tipMessageHeight
        self.view.autoresizesSubviews = true
      })
      .disposed(by: disposeBag)

    viewModel.everythingValid
      .subscribe(onNext: { [ unowned self] everythingOk in
        self.confirnBtn.isEnabled = everythingOk
    }).disposed(by: disposeBag)

    confirnBtn.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.showAlert(message: "Show regist is success !!")
    })
      .disposed(by: disposeBag)

    // finish keyboard on input
    let tapBackground = UITapGestureRecognizer()
    tapBackground.rx.event
      .subscribe(onNext: { [unowned self] _ in
        self.view.endEditing(true)
      })
      .disposed(by: disposeBag)
    view.addGestureRecognizer(tapBackground)
  }

  func showAlert(message: String) {
    let alertView = UIAlertController(title: "Test rx", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertView.addAction(ok)
    present(alertView, animated: true, completion: nil)
  }
}

extension RegisterViewController {

  func setupUIConstraints(completion: () -> Void) {

    // username text field
    view.addSubview(usernameTf)
    usernameTf.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: usernameTf, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
    NSLayoutConstraint(item: usernameTf, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: usernameTf, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.7, constant: 0).isActive = true

    // username tip message label
    view.addSubview(usernameValidLbl)
    usernameValidLbl.translatesAutoresizingMaskIntoConstraints = false
    topConstraints(item: usernameValidLbl, toItem: usernameTf, constant: 10)
    leadingConstraints(item: usernameValidLbl, toItem: usernameTf)
    NSLayoutConstraint(item: usernameValidLbl, attribute: .width, relatedBy: .equal, toItem: usernameTf, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
    let usernameTipHeight = consistentHeight(item: usernameValidLbl, height: tipMessageHeight)
    NSLayoutConstraint.activate([usernameTipHeight])
    usernameTipHeightConstraint = usernameTipHeight

    // password text field
    view.addSubview(passwordTf)
    passwordTf.translatesAutoresizingMaskIntoConstraints = false
    topConstraints(item: passwordTf, toItem: usernameValidLbl, constant: 10)
    leadingConstraints(item: passwordTf, toItem: usernameTf)
    NSLayoutConstraint(item: passwordTf, attribute: .width, relatedBy: .equal, toItem: usernameTf, attribute: .width, multiplier: 1.0, constant: 0).isActive = true

    // password tip message label
    view.addSubview(passwordValidLabel)
    passwordValidLabel.translatesAutoresizingMaskIntoConstraints = false
    topConstraints(item: passwordValidLabel, toItem: passwordTf, constant: 10)
    leadingConstraints(item: passwordValidLabel, toItem: passwordTf)
    NSLayoutConstraint(item: passwordValidLabel, attribute: .width, relatedBy: .equal, toItem: usernameTf, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
    let height = consistentHeight(item: passwordValidLabel, height: tipMessageHeight)
    passwordTipHeightCons = height
    NSLayoutConstraint.activate([height])

    // repeat password text field
    view.addSubview(repeatPasswordTf)
    repeatPasswordTf.translatesAutoresizingMaskIntoConstraints = false
    topConstraints(item: repeatPasswordTf, toItem: passwordValidLabel, constant: 10)
    leadingConstraints(item: repeatPasswordTf, toItem: usernameTf)
    NSLayoutConstraint(item: repeatPasswordTf, attribute: .width, relatedBy: .equal, toItem: usernameTf, attribute: .width, multiplier: 1.0, constant: 0).isActive = true

    // repeat password tip message label
    view.addSubview(repeatPasswordValidLabel)
    repeatPasswordValidLabel.translatesAutoresizingMaskIntoConstraints = false
    topConstraints(item: repeatPasswordValidLabel, toItem: repeatPasswordTf, constant: 10)
    leadingConstraints(item: repeatPasswordValidLabel, toItem: repeatPasswordTf)
    NSLayoutConstraint(item: repeatPasswordValidLabel, attribute: .width, relatedBy: .equal, toItem: usernameTf, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
    let repeatPasswordTipHeight = consistentHeight(item: repeatPasswordValidLabel, height: tipMessageHeight)
    repeatPasswordTipHeightCons = repeatPasswordTipHeight
    NSLayoutConstraint.activate([repeatPasswordTipHeight])

    // confirm button
    view.addSubview(confirnBtn)
    confirnBtn.setTitle("註冊", for: .normal)
    confirnBtn.setTitleColor(.black, for: .normal)
    confirnBtn.translatesAutoresizingMaskIntoConstraints = false
    topConstraints(item: confirnBtn, toItem: repeatPasswordValidLabel, constant: 10)
    leadingConstraints(item: confirnBtn, toItem: usernameTf)
    NSLayoutConstraint(item: confirnBtn, attribute: .width, relatedBy: .equal, toItem: usernameTf, attribute: .width, multiplier: 0.7, constant: 0).isActive = true
    let confirnBtnHeight = consistentHeight(item: confirnBtn, height: 50)
    NSLayoutConstraint.activate([confirnBtnHeight])
    completion()
  }
}


extension RegisterViewController {

  // 相等的貼齊leading對象
  func leadingConstraints<UI>(item: UI, toItem: UI, mutiplier: CGFloat = 1, constant: CGFloat = 0) {
    NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: mutiplier, constant: constant).isActive = true
  }

  // 設定 top 對象, 被設定對象貼齊對象2下緣
  func topConstraints<UI>(item: UI, toItem: UI, mutiplier: CGFloat = 1, constant: CGFloat = 0) {
    NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: mutiplier, constant: constant).isActive = true
  }

  func consistentHeight<UI>(item: UI, height: CGFloat) -> NSLayoutConstraint {
    let height = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height)
    return height
  }
}


